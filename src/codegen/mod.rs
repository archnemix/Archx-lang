//! LLVM IR code generation orchestrator, struct/method layout resolution, and core `Codegen` state.
//! Coordinates static analyses, statement/loop/expression/method/I/O lowering, RAII ownership, and runtime helpers.

mod analysis;
mod calls;
mod expr;
mod io;
mod loops;
mod memory;
mod methods;
mod ownership;
mod runtime;
mod runtime_py;
mod stmt;
#[cfg(test)]
mod tests;

use self::analysis::*;
use crate::ast::{Func, Param, Program, StructDef, Type};
use crate::diag::{Diagnostic, Result, Span};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

pub(super) const BUILTINS: [&str; 5] = ["print", "input", "len", "push", "pop"];
pub(super) const PRIMITIVE_TYPES: [&str; 6] = ["int", "float", "bool", "string", "str", "void"];
pub(super) const MAX_ARRAY_LEN: i64 = 1_i64 << 47;
pub(super) const MAX_STR_LEN: i64 = i32::MAX as i64;
pub(super) const MAX_NESTING: usize = 128;

/// Lowers an Archx program to textual LLVM IR:
/// - Hardened zero-UB integer & IEEE-754 `double` arithmetic + checked allocations
/// - Deterministic linear/RAII zero-leak ownership across scopes, temps, & early exits
/// - `fastcc` internal ABI + first-class `class`/`struct` methods + transparent local `SoA` splitting
/// - 16-byte inline-prefix SSO `%ArchxStr` (`<= 12` bytes in 2 registers, 0 heap allocs)
/// - Escape-checked `region:` / `with region:` bump-pointer arenas with slab reuse
pub fn lower(program: &Program) -> Result<String> {
    let mut struct_map: HashMap<String, Vec<Param>> = HashMap::new();
    let mut struct_spans: HashMap<String, Span> = HashMap::new();

    for sdef in &program.structs {
        if BUILTINS.contains(&sdef.name.as_str()) || PRIMITIVE_TYPES.contains(&sdef.name.as_str()) {
            return Err(Diagnostic::new(
                format!("`{}` is a reserved name and cannot be a class/struct", sdef.name),
                sdef.span,
            ));
        }
        if struct_map.contains_key(&sdef.name) {
            return Err(Diagnostic::new(
                format!("struct `{}` is defined more than once", sdef.name),
                sdef.span,
            ));
        }
        let mut seen_fields = HashSet::new();
        for f in &sdef.fields {
            if f.ty == Type::Void {
                return Err(Diagnostic::new(
                    format!("field `{}` of `{}` cannot have type `void`", f.name, sdef.name),
                    sdef.span,
                ));
            }
            if !seen_fields.insert(f.name.as_str()) {
                return Err(Diagnostic::new(
                    format!("duplicate field `{}` in struct `{}`", f.name, sdef.name),
                    sdef.span,
                ));
            }
        }
        struct_map.insert(sdef.name.clone(), sdef.fields.clone());
        struct_spans.insert(sdef.name.clone(), sdef.span);
    }

    for sdef in &program.structs {
        for f in &sdef.fields {
            validate_type(&f.ty, &struct_map, sdef.span)?;
        }
    }

    let ordered_structs = topo_sort_structs(&program.structs, &struct_map, &struct_spans)?;

    let mut sigs = HashMap::new();
    let mut methods: HashMap<(String, String), MethodSig> = HashMap::new();
    let mut mutating_method_names: HashSet<String> = ["append", "pop", "clear"]
        .into_iter()
        .map(String::from)
        .collect();
    let mut any_sig_uses_vec = false;
    let mut any_sig_uses_str = false;

    // First pass over struct methods to register signatures and detect `self` mutators.
    for sdef in &program.structs {
        for m in &sdef.methods {
            let key = (sdef.name.clone(), m.name.clone());
            if methods.contains_key(&key) {
                return Err(Diagnostic::new(
                    format!("method `{}` in `{}` is defined more than once", m.name, sdef.name),
                    m.span,
                ));
            }
            let mut seen_params = HashSet::new();
            for param in &m.params {
                if param.ty == Type::Void {
                    return Err(Diagnostic::new(
                        "a parameter cannot have type `void`",
                        m.span,
                    ));
                }
                validate_type(&param.ty, &struct_map, m.span)?;
                mark_type_usage(&param.ty, &mut any_sig_uses_vec, &mut any_sig_uses_str);
                if !seen_params.insert(param.name.as_str()) {
                    return Err(Diagnostic::new(
                        format!("duplicate parameter `{}`", param.name),
                        m.span,
                    ));
                }
            }
            let ret = match &m.ret {
                Some(Type::Void) | None => None,
                Some(ty) => {
                    validate_type(ty, &struct_map, m.span)?;
                    mark_type_usage(ty, &mut any_sig_uses_vec, &mut any_sig_uses_str);
                    Some(ty.clone())
                }
            };
            let self_by_ptr = method_mutates_self(&m.params, &m.body);
            if self_by_ptr {
                mutating_method_names.insert(m.name.clone());
            }
            methods.insert(
                key,
                MethodSig {
                    ir_name: mangle_method(&sdef.name, &m.name),
                    self_by_ptr,
                    params: m.params[1..].iter().map(|p| p.ty.clone()).collect(),
                    ret,
                },
            );
        }
    }

    // Fixed-point propagation if a method calls another mutating method on `self`:
    loop {
        let mut changed = false;
        for sdef in &program.structs {
            for m in &sdef.methods {
                let key = (sdef.name.clone(), m.name.clone());
                let sig = methods.get(&key).unwrap();
                if !sig.self_by_ptr
                    && collect_mutated_vars(&m.params, &m.body, &mutating_method_names)
                        .contains("self")
                {
                    methods.get_mut(&key).unwrap().self_by_ptr = true;
                    mutating_method_names.insert(m.name.clone());
                    changed = true;
                }
            }
        }
        if !changed {
            break;
        }
    }

    for func in &program.funcs {
        if BUILTINS.contains(&func.name.as_str()) || PRIMITIVE_TYPES.contains(&func.name.as_str()) {
            return Err(Diagnostic::new(
                format!("`{}` is a builtin/type and cannot be redefined", func.name),
                func.span,
            ));
        }
        if struct_map.contains_key(&func.name) {
            return Err(Diagnostic::new(
                format!(
                    "function `{}` conflicts with struct `{}` of the same name",
                    func.name, func.name
                ),
                func.span,
            ));
        }
        if sigs.contains_key(&func.name) {
            return Err(Diagnostic::new(
                format!("function `{}` is defined more than once", func.name),
                func.span,
            ));
        }

        let mut seen_params = HashSet::new();
        for param in &func.params {
            if param.ty == Type::Void {
                return Err(Diagnostic::new(
                    "a parameter cannot have type `void`",
                    func.span,
                ));
            }
            validate_type(&param.ty, &struct_map, func.span)?;
            mark_type_usage(&param.ty, &mut any_sig_uses_vec, &mut any_sig_uses_str);
            if !seen_params.insert(param.name.as_str()) {
                return Err(Diagnostic::new(
                    format!("duplicate parameter `{}`", param.name),
                    func.span,
                ));
            }
        }

        let ret = match &func.ret {
            Some(Type::Void) | None => None,
            Some(ty) => {
                validate_type(ty, &struct_map, func.span)?;
                mark_type_usage(ty, &mut any_sig_uses_vec, &mut any_sig_uses_str);
                Some(ty.clone())
            }
        };

        if func.name == "main" {
            if !func.params.is_empty() {
                return Err(Diagnostic::new("`main` cannot take parameters", func.span));
            }
            if let Some(ty) = &ret {
                if *ty != Type::Int {
                    return Err(Diagnostic::new(
                        "`main` must return `int` or nothing",
                        func.span,
                    ));
                }
            }
        }

        sigs.insert(
            func.name.clone(),
            FuncSig {
                params: func.params.iter().map(|p| p.ty.clone()).collect(),
                ret,
            },
        );
    }

    if !sigs.contains_key("main") {
        return Err(Diagnostic::new("no `main` function found", Span::new(1, 1)));
    }

    for fields in struct_map.values() {
        for f in fields {
            mark_type_usage(&f.ty, &mut any_sig_uses_vec, &mut any_sig_uses_str);
        }
    }

    let mut cg = Codegen {
        strings: StringTable::new(),
        structs: struct_map,
        sigs,
        methods,
        mutating_method_names,
        scopes: Vec::new(),
        stmt_temps: Vec::new(),
        mutated_vars: HashSet::new(),
        returned_vars: HashSet::new(),
        loop_stack: Vec::new(),
        loop_bounds: Vec::new(),
        region_stack: Vec::new(),
        func_region_slot: None,
        break_count: 0,
        depth: 0,
        next_tmp: 0,
        next_label: 0,
        terminated: false,
        current_ret: None,
        is_main: false,
        allocas: String::new(),
        extra_helpers: String::new(),
        emitted_vec_drops: HashSet::new(),
        emitted_vec_clones: HashSet::new(),
        used_vec_type: any_sig_uses_vec,
        used_str_type: any_sig_uses_str,
        used_region: false,
        used_malloc: false,
        used_calloc: false,
        used_realloc: false,
        used_free: false,
        used_memset: false,
        used_memcpy: false,
        used_smul_ovf: false,
        used_array_print: false,
        used_print_inline: false,
        used_print_float: false,
        used_str_eq: false,
        used_str_concat: false,
        used_str_print: false,
        used_str_drop: false,
        used_str_clone: false,
        used_str_promote: false,
        used_str_from_int: false,
        used_str_from_float: false,
        used_int_from_str: false,
        used_float_from_str: false,
        used_input: false,
        used_str_repeat: false,
        used_str_find: false,
        used_str_starts_ends: false,
        used_str_strip: false,
        used_str_case: false,
        used_str_split_ws: false,
        used_str_split_sep: false,
        used_str_replace: false,
        used_str_byte_at: false,
        used_pow_f64: false,
        used_floor_f64: false,
        used_fabs_f64: false,
        used_sqrt_f64: false,
        used_fptosi_sat: false,
        used_bounds_fail: false,
        used_neg_len_fail: false,
        used_pop_empty_fail: false,
        used_div_zero_fail: false,
        used_neg_exp_fail: false,
        used_zero_step_fail: false,
        used_parse_fail: false,
        used_assert_fail: false,
        used_oom_fail: false,
    };

    let mut bodies = String::new();
    for sdef in &program.structs {
        for m in &sdef.methods {
            cg.gen_method(&sdef.name, m, &mut bodies)?;
        }
    }
    for func in &program.funcs {
        cg.gen_func(func, &mut bodies)?;
    }

    cg.finalize_runtime_flags();

    if cg.used_str_eq
        || cg.used_str_concat
        || cg.used_str_print
        || cg.used_str_drop
        || cg.used_str_clone
        || cg.used_str_promote
        || cg.used_str_from_int
        || cg.used_str_from_float
        || cg.used_int_from_str
        || cg.used_float_from_str
        || cg.used_input
        || cg.used_str_repeat
        || cg.used_str_find
        || cg.used_str_starts_ends
        || cg.used_str_strip
        || cg.used_str_case
        || cg.used_str_split_ws
        || cg.used_str_split_sep
        || cg.used_str_replace
        || cg.used_str_byte_at
        || cg.used_assert_fail
    {
        cg.used_str_type = true;
    }
    if cg.used_str_split_ws || cg.used_str_split_sep {
        cg.used_vec_type = true;
    }
    if cg.used_str_concat {
        cg.used_str_clone = true;
    }

    let mut out = String::new();
    out.push_str("; Archx LLVM IR module\n\n");

    if cg.used_vec_type {
        out.push_str("%ArchxVec = type { i64, i64, ptr }\n");
    }
    if cg.used_str_type {
        out.push_str("%ArchxStr = type { i64, i64 }\n");
    }
    if cg.used_region {
        out.push_str("%ArchxRegion = type { ptr, ptr, ptr, ptr }\n");
    }
    for sname in &ordered_structs {
        let fields = &cg.structs[sname];
        let _ = write!(out, "%ArchxStruct_{sname} = type {{ ");
        for (i, f) in fields.iter().enumerate() {
            if i > 0 {
                out.push_str(", ");
            }
            out.push_str(&ir_type(&f.ty));
        }
        out.push_str(" }\n");
    }
    if cg.used_vec_type || cg.used_str_type || cg.used_region || !ordered_structs.is_empty() {
        out.push('\n');
    }

    emit_cstr_global(&mut out, "@.fmt.str", "%s\n");
    emit_cstr_global(&mut out, "@.fmt.int", "%lld\n");
    emit_cstr_global(&mut out, "@.str.true", "true");
    emit_cstr_global(&mut out, "@.str.false", "false");
    if cg.used_print_inline || cg.used_array_print {
        emit_cstr_global(&mut out, "@.fmt.int.elem", "%lld");
        emit_cstr_global(&mut out, "@.fmt.str.elem", "%s");
        emit_cstr_global(&mut out, "@.str.none", "None");
    }
    if cg.used_array_print {
        emit_cstr_global(&mut out, "@.fmt.lbrack", "[");
        emit_cstr_global(&mut out, "@.fmt.sep", ", ");
        emit_cstr_global(&mut out, "@.fmt.rbrack", "]\n");
        emit_cstr_global(&mut out, "@.fmt.rbrack.inline", "]");
    }
    if cg.used_print_float || cg.used_str_from_float {
        emit_cstr_global(&mut out, "@.fmt.g15", "%.15g");
    }
    for (i, value) in cg.strings.values.iter().enumerate() {
        // `align 4` guarantees low 2 tag bits == 00 (`STATIC` tag) on all targets.
        emit_cstr_global_aligned(&mut out, &format!("@.str.{i}"), value, 4);
    }
    out.push('\n');

    out.push_str(&bodies);
    out.push_str(&cg.extra_helpers);
    cg.emit_runtime_helpers(&mut out);
    cg.emit_pythonic_runtime_helpers(&mut out);

    Ok(out)
}

pub(super) fn validate_type(
    ty: &Type,
    structs: &HashMap<String, Vec<Param>>,
    span: Span,
) -> Result<()> {
    match ty {
        Type::Int | Type::Float | Type::Bool | Type::Str | Type::Void => Ok(()),
        Type::Array(inner) => validate_type(inner, structs, span),
        Type::Struct(name) => {
            if structs.contains_key(name) {
                Ok(())
            } else {
                Err(Diagnostic::new(format!("unknown type `{name}`"), span))
            }
        }
    }
}

pub(super) fn mark_type_usage(ty: &Type, used_vec: &mut bool, used_str: &mut bool) {
    match ty {
        Type::Array(inner) => {
            *used_vec = true;
            mark_type_usage(inner, used_vec, used_str);
        }
        Type::Str => *used_str = true,
        _ => {}
    }
}

pub(super) fn topo_sort_structs(
    defs: &[StructDef],
    map: &HashMap<String, Vec<Param>>,
    spans: &HashMap<String, Span>,
) -> Result<Vec<String>> {
    #[derive(Clone, Copy, PartialEq, Eq)]
    enum State {
        Visiting,
        Visited,
    }
    let mut state: HashMap<String, State> = HashMap::new();
    let mut ordered = Vec::new();

    pub(super) fn dfs(
        name: &str,
        map: &HashMap<String, Vec<Param>>,
        spans: &HashMap<String, Span>,
        state: &mut HashMap<String, State>,
        ordered: &mut Vec<String>,
    ) -> Result<()> {
        match state.get(name).copied() {
            Some(State::Visited) => return Ok(()),
            Some(State::Visiting) => {
                return Err(Diagnostic::new(
                    format!("recursive struct `{name}` has infinite size"),
                    spans[name],
                ));
            }
            None => {}
        }
        state.insert(name.to_string(), State::Visiting);
        for f in &map[name] {
            if let Type::Struct(dep) = &f.ty {
                dfs(dep, map, spans, state, ordered)?;
            }
        }
        state.insert(name.to_string(), State::Visited);
        ordered.push(name.to_string());
        Ok(())
    }

    for d in defs {
        dfs(&d.name, map, spans, &mut state, &mut ordered)?;
    }
    Ok(ordered)
}

#[derive(Clone)]
pub(super) struct FuncSig {
    pub(super) params: Vec<Type>,
    pub(super) ret: Option<Type>,
}

#[derive(Clone)]
pub(super) struct MethodSig {
    pub(super) ir_name: String,
    pub(super) self_by_ptr: bool,
    pub(super) params: Vec<Type>,
    pub(super) ret: Option<Type>,
}

#[derive(Clone)]
pub(super) enum VarStorage {
    Imm(String),
    Slot(String),
    Soa {
        struct_name: String,
        len_val: String,
        planes: Vec<(Type, String)>,
    },
}

#[derive(Clone)]
pub(super) struct VarEntry {
    pub(super) ty: Type,
    pub(super) storage: VarStorage,
    pub(super) is_param: bool,
    pub(super) region_depth: usize,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub(super) enum KnownLen {
    Const(i64),
    SameAsVar(String),
    SameAsArray(String),
}

#[derive(Clone)]
pub(super) enum DropTarget {
    DataPtr(String),
    TypedSlot { ptr: String, ty: Type },
}

#[derive(Clone)]
pub(super) struct TempDrop {
    pub(super) val: String,
    pub(super) ty: Type,
}

#[derive(Default)]
pub(super) struct Scope {
    pub(super) vars: HashMap<String, VarEntry>,
    pub(super) known_lens: HashMap<String, KnownLen>,
    pub(super) bounded_vars: HashSet<String>,
    pub(super) owned_buffers: Vec<DropTarget>,
}

#[derive(Clone)]
pub(super) enum RegionSave {
    Root,
    Nested {
        saved_cur: String,
        saved_end: String,
        saved_tail: String,
    },
}

pub(super) struct LoopLabels {
    pub(super) break_label: String,
    pub(super) continue_label: String,
    pub(super) scope_depth: usize,
    pub(super) region_depth: usize,
}

#[derive(Clone, Debug)]
pub(super) struct InductionBound {
    pub(super) var: String,
    pub(super) upper: UpperBound,
}

#[derive(Clone, Debug)]
pub(super) enum UpperBound {
    Const(i64),
    Var(String),
    LenOf(String),
}

#[derive(Clone)]
pub(super) enum StrideVal {
    Const,
    Var(String),
}

#[derive(Clone)]
pub(super) enum WhileBoundKind {
    Var(String),
    LenOf(String),
}

pub(super) struct StridedWhilePlan {
    pub(super) idx_slot: String,
    pub(super) stride: StrideVal,
    pub(super) bound: WhileBoundKind,
    pub(super) proven_bound: InductionBound,
}

pub(super) struct StringTable {
    pub(super) values: Vec<String>,
    pub(super) index: HashMap<String, usize>,
}

impl StringTable {
    pub(super) fn new() -> Self {
        Self {
            values: Vec::new(),
            index: HashMap::new(),
        }
    }

    pub(super) fn intern(&mut self, value: &str) -> String {
        if let Some(&i) = self.index.get(value) {
            return format!("@.str.{i}");
        }
        let i = self.values.len();
        self.values.push(value.to_string());
        self.index.insert(value.to_string(), i);
        format!("@.str.{i}")
    }
}

pub(super) struct Codegen {
    pub(super) strings: StringTable,
    pub(super) structs: HashMap<String, Vec<Param>>,
    pub(super) sigs: HashMap<String, FuncSig>,
    pub(super) methods: HashMap<(String, String), MethodSig>,
    pub(super) mutating_method_names: HashSet<String>,
    pub(super) scopes: Vec<Scope>,
    pub(super) stmt_temps: Vec<TempDrop>,
    pub(super) mutated_vars: HashSet<String>,
    pub(super) returned_vars: HashSet<String>,
    pub(super) loop_stack: Vec<LoopLabels>,
    pub(super) loop_bounds: Vec<InductionBound>,
    pub(super) region_stack: Vec<RegionSave>,
    pub(super) func_region_slot: Option<String>,
    pub(super) break_count: usize,
    pub(super) depth: usize,
    pub(super) next_tmp: usize,
    pub(super) next_label: usize,
    pub(super) terminated: bool,
    pub(super) current_ret: Option<Type>,
    pub(super) is_main: bool,
    pub(super) allocas: String,
    pub(super) extra_helpers: String,
    pub(super) emitted_vec_drops: HashSet<String>,
    pub(super) emitted_vec_clones: HashSet<String>,
    pub(super) used_vec_type: bool,
    pub(super) used_str_type: bool,
    pub(super) used_region: bool,
    pub(super) used_malloc: bool,
    pub(super) used_calloc: bool,
    pub(super) used_realloc: bool,
    pub(super) used_free: bool,
    pub(super) used_memset: bool,
    pub(super) used_memcpy: bool,
    pub(super) used_smul_ovf: bool,
    pub(super) used_array_print: bool,
    pub(super) used_print_inline: bool,
    pub(super) used_print_float: bool,
    pub(super) used_str_eq: bool,
    pub(super) used_str_concat: bool,
    pub(super) used_str_print: bool,
    pub(super) used_str_drop: bool,
    pub(super) used_str_clone: bool,
    pub(super) used_str_promote: bool,
    pub(super) used_str_from_int: bool,
    pub(super) used_str_from_float: bool,
    pub(super) used_int_from_str: bool,
    pub(super) used_float_from_str: bool,
    pub(super) used_input: bool,
    pub(super) used_str_repeat: bool,
    pub(super) used_str_find: bool,
    pub(super) used_str_starts_ends: bool,
    pub(super) used_str_strip: bool,
    pub(super) used_str_case: bool,
    pub(super) used_str_split_ws: bool,
    pub(super) used_str_split_sep: bool,
    pub(super) used_str_replace: bool,
    pub(super) used_str_byte_at: bool,
    pub(super) used_pow_f64: bool,
    pub(super) used_floor_f64: bool,
    pub(super) used_fabs_f64: bool,
    pub(super) used_sqrt_f64: bool,
    pub(super) used_fptosi_sat: bool,
    pub(super) used_bounds_fail: bool,
    pub(super) used_neg_len_fail: bool,
    pub(super) used_pop_empty_fail: bool,
    pub(super) used_div_zero_fail: bool,
    pub(super) used_neg_exp_fail: bool,
    pub(super) used_zero_step_fail: bool,
    pub(super) used_parse_fail: bool,
    pub(super) used_assert_fail: bool,
    pub(super) used_oom_fail: bool,
}

impl Codegen {
    pub(super) fn gen_func(&mut self, func: &Func, out: &mut String) -> Result<()> {
        self.scopes = vec![Scope::default()];
        self.stmt_temps.clear();
        self.mutated_vars =
            collect_mutated_vars(&func.params, &func.body, &self.mutating_method_names);
        self.returned_vars = collect_returned_vars(&func.body);
        self.loop_stack.clear();
        self.loop_bounds.clear();
        self.region_stack.clear();
        self.func_region_slot = None;
        self.break_count = 0;
        self.depth = 0;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;
        self.is_main = func.name == "main";
        self.allocas.clear();

        let ir_ret = if self.is_main {
            "i32".to_string()
        } else {
            ir_ret_type(func.ret.as_ref())
        };

        self.current_ret = if self.is_main {
            Some(Type::Int)
        } else {
            match &func.ret {
                Some(Type::Void) => None,
                other => other.clone(),
            }
        };

        let mut header = String::new();
        if self.is_main {
            let _ = write!(header, "define i32 @main(");
        } else {
            let _ = write!(header, "define internal fastcc {ir_ret} {}(", mangle(&func.name));
        }
        for (i, param) in func.params.iter().enumerate() {
            if i > 0 {
                header.push_str(", ");
            }
            let _ = write!(header, "{} %arg.{}", ir_type(&param.ty), param.name);
        }
        header.push_str(") {");

        let mut body = String::new();
        if stmts_use_region(&func.body) {
            self.used_region = true;
            let rslot = "%func.region".to_string();
            let _ = writeln!(self.allocas, "  {rslot} = alloca %ArchxRegion, align 8");
            let _ = writeln!(
                body,
                "  store %ArchxRegion zeroinitializer, ptr {rslot}, align 8"
            );
            self.func_region_slot = Some(rslot);
        }

        for param in &func.params {
            let arg_ssa = format!("%arg.{}", param.name);
            let is_mut = self.mutated_vars.contains(&param.name);
            let storage = if is_mut {
                let ty_ir = ir_type(&param.ty);
                let align = ir_align(&param.ty);
                let ptr = self.next_slot(&format!("param.{}", param.name));
                let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}, align {align}");
                let init_val = if self.type_needs_drop(&param.ty) {
                    self.emit_clone_value(&param.ty, &arg_ssa, &mut body)
                } else {
                    arg_ssa
                };
                let _ = writeln!(body, "  store {ty_ir} {init_val}, ptr {ptr}, align {align}");
                if self.type_needs_drop(&param.ty) {
                    self.scopes[0].owned_buffers.push(DropTarget::TypedSlot {
                        ptr: ptr.clone(),
                        ty: param.ty.clone(),
                    });
                }
                VarStorage::Slot(ptr)
            } else {
                VarStorage::Imm(arg_ssa)
            };

            self.scopes[0].vars.insert(
                param.name.clone(),
                VarEntry {
                    ty: param.ty.clone(),
                    storage,
                    is_param: !is_mut,
                    region_depth: 0,
                },
            );
        }

        self.gen_block(&func.body, &mut body)?;

        if !self.terminated {
            if self.is_main {
                self.emit_func_exit_cleanup(None, &mut body);
                body.push_str("  ret i32 0\n");
            } else if self.current_ret.is_none() {
                self.emit_func_exit_cleanup(None, &mut body);
                body.push_str("  ret void\n");
            } else {
                return Err(Diagnostic::new(
                    format!(
                        "function `{}` must return a value on every path",
                        func.name
                    ),
                    func.span,
                ));
            }
        }

        let _ = writeln!(out, "{header}");
        let _ = writeln!(out, "entry:");
        out.push_str(&self.allocas);
        out.push_str(&body);
        let _ = writeln!(out, "}}\n");
        Ok(())
    }

    pub(super) fn emit_func_exit_cleanup(&mut self, skip_slot: Option<&str>, out: &mut String) {
        self.emit_drops_down_to(0, skip_slot, out);
        if let Some(rslot) = self.func_region_slot.clone() {
            let head_gep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {head_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 2"
            );
            let head = self.next_tmp();
            let _ = writeln!(out, "  {head} = load ptr, ptr {head_gep}, align 8");
            let _ = writeln!(
                out,
                "  call fastcc void @archx_region_release_from(ptr {head})"
            );
        }
    }

    pub(super) fn enter_depth(&mut self, span: Span) -> Result<()> {
        self.depth += 1;
        if self.depth > MAX_NESTING {
            self.depth -= 1;
            return Err(Diagnostic::new(
                format!("maximum nesting depth ({MAX_NESTING}) exceeded"),
                span,
            ));
        }
        Ok(())
    }

    pub(super) fn active_region_arg(&self) -> String {
        if !self.region_stack.is_empty() {
            self.func_region_slot.clone().unwrap()
        } else {
            "null".to_string()
        }
    }

    pub(super) fn lookup_var(&self, name: &str) -> Option<&VarEntry> {
        for scope in self.scopes.iter().rev() {
            if let Some(entry) = scope.vars.get(name) {
                return Some(entry);
            }
        }
        None
    }

    pub(super) fn lookup_known_len(&self, name: &str) -> Option<&KnownLen> {
        for scope in self.scopes.iter().rev() {
            if let Some(k) = scope.known_lens.get(name) {
                return Some(k);
            }
        }
        None
    }

    pub(super) fn next_tmp(&mut self) -> String {
        let id = self.next_tmp;
        self.next_tmp += 1;
        format!("%t{id}")
    }

    pub(super) fn next_slot(&mut self, hint: &str) -> String {
        let id = self.next_tmp;
        self.next_tmp += 1;
        let clean: String = hint
            .chars()
            .map(|c| {
                if c.is_ascii_alphanumeric() || c == '.' || c == '_' {
                    c
                } else {
                    '_'
                }
            })
            .collect();
        format!("%{clean}.{id}")
    }

    pub(super) fn fresh_label(&mut self, prefix: &str) -> String {
        let id = self.next_label;
        self.next_label += 1;
        format!("{prefix}.{id}")
    }

    pub(super) fn start_block(&mut self, label: &str, out: &mut String) {
        let _ = writeln!(out, "{label}:");
        self.terminated = false;
    }

    pub(super) fn emit_br(&mut self, target: &str, out: &mut String) {
        let _ = writeln!(out, "  br label %{target}");
        self.terminated = true;
    }

    pub(super) fn emit_cond_br(&mut self, cond: &str, then_lbl: &str, else_lbl: &str, out: &mut String) {
        let _ = writeln!(
            out,
            "  br i1 {cond}, label %{then_lbl}, label %{else_lbl}"
        );
        self.terminated = true;
    }
}

// ============================================================================
// LLVM IR formatting helpers
// ============================================================================

pub(super) fn mangle(name: &str) -> String {
    format!("@archx_fn_{name}")
}

pub(super) fn mangle_method(struct_name: &str, method_name: &str) -> String {
    format!("@archx_method_{}_{struct_name}_{method_name}", struct_name.len())
}

pub(super) fn format_llvm_double(v: f64) -> String {
    format!("0x{:016X}", v.to_bits())
}

pub(super) fn type_mangle_key(ty: &Type) -> String {
    match ty {
        Type::Int => "i".to_string(),
        Type::Float => "f".to_string(),
        Type::Bool => "b".to_string(),
        Type::Str => "s".to_string(),
        Type::Void => "v".to_string(),
        Type::Struct(name) => format!("S{}_{name}", name.len()),
        Type::Array(inner) => format!("A_{}", type_mangle_key(inner)),
    }
}

pub(super) fn ir_type(ty: &Type) -> String {
    match ty {
        Type::Int => "i64".to_string(),
        Type::Float => "double".to_string(),
        Type::Bool => "i1".to_string(),
        Type::Str => "%ArchxStr".to_string(),
        Type::Array(_) => "%ArchxVec".to_string(),
        Type::Struct(name) => format!("%ArchxStruct_{name}"),
        Type::Void => "void".to_string(),
    }
}

pub(super) fn ir_align(ty: &Type) -> u32 {
    match ty {
        Type::Bool => 1,
        Type::Int | Type::Float | Type::Str | Type::Array(_) | Type::Struct(_) => 8,
        Type::Void => 1,
    }
}

pub(super) fn elem_mem_ir_type(ty: &Type) -> String {
    match ty {
        Type::Bool => "i8".to_string(),
        other => ir_type(other),
    }
}

pub(super) fn ir_ret_type(ty: Option<&Type>) -> String {
    match ty {
        Some(Type::Void) | None => "void".to_string(),
        Some(t) => ir_type(t),
    }
}

pub(super) fn emit_cstr_global(out: &mut String, name: &str, value: &str) {
    emit_cstr_global_aligned(out, name, value, 1);
}

pub(super) fn emit_cstr_global_aligned(out: &mut String, name: &str, value: &str, align: u32) {
    let bytes = value.as_bytes();
    let len = bytes.len() + 1;
    let _ = write!(
        out,
        "{name} = private unnamed_addr constant [{len} x i8] c\""
    );
    for &b in bytes {
        if (0x20..=0x7E).contains(&b) && b != b'"' && b != b'\\' {
            out.push(b as char);
        } else {
            let _ = write!(out, "\\{b:02X}");
        }
    }
    let _ = writeln!(out, "\\00\", align {align}");
}

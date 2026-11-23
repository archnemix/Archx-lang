use crate::ast::{
    AssignTarget, BinOp, Expr, ExprKind, Func, Param, Program, Stmt, StmtKind, StructDef, Type,
    UnOp,
};
use crate::diag::{Diagnostic, Result, Span};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

const BUILTINS: [&str; 4] = ["print", "len", "push", "pop"];
const PRIMITIVE_TYPES: [&str; 4] = ["int", "bool", "string", "void"];
const MAX_ARRAY_LEN: i64 = 1_i64 << 47;
const MAX_STR_LEN: i64 = i32::MAX as i64;
const MAX_NESTING: usize = 128;

/// Lowers an Archx program to textual LLVM IR:
/// - Hardened zero-UB arithmetic & checked allocations
/// - Deterministic linear/RAII zero-leak ownership across scopes, temps, & early exits
/// - `fastcc` internal ABI + first-class `struct` aggregates + transparent local `SoA` splitting
/// - 16-byte inline-prefix SSO `%ArchxStr` (`<= 12` bytes in 2 registers, 0 heap allocs)
/// - Escape-checked `region:` bump-pointer arenas with slab reuse across loop iterations
pub fn lower(program: &Program) -> Result<String> {
    let mut struct_map: HashMap<String, Vec<Param>> = HashMap::new();
    let mut struct_spans: HashMap<String, Span> = HashMap::new();

    for sdef in &program.structs {
        if BUILTINS.contains(&sdef.name.as_str()) || PRIMITIVE_TYPES.contains(&sdef.name.as_str()) {
            return Err(Diagnostic::new(
                format!("`{}` is a reserved name and cannot be a struct", sdef.name),
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
    let mut any_sig_uses_vec = false;
    let mut any_sig_uses_str = false;

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
        used_str_eq: false,
        used_str_concat: false,
        used_str_print: false,
        used_str_drop: false,
        used_str_clone: false,
        used_str_promote: false,
        used_bounds_fail: false,
        used_neg_len_fail: false,
        used_pop_empty_fail: false,
        used_div_zero_fail: false,
        used_oom_fail: false,
    };

    let mut bodies = String::new();
    for func in &program.funcs {
        cg.gen_func(func, &mut bodies)?;
    }

    if cg.used_str_eq
        || cg.used_str_concat
        || cg.used_str_print
        || cg.used_str_drop
        || cg.used_str_clone
        || cg.used_str_promote
    {
        cg.used_str_type = true;
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
    if cg.used_array_print {
        emit_cstr_global(&mut out, "@.fmt.lbrack", "[");
        emit_cstr_global(&mut out, "@.fmt.sep", ", ");
        emit_cstr_global(&mut out, "@.fmt.rbrack", "]\n");
        emit_cstr_global(&mut out, "@.fmt.int.elem", "%lld");
        emit_cstr_global(&mut out, "@.fmt.str.elem", "%s");
    }
    for (i, value) in cg.strings.values.iter().enumerate() {
        // `align 4` guarantees low 2 tag bits == 00 (`STATIC` tag) on all targets.
        emit_cstr_global_aligned(&mut out, &format!("@.str.{i}"), value, 4);
    }
    out.push('\n');

    out.push_str(&bodies);
    out.push_str(&cg.extra_helpers);
    cg.emit_runtime_helpers(&mut out);

    Ok(out)
}

fn validate_type(
    ty: &Type,
    structs: &HashMap<String, Vec<Param>>,
    span: Span,
) -> Result<()> {
    match ty {
        Type::Int | Type::Bool | Type::Str | Type::Void => Ok(()),
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

fn mark_type_usage(ty: &Type, used_vec: &mut bool, used_str: &mut bool) {
    match ty {
        Type::Array(inner) => {
            *used_vec = true;
            mark_type_usage(inner, used_vec, used_str);
        }
        Type::Str => *used_str = true,
        _ => {}
    }
}

fn topo_sort_structs(
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

    fn dfs(
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
struct FuncSig {
    params: Vec<Type>,
    ret: Option<Type>,
}

#[derive(Clone)]
enum VarStorage {
    Imm(String),
    Slot(String),
    Soa {
        struct_name: String,
        len_val: String,
        planes: Vec<(Type, String)>,
    },
}

#[derive(Clone)]
struct VarEntry {
    ty: Type,
    storage: VarStorage,
    is_param: bool,
    region_depth: usize,
}

#[derive(Clone, Debug, PartialEq, Eq)]
enum KnownLen {
    Const(i64),
    SameAsVar(String),
    SameAsArray(String),
}

#[derive(Clone)]
enum DropTarget {
    DataPtr(String),
    TypedSlot { ptr: String, ty: Type },
}

#[derive(Clone)]
struct TempDrop {
    val: String,
    ty: Type,
}

#[derive(Default)]
struct Scope {
    vars: HashMap<String, VarEntry>,
    known_lens: HashMap<String, KnownLen>,
    bounded_vars: HashSet<String>,
    owned_buffers: Vec<DropTarget>,
}

#[derive(Clone)]
struct RegionSave {
    saved_cur: String,
    saved_end: String,
    saved_tail: String,
}

struct LoopLabels {
    break_label: String,
    continue_label: String,
    scope_depth: usize,
    region_depth: usize,
}

#[derive(Clone, Debug)]
struct InductionBound {
    var: String,
    upper: UpperBound,
}

#[derive(Clone, Debug)]
enum UpperBound {
    Const(i64),
    Var(String),
    LenOf(String),
}

#[derive(Clone)]
enum StrideVal {
    Const,
    Var(String),
}

#[derive(Clone)]
enum WhileBoundKind {
    Var(String),
    LenOf(String),
}

struct StridedWhilePlan {
    idx_slot: String,
    stride: StrideVal,
    bound: WhileBoundKind,
    proven_bound: InductionBound,
}

struct StringTable {
    values: Vec<String>,
    index: HashMap<String, usize>,
}

impl StringTable {
    fn new() -> Self {
        Self {
            values: Vec::new(),
            index: HashMap::new(),
        }
    }

    fn intern(&mut self, value: &str) -> String {
        if let Some(&i) = self.index.get(value) {
            return format!("@.str.{i}");
        }
        let i = self.values.len();
        self.values.push(value.to_string());
        self.index.insert(value.to_string(), i);
        format!("@.str.{i}")
    }
}

struct Codegen {
    strings: StringTable,
    structs: HashMap<String, Vec<Param>>,
    sigs: HashMap<String, FuncSig>,
    scopes: Vec<Scope>,
    stmt_temps: Vec<TempDrop>,
    mutated_vars: HashSet<String>,
    returned_vars: HashSet<String>,
    loop_stack: Vec<LoopLabels>,
    loop_bounds: Vec<InductionBound>,
    region_stack: Vec<RegionSave>,
    func_region_slot: Option<String>,
    break_count: usize,
    depth: usize,
    next_tmp: usize,
    next_label: usize,
    terminated: bool,
    current_ret: Option<Type>,
    is_main: bool,
    allocas: String,
    extra_helpers: String,
    emitted_vec_drops: HashSet<String>,
    emitted_vec_clones: HashSet<String>,
    used_vec_type: bool,
    used_str_type: bool,
    used_region: bool,
    used_malloc: bool,
    used_calloc: bool,
    used_realloc: bool,
    used_free: bool,
    used_memset: bool,
    used_memcpy: bool,
    used_smul_ovf: bool,
    used_array_print: bool,
    used_str_eq: bool,
    used_str_concat: bool,
    used_str_print: bool,
    used_str_drop: bool,
    used_str_clone: bool,
    used_str_promote: bool,
    used_bounds_fail: bool,
    used_neg_len_fail: bool,
    used_pop_empty_fail: bool,
    used_div_zero_fail: bool,
    used_oom_fail: bool,
}

impl Codegen {
    fn gen_func(&mut self, func: &Func, out: &mut String) -> Result<()> {
        self.scopes = vec![Scope::default()];
        self.stmt_temps.clear();
        self.mutated_vars = collect_mutated_vars(&func.body);
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

    fn emit_func_exit_cleanup(&mut self, skip_slot: Option<&str>, out: &mut String) {
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

    fn enter_depth(&mut self, span: Span) -> Result<()> {
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

    fn gen_block(&mut self, stmts: &[Stmt], out: &mut String) -> Result<()> {
        for (idx, stmt) in stmts.iter().enumerate() {
            self.gen_stmt(stmt, &stmts[idx + 1..], out)?;
        }
        Ok(())
    }

    fn gen_stmt(&mut self, stmt: &Stmt, rest_in_block: &[Stmt], out: &mut String) -> Result<()> {
        self.enter_depth(stmt.span)?;
        let res = self.gen_stmt_inner(stmt, rest_in_block, out);
        self.depth -= 1;
        res
    }

    fn gen_stmt_inner(
        &mut self,
        stmt: &Stmt,
        rest_in_block: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        if self.terminated {
            let dead = self.fresh_label("dead");
            self.start_block(&dead, out);
        }

        match &stmt.kind {
            StmtKind::Let {
                name,
                ty: declared_ty,
                value,
            } => {
                if self.lookup_var(name).is_some() {
                    return Err(Diagnostic::new(
                        format!("variable `{name}` is already defined in this scope"),
                        stmt.span,
                    ));
                }

                if let Some(t) = declared_ty {
                    if *t == Type::Void {
                        return Err(Diagnostic::new(
                            "cannot declare a variable of type `void`",
                            stmt.span,
                        ));
                    }
                    validate_type(t, &self.structs, stmt.span)?;
                    if t.is_array() {
                        self.used_vec_type = true;
                    }
                    if *t == Type::Str {
                        self.used_str_type = true;
                    }
                }

                let is_mutated = self.mutated_vars.contains(name);

                if !is_mutated && self.region_stack.is_empty() {
                    if let Some(soa_storage) = self.try_emit_transparent_soa(
                        name,
                        declared_ty.as_ref(),
                        value,
                        rest_in_block,
                        out,
                    )? {
                        self.flush_stmt_temps(out);
                        let sname = match &soa_storage {
                            VarStorage::Soa { struct_name, .. } => struct_name.clone(),
                            _ => unreachable!(),
                        };
                        self.scopes.last_mut().unwrap().vars.insert(
                            name.clone(),
                            VarEntry {
                                ty: Type::Array(Box::new(Type::Struct(sname))),
                                storage: soa_storage,
                                is_param: false,
                                region_depth: self.region_stack.len(),
                            },
                        );
                        return Ok(());
                    }
                }

                let (ty, raw_val) = self.eval_expr_typed(value, declared_ty.as_ref(), out)?;
                if ty == Type::Void {
                    return Err(Diagnostic::new(
                        "cannot store a `void` value in a variable",
                        stmt.span,
                    ));
                }
                if let Some(expected) = declared_ty {
                    if *expected != ty {
                        return Err(Diagnostic::new(
                            format!(
                                "type mismatch in `let {name}`: expected `{}`, found `{}`",
                                expected.name(),
                                ty.name()
                            ),
                            stmt.span,
                        ));
                    }
                }

                if !is_mutated && ty.is_array() {
                    if let Some(known) = self.infer_known_array_len(value) {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .known_lens
                            .insert(name.clone(), known);
                    }
                }

                let needs_drop = self.type_needs_drop(&ty);
                let val = if needs_drop && !matches!(&value.kind, ExprKind::Str(_)) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(&ty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                self.flush_stmt_temps(out);

                let is_returned = self.returned_vars.contains(name);
                let is_1d_pod_array = matches!(
                    &ty,
                    Type::Array(elem) if matches!(elem.as_ref(), Type::Int | Type::Bool)
                );
                let is_const_safe_str = ty == Type::Str && matches!(&value.kind, ExprKind::Str(_));
                let is_region_pod_vec = !self.region_stack.is_empty()
                    && is_1d_pod_array
                    && matches!(
                        &value.kind,
                        ExprKind::ArrayLit(_) | ExprKind::ArrayRepeat { .. }
                    );

                let storage = if !is_mutated
                    && (!needs_drop || is_const_safe_str || (is_region_pod_vec && !is_returned))
                {
                    VarStorage::Imm(val)
                } else if !is_mutated
                    && is_1d_pod_array
                    && !is_returned
                    && self.region_stack.is_empty()
                {
                    let is_empty_lit =
                        matches!(&value.kind, ExprKind::ArrayLit(es) if es.is_empty());
                    if !is_empty_lit {
                        let data_ptr = self.next_tmp();
                        let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {val}, 2");
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .owned_buffers
                            .push(DropTarget::DataPtr(data_ptr));
                    }
                    VarStorage::Imm(val)
                } else {
                    let ptr = self.next_slot(&format!("var.{name}"));
                    let ty_ir = ir_type(&ty);
                    let align = ir_align(&ty);
                    let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}, align {align}");
                    let _ = writeln!(out, "  store {ty_ir} {val}, ptr {ptr}, align {align}");

                    if needs_drop && !is_region_pod_vec {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .owned_buffers
                            .push(DropTarget::TypedSlot {
                                ptr: ptr.clone(),
                                ty: ty.clone(),
                            });
                    }
                    VarStorage::Slot(ptr)
                };

                self.scopes.last_mut().unwrap().vars.insert(
                    name.clone(),
                    VarEntry {
                        ty,
                        storage,
                        is_param: false,
                        region_depth: self.region_stack.len(),
                    },
                );
                Ok(())
            }

            StmtKind::Return(value) => {
                if let Some(expr) = value {
                    let expected_hint = self.current_ret.clone();
                    if let ExprKind::Var(vname) = &expr.kind {
                        if let Some(entry) = self.lookup_var(vname).cloned() {
                            if !entry.is_param
                                && self.type_needs_drop(&entry.ty)
                                && matches!(entry.storage, VarStorage::Slot(_))
                            {
                                if let Some(expected) = &expected_hint {
                                    if *expected != entry.ty {
                                        return Err(Diagnostic::new(
                                            format!(
                                                "`return` type mismatch: expected `{}`, found `{}`",
                                                expected.name(),
                                                entry.ty.name()
                                            ),
                                            stmt.span,
                                        ));
                                    }
                                } else if !self.is_main {
                                    return Err(Diagnostic::new(
                                        "this function does not return a value",
                                        stmt.span,
                                    ));
                                }
                                let VarStorage::Slot(slot_ptr) = entry.storage else {
                                    unreachable!()
                                };
                                let ty_ir = ir_type(&entry.ty);
                                let align = ir_align(&entry.ty);
                                let loaded = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {loaded} = load {ty_ir}, ptr {slot_ptr}, align {align}"
                                );
                                let final_val = if !self.region_stack.is_empty() {
                                    self.emit_promote_to_heap(&entry.ty, &loaded, out)
                                } else {
                                    loaded
                                };
                                self.flush_stmt_temps(out);
                                self.emit_func_exit_cleanup(Some(&slot_ptr), out);
                                let _ = writeln!(out, "  ret {ty_ir} {final_val}");
                                self.terminated = true;
                                return Ok(());
                            }
                        }
                    }

                    let (ty, raw_val) = self.eval_expr_typed(expr, expected_hint.as_ref(), out)?;

                    if self.is_main {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "`main` must return an `int`",
                                stmt.span,
                            ));
                        }
                        self.flush_stmt_temps(out);
                        self.emit_func_exit_cleanup(None, out);
                        let truncated = self.next_tmp();
                        let _ = writeln!(out, "  {truncated} = trunc i64 {raw_val} to i32");
                        let _ = writeln!(out, "  ret i32 {truncated}");
                        self.terminated = true;
                        return Ok(());
                    }

                    match self.current_ret.clone() {
                        Some(expected) if expected == ty => {
                            let owned_val = if self.type_needs_drop(&ty) {
                                let v = if self.claim_stmt_temp(&raw_val) {
                                    raw_val
                                } else {
                                    self.emit_clone_value(&ty, &raw_val, out)
                                };
                                if !self.region_stack.is_empty() {
                                    self.emit_promote_to_heap(&ty, &v, out)
                                } else {
                                    v
                                }
                            } else {
                                raw_val
                            };
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            let _ = writeln!(out, "  ret {} {}", ir_type(&ty), owned_val);
                        }
                        Some(expected) => {
                            return Err(Diagnostic::new(
                                format!(
                                    "`return` type mismatch: expected `{}`, found `{}`",
                                    expected.name(),
                                    ty.name()
                                ),
                                stmt.span,
                            ));
                        }
                        None => {
                            return Err(Diagnostic::new(
                                "this function does not return a value",
                                stmt.span,
                            ));
                        }
                    }
                } else if self.is_main {
                    self.flush_stmt_temps(out);
                    self.emit_func_exit_cleanup(None, out);
                    out.push_str("  ret i32 0\n");
                } else {
                    match self.current_ret {
                        Some(_) => {
                            return Err(Diagnostic::new(
                                "this function must return a value",
                                stmt.span,
                            ));
                        }
                        None => {
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            out.push_str("  ret void\n");
                        }
                    }
                }

                self.terminated = true;
                Ok(())
            }

            StmtKind::Expr(expr) => {
                self.eval_expr(expr, out)?;
                self.flush_stmt_temps(out);
                Ok(())
            }

            StmtKind::Assign { target, op, value } => {
                self.gen_assign(target, *op, value, stmt.span, out)?;
                self.flush_stmt_temps(out);
                Ok(())
            }

            StmtKind::While { cond, body } => self.gen_while(cond, body, out),

            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
            } => self.gen_for(var, start, end, step.as_ref(), body, stmt.span, out),

            StmtKind::ForEach { var, iter, body } => {
                self.gen_foreach(var, iter, body, stmt.span, out)
            }

            StmtKind::Region { body } => self.gen_region(body, out),

            StmtKind::Break => {
                let (label, sdepth, rdepth) = self
                    .loop_stack
                    .last()
                    .map(|l| (l.break_label.clone(), l.scope_depth, l.region_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`break` is only allowed inside a loop", stmt.span)
                    })?;
                self.emit_drops_down_to(sdepth, None, out);
                self.emit_region_exits_down_to(rdepth, out);
                self.break_count += 1;
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::Continue => {
                let (label, sdepth, rdepth) = self
                    .loop_stack
                    .last()
                    .map(|l| (l.continue_label.clone(), l.scope_depth, l.region_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`continue` is only allowed inside a loop", stmt.span)
                    })?;
                self.emit_drops_down_to(sdepth, None, out);
                self.emit_region_exits_down_to(rdepth, out);
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
                if cond_ty != Type::Bool {
                    return Err(Diagnostic::new(
                        "`if` condition must be a `bool`",
                        cond.span,
                    ));
                }
                self.flush_stmt_temps(out);

                let then_label = self.fresh_label("if.then");
                let else_label = self.fresh_label("if.else");
                let merge_label = self.fresh_label("if.merge");

                self.emit_cond_br(&cond_val, &then_label, &else_label, out);

                self.start_block(&then_label, out);
                self.push_scope();
                self.gen_block(then_body, out)?;
                self.pop_scope_with_drops(out);
                let then_terminated = self.terminated;
                if !then_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&else_label, out);
                if let Some(body) = else_body {
                    self.push_scope();
                    self.gen_block(body, out)?;
                    self.pop_scope_with_drops(out);
                }
                let else_terminated = self.terminated;
                if !else_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&merge_label, out);
                if then_terminated && else_terminated {
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                }
                Ok(())
            }
        }
    }

    fn gen_region(&mut self, body: &[Stmt], out: &mut String) -> Result<()> {
        let rslot = self.func_region_slot.clone().expect("func_region_slot set");

        let saved_cur = self.next_tmp();
        let _ = writeln!(out, "  {saved_cur} = load ptr, ptr {rslot}, align 8");
        let end_gep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {end_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 1"
        );
        let saved_end = self.next_tmp();
        let _ = writeln!(out, "  {saved_end} = load ptr, ptr {end_gep}, align 8");
        let tail_gep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {tail_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 3"
        );
        let saved_tail = self.next_tmp();
        let _ = writeln!(out, "  {saved_tail} = load ptr, ptr {tail_gep}, align 8");

        self.push_scope();
        let rsave = RegionSave {
            saved_cur,
            saved_end,
            saved_tail,
        };
        self.region_stack.push(rsave.clone());

        self.gen_block(body, out)?;

        self.region_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_single_region_exit(&rsave, out);
        }
        Ok(())
    }

    fn emit_single_region_exit(&mut self, rsave: &RegionSave, out: &mut String) {
        let rslot = self.func_region_slot.clone().unwrap();
        let _ = writeln!(
            out,
            "  store ptr {}, ptr {rslot}, align 8",
            rsave.saved_cur
        );
        let end_gep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {end_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 1"
        );
        let _ = writeln!(out, "  store ptr {}, ptr {end_gep}, align 8", rsave.saved_end);
        let tail_gep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {tail_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 3"
        );
        let _ = writeln!(
            out,
            "  store ptr {}, ptr {tail_gep}, align 8",
            rsave.saved_tail
        );
    }

    fn emit_region_exits_down_to(&mut self, target_depth: usize, out: &mut String) {
        if let Some(outer) = self.region_stack.get(target_depth).cloned() {
            self.emit_single_region_exit(&outer, out);
        }
    }

    // ---------------- Transparent SoA lowering -------------------------------

    fn try_emit_transparent_soa(
        &mut self,
        var_name: &str,
        declared_ty: Option<&Type>,
        value: &Expr,
        rest_in_block: &[Stmt],
        out: &mut String,
    ) -> Result<Option<VarStorage>> {
        let ExprKind::ArrayRepeat {
            value: elem_expr,
            count: count_expr,
        } = &value.kind
        else {
            return Ok(None);
        };
        let ExprKind::Call {
            name: sname,
            args: field_args,
        } = &elem_expr.kind
        else {
            return Ok(None);
        };
        let Some(fields) = self.structs.get(sname).cloned() else {
            return Ok(None);
        };
        if fields.len() < 2
            || !fields
                .iter()
                .all(|f| matches!(f.ty, Type::Int | Type::Bool))
        {
            return Ok(None);
        }
        if let Some(decl) = declared_ty {
            if *decl != Type::Array(Box::new(Type::Struct(sname.clone()))) {
                return Ok(None);
            }
        }
        if var_escapes_soa(rest_in_block, var_name) {
            return Ok(None);
        }

        if field_args.len() != fields.len() {
            return Err(Diagnostic::new(
                format!(
                    "struct `{sname}` expects {} field{}, found {}",
                    fields.len(),
                    if fields.len() == 1 { "" } else { "s" },
                    field_args.len()
                ),
                elem_expr.span,
            ));
        }

        let mut init_vals = Vec::with_capacity(fields.len());
        for (i, arg) in field_args.iter().enumerate() {
            let (fty, fval) = self.eval_expr_typed(arg, Some(&fields[i].ty), out)?;
            if fty != fields[i].ty {
                return Err(Diagnostic::new(
                    format!(
                        "field `{}` of `{sname}` expects `{}`, found `{}`",
                        fields[i].name,
                        fields[i].ty.name(),
                        fty.name()
                    ),
                    arg.span,
                ));
            }
            init_vals.push((fty, fval));
        }

        let (count_ty, count_val) = self.eval_expr(count_expr, out)?;
        if count_ty != Type::Int {
            return Err(Diagnostic::new(
                format!(
                    "array repeat count must be `int`, found `{}`",
                    count_ty.name()
                ),
                count_expr.span,
            ));
        }

        self.emit_repeat_count_check(count_expr, &count_val, out)?;

        if let Some(known) = self.infer_known_array_len(value) {
            self.scopes
                .last_mut()
                .unwrap()
                .known_lens
                .insert(var_name.to_string(), known);
        }

        let mut planes = Vec::with_capacity(fields.len());
        for (fty, init_val) in init_vals {
            let elem_size = if fty == Type::Bool { 1 } else { 8 };
            let is_zero = (fty == Type::Int && init_val == "0")
                || (fty == Type::Bool && init_val == "false");
            let plane_ptr = if is_zero {
                self.emit_checked_calloc(&count_val, elem_size, out)
            } else {
                let bytes = self.emit_elem_bytes_mul(&count_val, elem_size, out);
                let p = self.emit_checked_malloc(&bytes, out);
                self.emit_scalar_fill_loop(&fty, &init_val, &p, &count_val, out);
                p
            };
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::DataPtr(plane_ptr.clone()));
            planes.push((fty, plane_ptr));
        }

        Ok(Some(VarStorage::Soa {
            struct_name: sname.clone(),
            len_val: count_val,
            planes,
        }))
    }

    // ---------------- Loops --------------------------------------------------

    fn gen_while(&mut self, cond: &Expr, body: &[Stmt], out: &mut String) -> Result<()> {
        if let Some(plan) = self.analyze_strided_while(cond, body) {
            let fast_cond = self.fresh_label("while.fast.cond");
            let fast_body = self.fresh_label("while.fast.body");
            let slow_cond = self.fresh_label("while.cond");
            let slow_body = self.fresh_label("while.body");
            let end_label = self.fresh_label("while.end");

            let j0 = self.next_tmp();
            let _ = writeln!(out, "  {j0} = load i64, ptr {}, align 8", plan.idx_slot);
            let j_ok = self.next_tmp();
            let _ = writeln!(out, "  {j_ok} = icmp sge i64 {j0}, 0");

            let bound_val = match &plan.bound {
                WhileBoundKind::Var(bname) => self.load_var_ssa(bname, out),
                WhileBoundKind::LenOf(aname) => self.load_array_len_ssa(aname, out),
            };
            let b_ok = self.next_tmp();
            let _ = writeln!(out, "  {b_ok} = icmp ule i64 {bound_val}, {MAX_ARRAY_LEN}");
            let jb_ok = self.next_tmp();
            let _ = writeln!(out, "  {jb_ok} = and i1 {j_ok}, {b_ok}");

            let all_ok = match &plan.stride {
                StrideVal::Const => jb_ok,
                StrideVal::Var(sname) => {
                    let sv = self.load_var_ssa(sname, out);
                    let sm1 = self.next_tmp();
                    let _ = writeln!(out, "  {sm1} = sub i64 {sv}, 1");
                    let s_ok = self.next_tmp();
                    let _ = writeln!(out, "  {s_ok} = icmp ult i64 {sm1}, {MAX_ARRAY_LEN}");
                    let comb = self.next_tmp();
                    let _ = writeln!(out, "  {comb} = and i1 {jb_ok}, {s_ok}");
                    comb
                }
            };
            self.emit_cond_br(&all_ok, &fast_cond, &slow_cond, out);

            self.start_block(&fast_cond, out);
            let jf = self.next_tmp();
            let _ = writeln!(out, "  {jf} = load i64, ptr {}, align 8", plan.idx_slot);
            let cf = self.next_tmp();
            let _ = writeln!(out, "  {cf} = icmp slt i64 {jf}, {bound_val}");
            self.emit_cond_br(&cf, &fast_body, &end_label, out);

            self.start_block(&fast_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.loop_bounds.push(plan.proven_bound);
            self.loop_stack.push(LoopLabels {
                break_label: end_label.clone(),
                continue_label: fast_cond.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            self.loop_bounds.pop();
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&fast_cond, out);
            }

            self.start_block(&slow_cond, out);
            let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
            if cond_ty != Type::Bool {
                return Err(Diagnostic::new(
                    "`while` condition must be a `bool`",
                    cond.span,
                ));
            }
            self.flush_stmt_temps(out);
            self.emit_cond_br(&cond_val, &slow_body, &end_label, out);

            self.start_block(&slow_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.loop_stack.push(LoopLabels {
                break_label: end_label.clone(),
                continue_label: slow_cond.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&slow_cond, out);
            }

            self.start_block(&end_label, out);
            return Ok(());
        }

        let cond_label = self.fresh_label("while.cond");
        let body_label = self.fresh_label("while.body");
        let end_label = self.fresh_label("while.end");

        self.emit_br(&cond_label, out);

        self.start_block(&cond_label, out);
        let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
        if cond_ty != Type::Bool {
            return Err(Diagnostic::new(
                "`while` condition must be a `bool`",
                cond.span,
            ));
        }
        self.flush_stmt_temps(out);
        self.emit_cond_br(&cond_val, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let breaks_before = self.break_count;
        self.loop_stack.push(LoopLabels {
            break_label: end_label.clone(),
            continue_label: cond_label.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&cond_label, out);
        }

        let always_true = matches!(&cond.kind, ExprKind::Bool(true));
        let had_break = self.break_count > breaks_before;

        self.start_block(&end_label, out);
        if always_true && !had_break {
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;
        }
        Ok(())
    }

    fn gen_for(
        &mut self,
        var: &str,
        start: &Expr,
        end: &Expr,
        step_opt: Option<&Expr>,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let (start_ty, start_val) = self.eval_expr(start, out)?;
        if start_ty != Type::Int {
            return Err(Diagnostic::new("`for` start must be an `int`", start.span));
        }
        let (end_ty, end_val) = self.eval_expr(end, out)?;
        if end_ty != Type::Int {
            return Err(Diagnostic::new("`for` end must be an `int`", end.span));
        }

        let (step_val, step_guaranteed_safe) = if let Some(se) = step_opt {
            let (sty, sval) = self.eval_expr(se, out)?;
            if sty != Type::Int {
                return Err(Diagnostic::new("`for` step must be an `int`", se.span));
            }
            if let Some(c) = eval_const_int(se) {
                if c <= 0 {
                    return Err(Diagnostic::new(
                        format!("`for` step must be positive, found `{c}`"),
                        se.span,
                    ));
                }
                if c > MAX_ARRAY_LEN {
                    return Err(Diagnostic::new(
                        format!("`for` step `{c}` exceeds maximum range stride"),
                        se.span,
                    ));
                }
                (sval, true)
            } else {
                self.used_neg_len_fail = true;
                let sm1 = self.next_tmp();
                let _ = writeln!(out, "  {sm1} = sub i64 {sval}, 1");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp ult i64 {sm1}, {MAX_ARRAY_LEN}");
                let ok_lbl = self.fresh_label("step.ok");
                let bad_lbl = self.fresh_label("step.bad");
                self.emit_cond_br(&ok, &ok_lbl, &bad_lbl, out);
                self.start_block(&bad_lbl, out);
                let _ = writeln!(out, "  call void @archx_neg_len_fail(i64 {sval})");
                let _ = writeln!(out, "  unreachable");
                self.terminated = true;
                self.start_block(&ok_lbl, out);
                (sval, false)
            }
        } else {
            ("1".to_string(), true)
        };
        self.flush_stmt_temps(out);

        if self.lookup_var(var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{var}` is already defined"),
                span,
            ));
        }

        let iv_reassigned = stmts_assign_var(body, var);
        let bounded_end = eval_const_int(end).map_or(false, |e| e <= MAX_ARRAY_LEN)
            || matches!(&end.kind, ExprKind::Var(v) if self.is_bounded_var(v) && !stmts_assign_var(body, v))
            || matches!(&end.kind, ExprKind::Call { name, args } if name == "len" && args.len() == 1);
        let can_nsw = !iv_reassigned && (step_val == "1" || (step_guaranteed_safe && bounded_end));
        let proven_bound = if can_nsw {
            self.derive_for_bound(var, start, end, body)
        } else {
            None
        };

        let extra_arrays = if !iv_reassigned
            && step_val == "1"
            && eval_const_int(start).map_or(false, |s| s >= 0)
            && !stmts_contain_loop(body)
        {
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
            }
            let found = self.collect_unchecked_for_arrays(var, body);
            if proven_bound.is_some() {
                self.loop_bounds.pop();
            }
            found
        } else {
            Vec::new()
        };

        let slot = self.next_slot(&format!("for.{var}"));
        let _ = writeln!(self.allocas, "  {slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {start_val}, ptr {slot}, align 8");

        if !extra_arrays.is_empty() && extra_arrays.len() <= 8 {
            let mut guard: Option<String> = None;
            for arr_name in &extra_arrays {
                let alen = self.load_array_len_ssa(arr_name, out);
                let fit = self.next_tmp();
                let _ = writeln!(out, "  {fit} = icmp ule i64 {end_val}, {alen}");
                guard = Some(match guard {
                    None => fit,
                    Some(prev) => {
                        let both = self.next_tmp();
                        let _ = writeln!(out, "  {both} = and i1 {prev}, {fit}");
                        both
                    }
                });
            }

            let fast_cond = self.fresh_label("for.fast.cond");
            let fast_body = self.fresh_label("for.fast.body");
            let fast_step = self.fresh_label("for.fast.step");
            let slow_cond = self.fresh_label("for.cond");
            let slow_body = self.fresh_label("for.body");
            let slow_step = self.fresh_label("for.step");
            let end_label = self.fresh_label("for.end");

            self.emit_cond_br(&guard.unwrap(), &fast_cond, &slow_cond, out);

            self.start_block(&fast_cond, out);
            let fi = self.next_tmp();
            let _ = writeln!(out, "  {fi} = load i64, ptr {slot}, align 8");
            let fcmp = self.next_tmp();
            let _ = writeln!(out, "  {fcmp} = icmp slt i64 {fi}, {end_val}");
            self.emit_cond_br(&fcmp, &fast_body, &end_label, out);

            self.start_block(&fast_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.scopes.last_mut().unwrap().vars.insert(
                var.to_string(),
                VarEntry {
                    ty: Type::Int,
                    storage: VarStorage::Slot(slot.clone()),
                    is_param: false,
                    region_depth: outer_rdepth,
                },
            );
            let mut pushed_bounds = 0usize;
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
                pushed_bounds += 1;
            }
            for arr_name in &extra_arrays {
                self.loop_bounds.push(InductionBound {
                    var: var.to_string(),
                    upper: UpperBound::LenOf(arr_name.clone()),
                });
                pushed_bounds += 1;
            }
            self.loop_stack.push(LoopLabels {
                break_label: end_label.clone(),
                continue_label: fast_step.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            for _ in 0..pushed_bounds {
                self.loop_bounds.pop();
            }
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&fast_step, out);
            }

            self.start_block(&fast_step, out);
            let fi2 = self.next_tmp();
            let _ = writeln!(out, "  {fi2} = load i64, ptr {slot}, align 8");
            let fnext = self.next_tmp();
            let _ = writeln!(out, "  {fnext} = add nsw i64 {fi2}, 1");
            let _ = writeln!(out, "  store i64 {fnext}, ptr {slot}, align 8");
            self.emit_br(&fast_cond, out);

            self.start_block(&slow_cond, out);
            let si = self.next_tmp();
            let _ = writeln!(out, "  {si} = load i64, ptr {slot}, align 8");
            let scmp = self.next_tmp();
            let _ = writeln!(out, "  {scmp} = icmp slt i64 {si}, {end_val}");
            self.emit_cond_br(&scmp, &slow_body, &end_label, out);

            self.start_block(&slow_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.scopes.last_mut().unwrap().vars.insert(
                var.to_string(),
                VarEntry {
                    ty: Type::Int,
                    storage: VarStorage::Slot(slot.clone()),
                    is_param: false,
                    region_depth: outer_rdepth,
                },
            );
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
            }
            self.loop_stack.push(LoopLabels {
                break_label: end_label.clone(),
                continue_label: slow_step.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            if proven_bound.is_some() {
                self.loop_bounds.pop();
            }
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&slow_step, out);
            }

            self.start_block(&slow_step, out);
            let si2 = self.next_tmp();
            let _ = writeln!(out, "  {si2} = load i64, ptr {slot}, align 8");
            let snext = self.next_tmp();
            let _ = writeln!(out, "  {snext} = add nsw i64 {si2}, 1");
            let _ = writeln!(out, "  store i64 {snext}, ptr {slot}, align 8");
            self.emit_br(&slow_cond, out);

            self.start_block(&end_label, out);
            return Ok(());
        }

        let cond_label = self.fresh_label("for.cond");
        let body_label = self.fresh_label("for.body");
        let step_label = self.fresh_label("for.step");
        let end_label = self.fresh_label("for.end");

        self.emit_br(&cond_label, out);

        self.start_block(&cond_label, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {slot}, align 8");
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {i}, {end_val}");
        self.emit_cond_br(&cmp, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.scopes.last_mut().unwrap().vars.insert(
            var.to_string(),
            VarEntry {
                ty: Type::Int,
                storage: VarStorage::Slot(slot.clone()),
                is_param: false,
                region_depth: outer_rdepth,
            },
        );
        if let Some(bound) = &proven_bound {
            self.loop_bounds.push(bound.clone());
        }
        self.loop_stack.push(LoopLabels {
            break_label: end_label.clone(),
            continue_label: step_label.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        if proven_bound.is_some() {
            self.loop_bounds.pop();
        }
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_label, out);
        }

        self.start_block(&step_label, out);
        let i2 = self.next_tmp();
        let _ = writeln!(out, "  {i2} = load i64, ptr {slot}, align 8");
        let next = self.next_tmp();
        if can_nsw {
            let _ = writeln!(out, "  {next} = add nsw i64 {i2}, {step_val}");
        } else {
            let _ = writeln!(out, "  {next} = add i64 {i2}, {step_val}");
        }
        let _ = writeln!(out, "  store i64 {next}, ptr {slot}, align 8");
        self.emit_br(&cond_label, out);

        self.start_block(&end_label, out);
        Ok(())
    }

    fn gen_foreach(
        &mut self,
        var: &str,
        iter: &Expr,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if self.lookup_var(var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{var}` is already defined"),
                span,
            ));
        }

        if let ExprKind::Var(aname) = &iter.kind {
            if let Some(entry) = self.lookup_var(aname).cloned() {
                if let VarStorage::Soa {
                    struct_name,
                    len_val,
                    planes,
                } = entry.storage
                {
                    let idx_slot = self.next_slot("foreach.idx");
                    let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
                    let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

                    let cond_lbl = self.fresh_label("foreach.cond");
                    let body_lbl = self.fresh_label("foreach.body");
                    let step_lbl = self.fresh_label("foreach.step");
                    let end_lbl = self.fresh_label("foreach.end");

                    self.emit_br(&cond_lbl, out);
                    self.start_block(&cond_lbl, out);
                    let cur = self.next_tmp();
                    let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
                    let cmp = self.next_tmp();
                    let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
                    self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

                    self.start_block(&body_lbl, out);
                    let elem_ty = Type::Struct(struct_name.clone());
                    let elem_val = self.load_soa_struct_at(&struct_name, &planes, &cur, out);

                    let outer_depth = self.scopes.len();
                    let outer_rdepth = self.region_stack.len();
                    self.push_scope();
                    let storage = if self.mutated_vars.contains(var) {
                        let sptr = self.next_slot(&format!("var.{var}"));
                        let ty_ir = ir_type(&elem_ty);
                        let _ = writeln!(self.allocas, "  {sptr} = alloca {ty_ir}, align 8");
                        let _ = writeln!(out, "  store {ty_ir} {elem_val}, ptr {sptr}, align 8");
                        VarStorage::Slot(sptr)
                    } else {
                        VarStorage::Imm(elem_val)
                    };
                    self.scopes.last_mut().unwrap().vars.insert(
                        var.to_string(),
                        VarEntry {
                            ty: elem_ty,
                            storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    self.loop_stack.push(LoopLabels {
                        break_label: end_lbl.clone(),
                        continue_label: step_lbl.clone(),
                        scope_depth: outer_depth,
                        region_depth: outer_rdepth,
                    });
                    self.gen_block(body, out)?;
                    self.loop_stack.pop();
                    self.pop_scope_with_drops(out);
                    if !self.terminated {
                        self.emit_br(&step_lbl, out);
                    }

                    self.start_block(&step_lbl, out);
                    let cur2 = self.next_tmp();
                    let _ = writeln!(out, "  {cur2} = load i64, ptr {idx_slot}, align 8");
                    let next = self.next_tmp();
                    let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
                    let _ = writeln!(out, "  store i64 {next}, ptr {idx_slot}, align 8");
                    self.emit_br(&cond_lbl, out);

                    self.start_block(&end_lbl, out);
                    return Ok(());
                }
            }
        }

        let (iter_ty, iter_val) = self.eval_expr(iter, out)?;
        let Type::Array(elem_ty) = iter_ty.clone() else {
            return Err(Diagnostic::new(
                format!("`for ... in` expects an array, found `{}`", iter_ty.name()),
                iter.span,
            ));
        };

        let hold_outer_scope = self.claim_stmt_temp(&iter_val);
        self.flush_stmt_temps(out);
        if hold_outer_scope {
            self.push_scope();
            let hslot = self.next_slot("foreach.iter");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxVec, align 8");
            let _ = writeln!(out, "  store %ArchxVec {iter_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: iter_ty,
                });
        }

        let iter_var_mutated =
            matches!(&iter.kind, ExprKind::Var(n) if stmts_mutate_array_len(body, n));
        if iter_var_mutated {
            return Err(Diagnostic::new(
                "cannot resize array via `push`/`pop`/reassignment while iterating over it",
                iter.span,
            ));
        }

        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {iter_val}, 0");
        let data_ptr = self.next_tmp();
        let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {iter_val}, 2");

        let idx_slot = self.next_slot("foreach.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("foreach.cond");
        let body_lbl = self.fresh_label("foreach.body");
        let step_lbl = self.fresh_label("foreach.step");
        let end_lbl = self.fresh_label("foreach.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {cur}"
        );
        let raw_elem = self.emit_elem_load(&elem_ty, &ep, out);

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let var_mutated = self.mutated_vars.contains(var);
        let storage = if var_mutated {
            let init_elem = if self.type_needs_drop(&elem_ty) {
                self.emit_clone_value(&elem_ty, &raw_elem, out)
            } else {
                raw_elem
            };
            let sptr = self.next_slot(&format!("var.{var}"));
            let ty_ir = ir_type(&elem_ty);
            let align = ir_align(&elem_ty);
            let _ = writeln!(self.allocas, "  {sptr} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {init_elem}, ptr {sptr}, align {align}");
            if self.type_needs_drop(&elem_ty) {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: sptr.clone(),
                        ty: (*elem_ty).clone(),
                    });
            }
            VarStorage::Slot(sptr)
        } else {
            VarStorage::Imm(raw_elem)
        };
        self.scopes.last_mut().unwrap().vars.insert(
            var.to_string(),
            VarEntry {
                ty: (*elem_ty).clone(),
                storage,
                is_param: !var_mutated,
                region_depth: outer_rdepth,
            },
        );
        self.loop_stack.push(LoopLabels {
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let cur2 = self.next_tmp();
        let _ = writeln!(out, "  {cur2} = load i64, ptr {idx_slot}, align 8");
        let next = self.next_tmp();
        let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
        let _ = writeln!(out, "  store i64 {next}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer_scope {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    fn load_var_ssa(&mut self, name: &str, out: &mut String) -> String {
        let entry = self.lookup_var(name).cloned().expect("var exists");
        match entry.storage {
            VarStorage::Imm(val) => val,
            VarStorage::Slot(ptr) => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = load {}, ptr {ptr}, align {}",
                    ir_type(&entry.ty),
                    ir_align(&entry.ty)
                );
                reg
            }
            VarStorage::Soa { .. } => unreachable!("SoA has no single SSA aggregate"),
        }
    }

    fn load_array_len_ssa(&mut self, name: &str, out: &mut String) -> String {
        let entry = self.lookup_var(name).cloned().expect("array var exists");
        match entry.storage {
            VarStorage::Soa { len_val, .. } => len_val,
            VarStorage::Imm(val) => {
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {val}, 0");
                l
            }
            VarStorage::Slot(ptr) => {
                let v = self.next_tmp();
                let _ = writeln!(out, "  {v} = load %ArchxVec, ptr {ptr}, align 8");
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {v}, 0");
                l
            }
        }
    }

    // ---------------- Assignments --------------------------------------------

    fn check_region_escape_target(&self, root_var: &str, val_ty: &Type, span: Span) -> Result<()> {
        if !self.region_stack.is_empty() && self.type_needs_drop(val_ty) {
            if let Some(entry) = self.lookup_var(root_var) {
                if entry.region_depth < self.region_stack.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "cannot store heap/region value of type `{}` into outer variable `{root_var}` inside `region:`",
                            val_ty.name()
                        ),
                        span,
                    ));
                }
            }
        }
        Ok(())
    }

    fn gen_assign(
        &mut self,
        target: &AssignTarget,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        match target {
            AssignTarget::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), span)
                })?;
                self.check_region_escape_target(name, &entry.ty, span)?;

                if op.is_none() && matches!(&value.kind, ExprKind::Var(v) if v == name) {
                    return Ok(());
                }

                let ptr = match &entry.storage {
                    VarStorage::Slot(p) => p.clone(),
                    _ => {
                        return Err(Diagnostic::new(
                            format!("internal error: mutated variable `{name}` lacked a slot"),
                            span,
                        ));
                    }
                };

                if let Some(bin_op) = op {
                    if entry.ty == Type::Str && bin_op == BinOp::Add {
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load %ArchxStr, ptr {ptr}, align 8");
                        let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                        if rhs_ty != Type::Str {
                            return Err(Diagnostic::new(
                                format!(
                                    "operator `+=` on `string` requires a `string` right-hand side, found `{}`",
                                    rhs_ty.name()
                                ),
                                value.span,
                            ));
                        }
                        let new_val = self.emit_str_concat_call(&old_val, &rhs_val, out);
                        let _ = self.claim_stmt_temp(&new_val);
                        self.emit_drop_value(&Type::Str, &old_val, out);
                        let _ = writeln!(out, "  store %ArchxStr {new_val}, ptr {ptr}, align 8");
                        return Ok(());
                    }
                    if entry.ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` target, found `{}`",
                                bin_op.symbol(),
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {ptr}, align 8");
                    let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                    if rhs_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {ptr}, align 8");
                } else {
                    let (val_ty, raw_val) = self.eval_expr_typed(value, Some(&entry.ty), out)?;
                    if val_ty != entry.ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to variable `{}` of type `{}`",
                                val_ty.name(),
                                name,
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let needs_drop = self.type_needs_drop(&entry.ty);
                    let new_val = if needs_drop && !matches!(&value.kind, ExprKind::Str(_)) {
                        if self.claim_stmt_temp(&raw_val) {
                            raw_val
                        } else {
                            self.emit_clone_value(&entry.ty, &raw_val, out)
                        }
                    } else {
                        raw_val
                    };
                    if needs_drop {
                        let old_val = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {old_val} = load {}, ptr {ptr}, align {}",
                            ir_type(&entry.ty),
                            ir_align(&entry.ty)
                        );
                        self.emit_drop_value(&entry.ty, &old_val, out);
                    }
                    let _ = writeln!(
                        out,
                        "  store {} {new_val}, ptr {ptr}, align {}",
                        ir_type(&entry.ty),
                        ir_align(&entry.ty)
                    );
                }
                Ok(())
            }

            AssignTarget::Field {
                target: base_expr,
                field,
            } => self.gen_field_assign(base_expr, field, op, value, span, out),

            AssignTarget::Index {
                target: arr_expr,
                index: idx_expr,
            } => {
                if let Some(root) = root_var_of_expr(arr_expr) {
                    if let Some(entry) = self.lookup_var(root).cloned() {
                        if let Type::Array(elem_t) = &entry.ty {
                            self.check_region_escape_target(root, elem_t, span)?;
                        }
                        if let VarStorage::Soa {
                            struct_name,
                            len_val,
                            planes,
                        } = entry.storage
                        {
                            if op.is_some() {
                                return Err(Diagnostic::new(
                                    "compound assignment is not supported on whole structs",
                                    span,
                                ));
                            }
                            let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                            if idx_ty != Type::Int {
                                return Err(Diagnostic::new(
                                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                                    idx_expr.span,
                                ));
                            }
                            self.emit_raw_len_bounds_check(
                                arr_expr, idx_expr, &len_val, &idx_val, out,
                            )?;
                            let expected = Type::Struct(struct_name.clone());
                            let (rhs_ty, rhs_val) =
                                self.eval_expr_typed(value, Some(&expected), out)?;
                            if rhs_ty != expected {
                                return Err(Diagnostic::new(
                                    format!(
                                        "cannot assign `{}` to element of `[{struct_name}]`",
                                        rhs_ty.name()
                                    ),
                                    value.span,
                                ));
                            }
                            for (k, (fty, p_ptr)) in planes.iter().enumerate() {
                                let fv = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {fv} = extractvalue %ArchxStruct_{struct_name} {rhs_val}, {k}"
                                );
                                let mem_ty = elem_mem_ir_type(fty);
                                let ep = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {p_ptr}, i64 {idx_val}"
                                );
                                self.emit_elem_store(fty, &fv, &ep, out);
                            }
                            return Ok(());
                        }
                    }
                }

                let (arr_ty, vec_val) = self.eval_expr(arr_expr, out)?;
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        arr_expr.span,
                    ));
                };
                let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                if idx_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        idx_expr.span,
                    ));
                }

                self.emit_bounds_check_if_needed(arr_expr, idx_expr, &vec_val, &idx_val, out)?;

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );

                if let Some(bin_op) = op {
                    if *elem_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires `int` elements, found `{}`",
                                bin_op.symbol(),
                                elem_ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {elem_ptr}, align 8");
                    let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                    if rhs_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {elem_ptr}, align 8");
                } else {
                    let (rhs_ty, raw_rhs) = self.eval_expr_typed(value, Some(&elem_ty), out)?;
                    if rhs_ty != *elem_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to element of `[{}]`",
                                rhs_ty.name(),
                                elem_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let needs_drop = self.type_needs_drop(&elem_ty);
                    let rhs_val = if needs_drop {
                        if self.claim_stmt_temp(&raw_rhs) {
                            raw_rhs
                        } else {
                            self.emit_clone_value(&elem_ty, &raw_rhs, out)
                        }
                    } else {
                        raw_rhs
                    };
                    if needs_drop {
                        let old_elem = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                        self.emit_drop_value(&elem_ty, &old_elem, out);
                    }
                    self.emit_elem_store(&elem_ty, &rhs_val, &elem_ptr, out);
                }

                Ok(())
            }
        }
    }

    fn gen_field_assign(
        &mut self,
        base_expr: &Expr,
        field: &str,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let ExprKind::Index {
            target: arr_expr,
            index: idx_expr,
        } = &base_expr.kind
        {
            if let ExprKind::Var(aname) = &arr_expr.kind {
                if let Some(entry) = self.lookup_var(aname).cloned() {
                    if let VarStorage::Soa {
                        struct_name,
                        len_val,
                        planes,
                    } = entry.storage
                    {
                        let (fidx, fty) = self.lookup_struct_field(&struct_name, field, span)?;
                        let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                        if idx_ty != Type::Int {
                            return Err(Diagnostic::new(
                                format!("array index must be `int`, found `{}`", idx_ty.name()),
                                idx_expr.span,
                            ));
                        }
                        self.emit_raw_len_bounds_check(
                            arr_expr, idx_expr, &len_val, &idx_val, out,
                        )?;
                        let plane_ptr = &planes[fidx].1;
                        let mem_ty = elem_mem_ir_type(&fty);
                        let ep = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {ep} = getelementptr inbounds {mem_ty}, ptr {plane_ptr}, i64 {idx_val}"
                        );
                        return self
                            .finish_scalar_or_typed_ptr_assign(&fty, &ep, true, op, value, span, out);
                    }
                }
            }

            let (arr_ty, vec_val) = self.eval_expr(arr_expr, out)?;
            let Type::Array(elem_ty) = arr_ty else {
                return Err(Diagnostic::new(
                    format!("cannot index into `{}`", arr_ty.name()),
                    arr_expr.span,
                ));
            };
            let Type::Struct(sname) = *elem_ty else {
                return Err(Diagnostic::new(
                    format!("cannot access field `{field}` on `{}`", elem_ty.name()),
                    span,
                ));
            };
            let (fidx, fty) = self.lookup_struct_field(&sname, field, span)?;
            if let Some(root) = root_var_of_expr(arr_expr) {
                self.check_region_escape_target(root, &fty, span)?;
            }
            let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
            if idx_ty != Type::Int {
                return Err(Diagnostic::new(
                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                    idx_expr.span,
                ));
            }
            self.emit_bounds_check_if_needed(arr_expr, idx_expr, &vec_val, &idx_val, out)?;
            let data_ptr = self.next_tmp();
            let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
            let fptr = self.next_tmp();
            let _ = writeln!(
                out,
                "  {fptr} = getelementptr inbounds %ArchxStruct_{sname}, ptr {data_ptr}, i64 {idx_val}, i32 {fidx}"
            );
            return self
                .finish_scalar_or_typed_ptr_assign(&fty, &fptr, false, op, value, span, out);
        }

        if let ExprKind::Var(vname) = &base_expr.kind {
            let entry = self.lookup_var(vname).cloned().ok_or_else(|| {
                Diagnostic::new(format!("undefined variable `{vname}`"), base_expr.span)
            })?;
            let Type::Struct(sname) = entry.ty else {
                return Err(Diagnostic::new(
                    format!("cannot access field `{field}` on `{}`", entry.ty.name()),
                    span,
                ));
            };
            let (fidx, fty) = self.lookup_struct_field(&sname, field, span)?;
            self.check_region_escape_target(vname, &fty, span)?;
            let VarStorage::Slot(slot_ptr) = entry.storage else {
                return Err(Diagnostic::new(
                    format!("internal error: mutated struct `{vname}` lacked a slot"),
                    span,
                ));
            };
            let fptr = self.next_tmp();
            let _ = writeln!(
                out,
                "  {fptr} = getelementptr inbounds %ArchxStruct_{sname}, ptr {slot_ptr}, i32 0, i32 {fidx}"
            );
            return self
                .finish_scalar_or_typed_ptr_assign(&fty, &fptr, false, op, value, span, out);
        }

        Err(Diagnostic::new(
            "field assignment requires a struct variable or indexed struct element",
            span,
        ))
    }

    fn finish_scalar_or_typed_ptr_assign(
        &mut self,
        fty: &Type,
        fptr: &str,
        bool_as_i8: bool,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Some(bin_op) = op {
            if *fty != Type::Int {
                return Err(Diagnostic::new(
                    format!(
                        "operator `{}=` requires an `int` field, found `{}`",
                        bin_op.symbol(),
                        fty.name()
                    ),
                    span,
                ));
            }
            let old_val = self.next_tmp();
            let _ = writeln!(out, "  {old_val} = load i64, ptr {fptr}, align 8");
            let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
            if rhs_ty != Type::Int {
                return Err(Diagnostic::new(
                    format!(
                        "operator `{}=` requires an `int` right-hand side, found `{}`",
                        bin_op.symbol(),
                        rhs_ty.name()
                    ),
                    value.span,
                ));
            }
            let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
            let _ = writeln!(out, "  store i64 {new_val}, ptr {fptr}, align 8");
            return Ok(());
        }

        let (rhs_ty, raw_rhs) = self.eval_expr_typed(value, Some(fty), out)?;
        if rhs_ty != *fty {
            return Err(Diagnostic::new(
                format!("field expects `{}`, found `{}`", fty.name(), rhs_ty.name()),
                value.span,
            ));
        }

        if bool_as_i8 && *fty == Type::Bool {
            self.emit_elem_store(&Type::Bool, &raw_rhs, fptr, out);
            return Ok(());
        }

        let needs_drop = self.type_needs_drop(fty);
        let rhs_val = if needs_drop {
            if self.claim_stmt_temp(&raw_rhs) {
                raw_rhs
            } else {
                self.emit_clone_value(fty, &raw_rhs, out)
            }
        } else {
            raw_rhs
        };
        let ty_ir = ir_type(fty);
        let align = ir_align(fty);
        if needs_drop {
            let old_v = self.next_tmp();
            let _ = writeln!(out, "  {old_v} = load {ty_ir}, ptr {fptr}, align {align}");
            self.emit_drop_value(fty, &old_v, out);
        }
        let _ = writeln!(out, "  store {ty_ir} {rhs_val}, ptr {fptr}, align {align}");
        Ok(())
    }

    fn lookup_struct_field(&self, sname: &str, field: &str, span: Span) -> Result<(usize, Type)> {
        let fields = self
            .structs
            .get(sname)
            .ok_or_else(|| Diagnostic::new(format!("unknown struct `{sname}`"), span))?;
        for (i, f) in fields.iter().enumerate() {
            if f.name == field {
                return Ok((i, f.ty.clone()));
            }
        }
        Err(Diagnostic::new(
            format!("struct `{sname}` has no field `{field}`"),
            span,
        ))
    }

    // ---------------- Expressions --------------------------------------------

    fn eval_expr(&mut self, expr: &Expr, out: &mut String) -> Result<(Type, String)> {
        self.eval_expr_typed(expr, None, out)
    }

    fn eval_expr_typed(
        &mut self,
        expr: &Expr,
        expected: Option<&Type>,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.enter_depth(expr.span)?;
        let res = self.eval_expr_typed_inner(expr, expected, out);
        self.depth -= 1;
        res
    }

    fn eval_expr_typed_inner(
        &mut self,
        expr: &Expr,
        expected: Option<&Type>,
        out: &mut String,
    ) -> Result<(Type, String)> {
        match &expr.kind {
            ExprKind::Int(value) => Ok((Type::Int, value.to_string())),

            ExprKind::Bool(value) => Ok((Type::Bool, value.to_string())),

            ExprKind::Str(value) => {
                self.used_str_type = true;
                let bytes = value.as_bytes();
                if bytes.len() as i64 > MAX_STR_LEN {
                    return Err(Diagnostic::new(
                        "string literal exceeds maximum 2 GB length",
                        expr.span,
                    ));
                }
                if bytes.len() <= 12 {
                    let (w0, w1) = pack_sso_str_words(bytes);
                    Ok((Type::Str, format!("{{ i64 {w0}, i64 {w1} }}")))
                } else {
                    let sym = self.strings.intern(value);
                    let w0 = pack_long_str_w0(bytes);
                    let p_int = self.next_tmp();
                    let _ = writeln!(out, "  {p_int} = ptrtoint ptr {sym} to i64");
                    let s0 = self.next_tmp();
                    let _ = writeln!(out, "  {s0} = insertvalue %ArchxStr poison, i64 {w0}, 0");
                    let s1 = self.next_tmp();
                    let _ = writeln!(out, "  {s1} = insertvalue %ArchxStr {s0}, i64 {p_int}, 1");
                    Ok((Type::Str, s1))
                }
            }

            ExprKind::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), expr.span)
                })?;
                match entry.storage {
                    VarStorage::Imm(val) => Ok((entry.ty, val)),
                    VarStorage::Slot(ptr) => {
                        let reg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {reg} = load {}, ptr {ptr}, align {}",
                            ir_type(&entry.ty),
                            ir_align(&entry.ty)
                        );
                        Ok((entry.ty, reg))
                    }
                    VarStorage::Soa { .. } => Err(Diagnostic::new(
                        format!(
                            "array `{name}` uses local SoA layout and cannot be copied as a whole"
                        ),
                        expr.span,
                    )),
                }
            }

            ExprKind::Field { target, field } => {
                if let ExprKind::Index {
                    target: arr_e,
                    index: idx_e,
                } = &target.kind
                {
                    if let ExprKind::Var(aname) = &arr_e.kind {
                        if let Some(entry) = self.lookup_var(aname).cloned() {
                            if let VarStorage::Soa {
                                struct_name,
                                len_val,
                                planes,
                            } = entry.storage
                            {
                                let (fidx, fty) =
                                    self.lookup_struct_field(&struct_name, field, expr.span)?;
                                let (idx_ty, idx_val) = self.eval_expr(idx_e, out)?;
                                if idx_ty != Type::Int {
                                    return Err(Diagnostic::new(
                                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                                        idx_e.span,
                                    ));
                                }
                                self.emit_raw_len_bounds_check(
                                    arr_e, idx_e, &len_val, &idx_val, out,
                                )?;
                                let plane_ptr = &planes[fidx].1;
                                let mem_ty = elem_mem_ir_type(&fty);
                                let ep = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {plane_ptr}, i64 {idx_val}"
                                );
                                let val = self.emit_elem_load(&fty, &ep, out);
                                return Ok((fty, val));
                            }
                        }
                    }
                }

                let (base_ty, base_val) = self.eval_expr(target, out)?;
                let Type::Struct(sname) = base_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot access field `{field}` on `{}`", base_ty.name()),
                        expr.span,
                    ));
                };
                let (fidx, fty) = self.lookup_struct_field(&sname, field, expr.span)?;
                let extracted = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {extracted} = extractvalue %ArchxStruct_{sname} {base_val}, {fidx}"
                );
                if self.type_needs_drop(&fty)
                    && self.stmt_temps.iter().any(|t| t.val == base_val)
                {
                    let cloned = self.emit_clone_value(&fty, &extracted, out);
                    self.stmt_temps.push(TempDrop {
                        val: cloned.clone(),
                        ty: fty.clone(),
                    });
                    return Ok((fty, cloned));
                }
                Ok((fty, extracted))
            }

            ExprKind::ArrayLit(elems) => {
                self.used_vec_type = true;
                if elems.is_empty() {
                    let Some(Type::Array(elem_ty)) = expected else {
                        return Err(Diagnostic::new(
                            "cannot infer element type of empty array `[]`; add a type annotation like `let xs: [int] = []`",
                            expr.span,
                        ));
                    };
                    let vec = self.build_vec_val("0", "0", "null", out);
                    return Ok((Type::Array(elem_ty.clone()), vec));
                }

                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };

                let (first_ty, raw_first) = self.eval_expr_typed(&elems[0], elem_hint, out)?;
                if first_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        elems[0].span,
                    ));
                }
                let elem_drops = self.type_needs_drop(&first_ty);
                let first_owned = if elem_drops {
                    if self.claim_stmt_temp(&raw_first) {
                        raw_first
                    } else {
                        self.emit_clone_value(&first_ty, &raw_first, out)
                    }
                } else {
                    raw_first
                };

                let mut vals = vec![first_owned];
                for item in &elems[1..] {
                    let (ty, raw_v) = self.eval_expr_typed(item, Some(&first_ty), out)?;
                    if ty != first_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "array element type mismatch: expected `{}`, found `{}`",
                                first_ty.name(),
                                ty.name()
                            ),
                            item.span,
                        ));
                    }
                    let owned_v = if elem_drops {
                        if self.claim_stmt_temp(&raw_v) {
                            raw_v
                        } else {
                            self.emit_clone_value(&first_ty, &raw_v, out)
                        }
                    } else {
                        raw_v
                    };
                    vals.push(owned_v);
                }

                let count = vals.len() as i64;
                let count_str = count.to_string();
                let bytes = self.emit_type_bytes_const_mul(&first_ty, count, out);

                let use_region = !self.region_stack.is_empty() && !elem_drops;
                let (data_ptr, cap_str) = if use_region {
                    let rslot = self.func_region_slot.clone().unwrap();
                    let p = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
                    );
                    (p, format!("-{count}"))
                } else {
                    let p = self.emit_checked_malloc(&bytes, out);
                    (p, count_str.clone())
                };

                let mem_ty = elem_mem_ir_type(&first_ty);
                for (i, val) in vals.iter().enumerate() {
                    let ep = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {i}"
                    );
                    self.emit_elem_store(&first_ty, val, &ep, out);
                }

                let vec = self.build_vec_val(&count_str, &cap_str, &data_ptr, out);
                let arr_ty = Type::Array(Box::new(first_ty));
                if !use_region {
                    self.stmt_temps.push(TempDrop {
                        val: vec.clone(),
                        ty: arr_ty.clone(),
                    });
                }
                Ok((arr_ty, vec))
            }

            ExprKind::ArrayRepeat { value, count } => {
                self.used_vec_type = true;
                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };
                let (elem_ty, raw_init) = self.eval_expr_typed(value, elem_hint, out)?;
                if elem_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        value.span,
                    ));
                }
                let (count_ty, count_val) = self.eval_expr(count, out)?;
                if count_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "array repeat count must be `int`, found `{}`",
                            count_ty.name()
                        ),
                        count.span,
                    ));
                }

                self.emit_repeat_count_check(count, &count_val, out)?;

                let elem_drops = self.type_needs_drop(&elem_ty);
                let use_region = !self.region_stack.is_empty() && !elem_drops;
                let is_zero_fill = !use_region
                    && ((elem_ty == Type::Int && raw_init == "0")
                        || (elem_ty == Type::Bool && raw_init == "false"));

                let (data_ptr, cap_val) = if is_zero_fill {
                    let elem_sz = if elem_ty == Type::Bool { 1 } else { 8 };
                    let p = self.emit_checked_calloc(&count_val, elem_sz, out);
                    (p, count_val.clone())
                } else {
                    let elem_sz_val = self.emit_elem_sizeof(&elem_ty, out);
                    let bytes = self.emit_elem_bytes_val_mul(&count_val, &elem_sz_val, out);
                    let (p, cval) = if use_region {
                        let rslot = self.func_region_slot.clone().unwrap();
                        let pr = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pr} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
                        );
                        let neg_c = self.next_tmp();
                        let _ = writeln!(out, "  {neg_c} = sub nsw i64 0, {count_val}");
                        (pr, neg_c)
                    } else {
                        (self.emit_checked_malloc(&bytes, out), count_val.clone())
                    };
                    self.emit_general_fill_loop(&elem_ty, &raw_init, &p, &count_val, out);
                    (p, cval)
                };

                let vec = self.build_vec_val(&count_val, &cap_val, &data_ptr, out);
                let arr_ty = Type::Array(Box::new(elem_ty));
                if !use_region {
                    self.stmt_temps.push(TempDrop {
                        val: vec.clone(),
                        ty: arr_ty.clone(),
                    });
                }
                Ok((arr_ty, vec))
            }

            ExprKind::Index { target, index } => {
                if let ExprKind::Var(aname) = &target.kind {
                    if let Some(entry) = self.lookup_var(aname).cloned() {
                        if let VarStorage::Soa {
                            struct_name,
                            len_val,
                            planes,
                        } = entry.storage
                        {
                            let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                            if idx_ty != Type::Int {
                                return Err(Diagnostic::new(
                                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                                    index.span,
                                ));
                            }
                            self.emit_raw_len_bounds_check(target, index, &len_val, &idx_val, out)?;
                            let sval =
                                self.load_soa_struct_at(&struct_name, &planes, &idx_val, out);
                            return Ok((Type::Struct(struct_name), sval));
                        }
                    }
                }

                let (arr_ty, vec_val) = self.eval_expr(target, out)?;
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        target.span,
                    ));
                };
                let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                if idx_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        index.span,
                    ));
                }

                self.emit_bounds_check_if_needed(target, index, &vec_val, &idx_val, out)?;

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );
                let loaded = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                let safe_loaded = if self.type_needs_drop(&elem_ty)
                    && self.stmt_temps.iter().any(|t| t.val == vec_val)
                {
                    let cloned = self.emit_clone_value(&elem_ty, &loaded, out);
                    self.stmt_temps.push(TempDrop {
                        val: cloned.clone(),
                        ty: (*elem_ty).clone(),
                    });
                    cloned
                } else {
                    loaded
                };
                Ok((*elem_ty, safe_loaded))
            }

            ExprKind::Unary { op, expr: inner } => {
                let (ty, val) = self.eval_expr(inner, out)?;
                match op {
                    UnOp::Neg => {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "unary `-` requires an `int` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = sub i64 0, {val}");
                        Ok((Type::Int, reg))
                    }
                    UnOp::Not => {
                        if ty != Type::Bool {
                            return Err(Diagnostic::new(
                                "`not` requires a `bool` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = xor i1 {val}, true");
                        Ok((Type::Bool, reg))
                    }
                }
            }

            ExprKind::Binary { op, lhs, rhs } => self.gen_binary(*op, lhs, rhs, expr.span, out),

            ExprKind::Call { name, args } => self.gen_call(name, args, expr.span, out),
        }
    }

    fn load_soa_struct_at(
        &mut self,
        struct_name: &str,
        planes: &[(Type, String)],
        idx_val: &str,
        out: &mut String,
    ) -> String {
        let mut agg = "poison".to_string();
        for (k, (fty, p_ptr)) in planes.iter().enumerate() {
            let mem_ty = elem_mem_ir_type(fty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {p_ptr}, i64 {idx_val}"
            );
            let fv = self.emit_elem_load(fty, &ep, out);
            let next_agg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {next_agg} = insertvalue %ArchxStruct_{struct_name} {agg}, {} {fv}, {k}",
                ir_type(fty)
            );
            agg = next_agg;
        }
        agg
    }

    fn gen_binary(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if matches!(op, BinOp::And | BinOp::Or) {
            return self.gen_short_circuit(op, lhs, rhs, span, out);
        }

        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;

        match op {
            BinOp::Add if lhs_ty == Type::Str && rhs_ty == Type::Str => {
                let res = self.emit_str_concat_call(&lhs_val, &rhs_val, out);
                Ok((Type::Str, res))
            }

            BinOp::Add | BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let val = self.emit_int_arith(op, &lhs_val, &rhs_val, out);
                Ok((Type::Int, val))
            }

            BinOp::Eq | BinOp::Ne => {
                let eq_val = self.emit_equality(&lhs_ty, &lhs_val, &rhs_ty, &rhs_val, span, out)?;
                if op == BinOp::Eq {
                    Ok((Type::Bool, eq_val))
                } else {
                    let inv = self.next_tmp();
                    let _ = writeln!(out, "  {inv} = xor i1 {eq_val}, true");
                    Ok((Type::Bool, inv))
                }
            }

            BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge => {
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let reg = self.next_tmp();
                let pred = match op {
                    BinOp::Lt => "slt",
                    BinOp::Gt => "sgt",
                    BinOp::Le => "sle",
                    BinOp::Ge => "sge",
                    _ => unreachable!(),
                };
                let _ = writeln!(out, "  {reg} = icmp {pred} i64 {lhs_val}, {rhs_val}");
                Ok((Type::Bool, reg))
            }

            BinOp::And | BinOp::Or => unreachable!(),
        }
    }

    fn emit_equality(
        &mut self,
        lhs_ty: &Type,
        lhs_val: &str,
        rhs_ty: &Type,
        rhs_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        if lhs_ty != rhs_ty {
            return Err(Diagnostic::new(
                format!("cannot compare `{}` and `{}`", lhs_ty.name(), rhs_ty.name()),
                span,
            ));
        }
        match lhs_ty {
            Type::Int => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = icmp eq i64 {lhs_val}, {rhs_val}");
                Ok(reg)
            }
            Type::Bool => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = icmp eq i1 {lhs_val}, {rhs_val}");
                Ok(reg)
            }
            Type::Str => {
                self.used_str_eq = true;
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call fastcc i1 @archx_str_eq(%ArchxStr {lhs_val}, %ArchxStr {rhs_val})"
                );
                Ok(reg)
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut acc: Option<String> = None;
                for (i, f) in fields.iter().enumerate() {
                    let lf = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {lf} = extractvalue %ArchxStruct_{sname} {lhs_val}, {i}"
                    );
                    let rf = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {rf} = extractvalue %ArchxStruct_{sname} {rhs_val}, {i}"
                    );
                    let feq = self.emit_equality(&f.ty, &lf, &f.ty, &rf, span, out)?;
                    acc = Some(match acc {
                        None => feq,
                        Some(prev) => {
                            let both = self.next_tmp();
                            let _ = writeln!(out, "  {both} = and i1 {prev}, {feq}");
                            both
                        }
                    });
                }
                Ok(acc.unwrap_or_else(|| "true".to_string()))
            }
            _ => Err(Diagnostic::new(
                format!("equality is not supported on `{}`", lhs_ty.name()),
                span,
            )),
        }
    }

    fn emit_str_concat_call(&mut self, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        self.used_str_concat = true;
        let reg_arg = if !self.region_stack.is_empty() {
            self.func_region_slot.clone().unwrap()
        } else {
            "null".to_string()
        };
        let res = self.next_tmp();
        let _ = writeln!(
            out,
            "  {res} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {lhs_val}, %ArchxStr {rhs_val}, ptr {reg_arg})"
        );
        if self.region_stack.is_empty() {
            self.stmt_temps.push(TempDrop {
                val: res.clone(),
                ty: Type::Str,
            });
        }
        res
    }

    fn emit_int_arith(&mut self, op: BinOp, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        if let (Ok(a), Ok(b)) = (lhs_val.parse::<i64>(), rhs_val.parse::<i64>()) {
            let folded = match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                BinOp::Div if b != 0 => Some(a.wrapping_div(b)),
                BinOp::Mod if b != 0 => Some(a.wrapping_rem(b)),
                _ => None,
            };
            if let Some(res) = folded {
                return res.to_string();
            }
        }

        if matches!(op, BinOp::Div | BinOp::Mod) {
            let instr = if op == BinOp::Div { "sdiv" } else { "srem" };
            if let Ok(b) = rhs_val.parse::<i64>() {
                if b == 0 {
                    self.used_div_zero_fail = true;
                    let ok_lbl = self.fresh_label("div.after");
                    let _ = writeln!(out, "  call void @archx_div_zero_fail()");
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                    self.start_block(&ok_lbl, out);
                    return "0".to_string();
                }
                if b == -1 {
                    if op == BinOp::Mod {
                        return "0".to_string();
                    }
                    let neg = self.next_tmp();
                    let _ = writeln!(out, "  {neg} = sub i64 0, {lhs_val}");
                    return neg;
                }
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
                return reg;
            }

            self.used_div_zero_fail = true;
            let dz = self.next_tmp();
            let _ = writeln!(out, "  {dz} = icmp eq i64 {rhs_val}, 0");
            let dz_lbl = self.fresh_label("div.zero");
            let ok_lbl = self.fresh_label("div.ok");
            self.emit_cond_br(&dz, &dz_lbl, &ok_lbl, out);

            self.start_block(&dz_lbl, out);
            let _ = writeln!(out, "  call void @archx_div_zero_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&ok_lbl, out);
            let is_min = self.next_tmp();
            let _ = writeln!(out, "  {is_min} = icmp eq i64 {lhs_val}, {}", i64::MIN);
            let is_neg1 = self.next_tmp();
            let _ = writeln!(out, "  {is_neg1} = icmp eq i64 {rhs_val}, -1");
            let ovf = self.next_tmp();
            let _ = writeln!(out, "  {ovf} = and i1 {is_min}, {is_neg1}");
            let safe_rhs = self.next_tmp();
            let _ = writeln!(out, "  {safe_rhs} = select i1 {ovf}, i64 1, i64 {rhs_val}");
            let reg = self.next_tmp();
            let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {safe_rhs}");
            return reg;
        }

        let reg = self.next_tmp();
        let instr = match op {
            BinOp::Add => "add",
            BinOp::Sub => "sub",
            BinOp::Mul => "mul",
            _ => unreachable!(),
        };
        let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
        reg
    }

    fn gen_short_circuit(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mark = self.stmt_temps.len();
        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        if lhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    lhs_ty.name()
                ),
                span,
            ));
        }
        self.flush_stmt_temps_from(mark, out);

        let slot = self.next_slot("bool.result");
        let _ = writeln!(self.allocas, "  {slot} = alloca i1, align 1");

        let initial = if op == BinOp::And { "false" } else { "true" };
        let _ = writeln!(out, "  store i1 {initial}, ptr {slot}, align 1");

        let rhs_label = self.fresh_label("bool.rhs");
        let merge_label = self.fresh_label("bool.merge");

        if op == BinOp::And {
            self.emit_cond_br(&lhs_val, &rhs_label, &merge_label, out);
        } else {
            self.emit_cond_br(&lhs_val, &merge_label, &rhs_label, out);
        }

        self.start_block(&rhs_label, out);
        let mark_rhs = self.stmt_temps.len();
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;
        if rhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    rhs_ty.name()
                ),
                rhs.span,
            ));
        }
        self.flush_stmt_temps_from(mark_rhs, out);
        let _ = writeln!(out, "  store i1 {rhs_val}, ptr {slot}, align 1");
        self.emit_br(&merge_label, out);

        self.start_block(&merge_label, out);
        let result = self.next_tmp();
        let _ = writeln!(out, "  {result} = load i1, ptr {slot}, align 1");
        Ok((Type::Bool, result))
    }

    // ---------------- Calls & struct constructors ----------------------------

    fn gen_call(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if name == "print" {
            return self.gen_builtin_print(args, span, out);
        }
        if name == "len" {
            return self.gen_builtin_len(args, span, out);
        }
        if name == "push" {
            return self.gen_builtin_push(args, span, out);
        }
        if name == "pop" {
            return self.gen_builtin_pop(args, span, out);
        }

        if let Some(fields) = self.structs.get(name).cloned() {
            if args.len() != fields.len() {
                return Err(Diagnostic::new(
                    format!(
                        "struct `{name}` expects {} field{}, but {} {} supplied",
                        fields.len(),
                        if fields.len() == 1 { "" } else { "s" },
                        args.len(),
                        if args.len() == 1 { "was" } else { "were" }
                    ),
                    span,
                ));
            }
            let mut agg = "poison".to_string();
            for (i, arg) in args.iter().enumerate() {
                let fty = &fields[i].ty;
                let (aty, raw_val) = self.eval_expr_typed(arg, Some(fty), out)?;
                if aty != *fty {
                    return Err(Diagnostic::new(
                        format!(
                            "field `{}` of `{name}` expects `{}`, found `{}`",
                            fields[i].name,
                            fty.name(),
                            aty.name()
                        ),
                        arg.span,
                    ));
                }
                let fval = if self.type_needs_drop(fty) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(fty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                let next_agg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {next_agg} = insertvalue %ArchxStruct_{name} {agg}, {} {fval}, {i}",
                    ir_type(fty)
                );
                agg = next_agg;
            }
            let sty = Type::Struct(name.to_string());
            if self.type_needs_drop(&sty) {
                self.stmt_temps.push(TempDrop {
                    val: agg.clone(),
                    ty: sty.clone(),
                });
            }
            return Ok((sty, agg));
        }

        if name == "main" {
            return Err(Diagnostic::new("`main` cannot be called directly", span));
        }

        let sig = self
            .sigs
            .get(name)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("undefined function `{name}`"), span))?;

        if args.len() != sig.params.len() {
            return Err(Diagnostic::new(
                format!(
                    "function `{name}` expects {} argument{}, but {} {} supplied",
                    sig.params.len(),
                    if sig.params.len() == 1 { "" } else { "s" },
                    args.len(),
                    if args.len() == 1 { "was" } else { "were" }
                ),
                span,
            ));
        }

        let mut arg_vals = Vec::new();
        for (i, arg) in args.iter().enumerate() {
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            if ty != sig.params[i] {
                return Err(Diagnostic::new(
                    format!(
                        "argument {} of `{name}` expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            }
            arg_vals.push((ty, val));
        }

        if sig.ret.is_none() {
            let mut call = format!("  call fastcc void {}(", mangle(name));
            for (i, (ty, val)) in arg_vals.iter().enumerate() {
                if i > 0 {
                    call.push_str(", ");
                }
                let _ = write!(call, "{} {}", ir_type(ty), val);
            }
            call.push_str(")\n");
            out.push_str(&call);
            return Ok((Type::Void, String::new()));
        }

        let reg = self.next_tmp();
        let ret_ir = ir_ret_type(sig.ret.as_ref());
        let mut call = format!("  {reg} = call fastcc {ret_ir} {}(", mangle(name));
        for (i, (ty, val)) in arg_vals.iter().enumerate() {
            if i > 0 {
                call.push_str(", ");
            }
            let _ = write!(call, "{} {}", ir_type(ty), val);
        }
        call.push_str(")\n");
        out.push_str(&call);

        match sig.ret {
            Some(ty) => {
                if self.type_needs_drop(&ty) {
                    self.stmt_temps.push(TempDrop {
                        val: reg.clone(),
                        ty: ty.clone(),
                    });
                }
                Ok((ty, reg))
            }
            None => Ok((Type::Void, String::new())),
        }
    }

    fn gen_builtin_print(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`print` takes exactly one argument", span));
        }

        if let ExprKind::Str(lit) = &args[0].kind {
            if !lit.as_bytes().contains(&0) {
                let sym = self.strings.intern(lit);
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {sym})"
                );
                return Ok((Type::Void, reg));
            }
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Str => {
                self.used_str_print = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_str_print(%ArchxStr {val}, i1 true)"
                );
                Ok((Type::Void, String::new()))
            }
            Type::Int => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 {val})"
                );
                Ok((Type::Void, reg))
            }
            Type::Bool => {
                let selected = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {selected} = select i1 {val}, ptr @.str.true, ptr @.str.false"
                );
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {selected})"
                );
                Ok((Type::Void, reg))
            }
            Type::Array(elem_ty) => {
                if !matches!(*elem_ty, Type::Int | Type::Bool | Type::Str) {
                    return Err(Diagnostic::new(
                        "`print` supports 1D arrays (`[int]`, `[bool]`, `[string]`); print elements in a loop for structs or nested arrays",
                        span,
                    ));
                }
                self.used_array_print = true;
                let open = self.next_tmp();
                let _ = writeln!(out, "  {open} = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)");

                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {val}, 0");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");

                let idx_slot = self.next_slot("print.idx");
                let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
                let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

                let cond_lbl = self.fresh_label("print.cond");
                let body_lbl = self.fresh_label("print.body");
                let sep_lbl = self.fresh_label("print.sep");
                let elem_lbl = self.fresh_label("print.elem");
                let end_lbl = self.fresh_label("print.end");

                self.emit_br(&cond_lbl, out);
                self.start_block(&cond_lbl, out);
                let pi = self.next_tmp();
                let _ = writeln!(out, "  {pi} = load i64, ptr {idx_slot}, align 8");
                let pcmp = self.next_tmp();
                let _ = writeln!(out, "  {pcmp} = icmp slt i64 {pi}, {len}");
                self.emit_cond_br(&pcmp, &body_lbl, &end_lbl, out);

                self.start_block(&body_lbl, out);
                let gt0 = self.next_tmp();
                let _ = writeln!(out, "  {gt0} = icmp sgt i64 {pi}, 0");
                self.emit_cond_br(&gt0, &sep_lbl, &elem_lbl, out);

                self.start_block(&sep_lbl, out);
                let sc = self.next_tmp();
                let _ = writeln!(out, "  {sc} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)");
                self.emit_br(&elem_lbl, out);

                self.start_block(&elem_lbl, out);
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {pi}"
                );
                let elem_val = self.emit_elem_load(&elem_ty, &ep, out);
                match *elem_ty {
                    Type::Int => {
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 {elem_val})"
                        );
                    }
                    Type::Str => {
                        self.used_str_print = true;
                        let _ = writeln!(
                            out,
                            "  call fastcc void @archx_str_print(%ArchxStr {elem_val}, i1 false)"
                        );
                    }
                    Type::Bool => {
                        let sel = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {sel} = select i1 {elem_val}, ptr @.str.true, ptr @.str.false"
                        );
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {sel})"
                        );
                    }
                    _ => unreachable!(),
                }
                let pnext = self.next_tmp();
                let _ = writeln!(out, "  {pnext} = add nsw i64 {pi}, 1");
                let _ = writeln!(out, "  store i64 {pnext}, ptr {idx_slot}, align 8");
                self.emit_br(&cond_lbl, out);

                self.start_block(&end_lbl, out);
                let close = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {close} = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)"
                );
                Ok((Type::Void, close))
            }
            Type::Struct(sname) => Err(Diagnostic::new(
                format!(
                    "`print` does not format struct `{sname}` automatically; print its fields (e.g. `p.x`)"
                ),
                span,
            )),
            Type::Void => Err(Diagnostic::new("`print` cannot print `void`", span)),
        }
    }

    fn gen_builtin_len(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`len` takes exactly one argument", span));
        }

        if let ExprKind::Str(lit) = &args[0].kind {
            return Ok((Type::Int, (lit.len() as i64).to_string()));
        }

        if let ExprKind::Var(name) = &args[0].kind {
            if let Some(&KnownLen::Const(c)) = self.lookup_known_len(name) {
                if let Some(entry) = self.lookup_var(name) {
                    if entry.ty.is_array() {
                        return Ok((Type::Int, c.to_string()));
                    }
                }
            }
            if let Some(entry) = self.lookup_var(name).cloned() {
                if let VarStorage::Soa { len_val, .. } = entry.storage {
                    return Ok((Type::Int, len_val));
                }
            }
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Array(_) => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = extractvalue %ArchxVec {val}, 0");
                Ok((Type::Int, reg))
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {val}, 0");
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = and i64 {w0}, 4294967295");
                Ok((Type::Int, reg))
            }
            other => Err(Diagnostic::new(
                format!(
                    "`len` expects an array or `string`, found `{}`",
                    other.name()
                ),
                args[0].span,
            )),
        }
    }

    fn gen_builtin_push(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                "`push` takes exactly 2 arguments: `push(array, value)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "first argument to `push` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `push` onto borrowed parameter `{arr_name}`; assign to a local array first"
                ),
                args[0].span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty.clone() else {
            return Err(Diagnostic::new(
                format!("`push` expects an array, found `{}`", entry.ty.name()),
                args[0].span,
            ));
        };
        self.check_region_escape_target(arr_name, &elem_ty, span)?;

        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: pushed array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        let (val_ty, raw_val) = self.eval_expr_typed(&args[1], Some(&elem_ty), out)?;
        if val_ty != *elem_ty {
            return Err(Diagnostic::new(
                format!(
                    "`push` onto `[{}]` expects `{}`, found `{}`",
                    elem_ty.name(),
                    elem_ty.name(),
                    val_ty.name()
                ),
                args[1].span,
            ));
        }
        let val = if self.type_needs_drop(&elem_ty) {
            if self.claim_stmt_temp(&raw_val) {
                raw_val
            } else {
                self.emit_clone_value(&elem_ty, &raw_val, out)
            }
        } else {
            raw_val
        };

        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

        let is_reg = self.next_tmp();
        let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
        let neg_cap = self.next_tmp();
        let _ = writeln!(out, "  {neg_cap} = sub nsw i64 0, {cap}");
        let eff_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {eff_cap} = select i1 {is_reg}, i64 {neg_cap}, i64 {cap}"
        );

        let full = self.next_tmp();
        let _ = writeln!(out, "  {full} = icmp sge i64 {len}, {eff_cap}");
        let grow_lbl = self.fresh_label("push.grow");
        let store_lbl = self.fresh_label("push.store");
        self.emit_cond_br(&full, &grow_lbl, &store_lbl, out);

        self.start_block(&grow_lbl, out);
        let lim = self.next_tmp();
        let _ = writeln!(out, "  {lim} = icmp sge i64 {len}, {MAX_ARRAY_LEN}");
        self.used_oom_fail = true;
        let oom_lbl = self.fresh_label("push.oom");
        let calc_lbl = self.fresh_label("push.calc");
        self.emit_cond_br(&lim, &oom_lbl, &calc_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&calc_lbl, out);
        let zero_cap = self.next_tmp();
        let _ = writeln!(out, "  {zero_cap} = icmp eq i64 {eff_cap}, 0");
        let doubled = self.next_tmp();
        let _ = writeln!(out, "  {doubled} = shl i64 {eff_cap}, 1");
        let cand_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {cand_cap} = select i1 {zero_cap}, i64 4, i64 {doubled}"
        );
        let over_max = self.next_tmp();
        let _ = writeln!(out, "  {over_max} = icmp sgt i64 {cand_cap}, {MAX_ARRAY_LEN}");
        let new_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {new_cap} = select i1 {over_max}, i64 {MAX_ARRAY_LEN}, i64 {cand_cap}"
        );
        let elem_sz_val = self.emit_elem_sizeof(&elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&new_cap, &elem_sz_val, out);

        let was_reg_lbl = self.fresh_label("push.grow.from_reg");
        let was_heap_lbl = self.fresh_label("push.grow.from_heap");
        self.emit_cond_br(&is_reg, &was_reg_lbl, &was_heap_lbl, out);

        self.start_block(&was_reg_lbl, out);
        let old_bytes = self.emit_elem_bytes_val_mul(&len, &elem_sz_val, out);
        let (reg_new_ptr, reg_new_cap) = if !self.region_stack.is_empty()
            && !self.type_needs_drop(&elem_ty)
        {
            let rslot = self.func_region_slot.clone().unwrap();
            let rp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {rp} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            let nc = self.next_tmp();
            let _ = writeln!(out, "  {nc} = sub nsw i64 0, {new_cap}");
            (rp, nc)
        } else {
            let hp = self.emit_checked_malloc(&bytes, out);
            (hp, new_cap.clone())
        };
        self.used_memcpy = true;
        let has_old = self.next_tmp();
        let _ = writeln!(out, "  {has_old} = icmp sgt i64 {old_bytes}, 0");
        let cp_lbl = self.fresh_label("push.reg.copy");
        let cp_done_lbl = self.fresh_label("push.reg.copied");
        self.emit_cond_br(&has_old, &cp_lbl, &cp_done_lbl, out);
        self.start_block(&cp_lbl, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {reg_new_ptr}, ptr align 8 {data}, i64 {old_bytes}, i1 false)"
        );
        self.emit_br(&cp_done_lbl, out);
        self.start_block(&cp_done_lbl, out);
        let gvec_reg = self.build_vec_val(&len, &reg_new_cap, &reg_new_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_reg}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&was_heap_lbl, out);
        let grown_ptr = self.emit_checked_realloc(&data, &bytes, out);
        let gvec_heap = self.build_vec_val(&len, &new_cap, &grown_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_heap}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&store_lbl, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(out, "  {vec2} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let data2 = self.next_tmp();
        let _ = writeln!(out, "  {data2} = extractvalue %ArchxVec {vec2}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data2}, i64 {len}"
        );
        self.emit_elem_store(&elem_ty, &val, &ep, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = add nsw i64 {len}, 1");
        let vec3 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec3} = insertvalue %ArchxVec {vec2}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec3}, ptr {slot_ptr}, align 8");

        Ok((Type::Void, String::new()))
    }

    fn gen_builtin_pop(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new(
                "`pop` takes exactly 1 argument: `pop(array)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "argument to `pop` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `pop` from borrowed parameter `{arr_name}`; assign to a local array first"
                ),
                args[0].span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty else {
            return Err(Diagnostic::new(
                format!("`pop` expects an array, found `{}`", entry.ty.name()),
                args[0].span,
            ));
        };
        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: popped array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        self.used_pop_empty_fail = true;
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let empty = self.next_tmp();
        let _ = writeln!(out, "  {empty} = icmp sle i64 {len}, 0");
        let ok_lbl = self.fresh_label("pop.ok");
        let fail_lbl = self.fresh_label("pop.empty");
        self.emit_cond_br(&empty, &fail_lbl, &ok_lbl, out);

        self.start_block(&fail_lbl, out);
        let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = sub nsw i64 {len}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {next_len}"
        );
        let elem = self.emit_elem_load(&elem_ty, &ep, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec2} = insertvalue %ArchxVec {vec}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec2}, ptr {slot_ptr}, align 8");

        if self.type_needs_drop(&elem_ty) {
            self.stmt_temps.push(TempDrop {
                val: elem.clone(),
                ty: (*elem_ty).clone(),
            });
        }
        Ok((*elem_ty, elem))
    }

    // ---------------- Ownership, Drop, Clone & Heap Promotion ----------------

    fn type_needs_drop(&self, ty: &Type) -> bool {
        match ty {
            Type::Int | Type::Bool | Type::Void => false,
            Type::Str | Type::Array(_) => true,
            Type::Struct(name) => self
                .structs
                .get(name)
                .map_or(false, |fs| fs.iter().any(|f| self.type_needs_drop(&f.ty))),
        }
    }

    fn claim_stmt_temp(&mut self, val: &str) -> bool {
        if let Some(pos) = self.stmt_temps.iter().rposition(|t| t.val == val) {
            self.stmt_temps.remove(pos);
            true
        } else {
            false
        }
    }

    fn flush_stmt_temps(&mut self, out: &mut String) {
        self.flush_stmt_temps_from(0, out);
    }

    fn flush_stmt_temps_from(&mut self, mark: usize, out: &mut String) {
        if self.terminated || self.stmt_temps.len() <= mark {
            self.stmt_temps.truncate(mark);
            return;
        }
        let drained: Vec<TempDrop> = self.stmt_temps.drain(mark..).collect();
        for td in drained.into_iter().rev() {
            self.emit_drop_value(&td.ty, &td.val, out);
        }
    }

    fn emit_drop_value(&mut self, ty: &Type, val: &str, out: &mut String) {
        if !self.type_needs_drop(ty) {
            return;
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return;
                }
                self.used_str_drop = true;
                let _ = writeln!(out, "  call fastcc void @archx_str_drop(%ArchxStr {val})");
            }
            Type::Array(elem_ty) => {
                if !self.type_needs_drop(elem_ty) {
                    self.used_free = true;
                    let cap = self.next_tmp();
                    let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {val}, 1");
                    let heap = self.next_tmp();
                    let _ = writeln!(out, "  {heap} = icmp sgt i64 {cap}, 0");
                    let do_lbl = self.fresh_label("drop.vec.free");
                    let done_lbl = self.fresh_label("drop.vec.done");
                    self.emit_cond_br(&heap, &do_lbl, &done_lbl, out);
                    self.start_block(&do_lbl, out);
                    let dp = self.next_tmp();
                    let _ = writeln!(out, "  {dp} = extractvalue %ArchxVec {val}, 2");
                    let _ = writeln!(out, "  call void @free(ptr {dp})");
                    self.emit_br(&done_lbl, out);
                    self.start_block(&done_lbl, out);
                } else {
                    let fn_sym = self.ensure_vec_drop_helper(elem_ty);
                    let _ = writeln!(out, "  call fastcc void {fn_sym}(%ArchxVec {val})");
                }
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        self.emit_drop_value(&f.ty, &fv, out);
                    }
                }
            }
            _ => {}
        }
    }

    fn emit_clone_value(&mut self, ty: &Type, val: &str, out: &mut String) -> String {
        if !self.type_needs_drop(ty) {
            return val.to_string();
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return val.to_string();
                }
                self.used_str_clone = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_clone(%ArchxStr {val})"
                );
                res
            }
            Type::Array(elem_ty) => {
                let fn_sym = self.ensure_vec_clone_helper(elem_ty);
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxVec {fn_sym}(%ArchxVec {val})"
                );
                res
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut agg = val.to_string();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        let cv = self.emit_clone_value(&f.ty, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue %ArchxStruct_{sname} {agg}, {} {cv}, {i}",
                            ir_type(&f.ty)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            _ => val.to_string(),
        }
    }

    fn emit_promote_to_heap(&mut self, ty: &Type, val: &str, out: &mut String) -> String {
        if !self.type_needs_drop(ty) {
            return val.to_string();
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return val.to_string();
                }
                self.used_str_promote = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_promote(%ArchxStr {val})"
                );
                res
            }
            Type::Array(elem_ty) => {
                if !self.type_needs_drop(elem_ty) {
                    let cap = self.next_tmp();
                    let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {val}, 1");
                    let is_reg = self.next_tmp();
                    let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
                    let clone_lbl = self.fresh_label("prom.vec.clone");
                    let done_lbl = self.fresh_label("prom.vec.done");
                    let orig_lbl = self.fresh_label("prom.vec.orig");
                    self.emit_cond_br(&is_reg, &clone_lbl, &orig_lbl, out);

                    self.start_block(&orig_lbl, out);
                    self.emit_br(&done_lbl, out);

                    self.start_block(&clone_lbl, out);
                    let cloned = self.emit_clone_value(ty, val, out);
                    self.emit_br(&done_lbl, out);

                    self.start_block(&done_lbl, out);
                    let phi = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {phi} = phi %ArchxVec [ {val}, %{orig_lbl} ], [ {cloned}, %{clone_lbl} ]"
                    );
                    phi
                } else {
                    let cloned = self.emit_clone_value(ty, val, out);
                    self.emit_drop_value(ty, val, out);
                    cloned
                }
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut agg = val.to_string();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        let pv = self.emit_promote_to_heap(&f.ty, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue %ArchxStruct_{sname} {agg}, {} {pv}, {i}",
                            ir_type(&f.ty)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            _ => val.to_string(),
        }
    }

    fn ensure_vec_drop_helper(&mut self, elem_ty: &Type) -> String {
        let key = type_mangle_key(elem_ty);
        let sym = format!("@archx_vec_drop_{key}");
        if self.emitted_vec_drops.contains(&key) {
            return sym;
        }
        self.emitted_vec_drops.insert(key);
        self.used_vec_type = true;
        self.used_free = true;

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc void {sym}(%ArchxVec %v) nounwind {{");
        let _ = writeln!(h, "entry:");
        let _ = writeln!(h, "  %len = extractvalue %ArchxVec %v, 0");
        let _ = writeln!(h, "  %cap = extractvalue %ArchxVec %v, 1");
        let _ = writeln!(h, "  %data = extractvalue %ArchxVec %v, 2");
        let _ = writeln!(h, "  %has_elems = icmp sgt i64 %len, 0");
        let _ = writeln!(h, "  br i1 %has_elems, label %loop.pre, label %check.free");
        let _ = writeln!(h, "loop.pre:");
        let _ = writeln!(h, "  br label %loop");
        let _ = writeln!(h, "loop:");
        let _ = writeln!(h, "  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]");
        let mem_ty = elem_mem_ir_type(elem_ty);
        let _ = writeln!(h, "  %ep = getelementptr inbounds {mem_ty}, ptr %data, i64 %i");
        let ev = self.emit_elem_load(elem_ty, "%ep", &mut h);
        self.emit_drop_value(elem_ty, &ev, &mut h);
        let _ = writeln!(h, "  br label %loop.latch");
        let _ = writeln!(h, "loop.latch:");
        let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
        let _ = writeln!(h, "  %more = icmp slt i64 %inext, %len");
        let _ = writeln!(h, "  br i1 %more, label %loop, label %check.free");
        let _ = writeln!(h, "check.free:");
        let _ = writeln!(h, "  %is_heap = icmp sgt i64 %cap, 0");
        let _ = writeln!(h, "  br i1 %is_heap, label %do.free, label %done");
        let _ = writeln!(h, "do.free:");
        let _ = writeln!(h, "  call void @free(ptr %data)");
        let _ = writeln!(h, "  br label %done");
        let _ = writeln!(h, "done:");
        let _ = writeln!(h, "  ret void");
        let _ = writeln!(h, "}}\n");

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }

    fn ensure_vec_clone_helper(&mut self, elem_ty: &Type) -> String {
        let key = type_mangle_key(elem_ty);
        let sym = format!("@archx_vec_clone_{key}");
        if self.emitted_vec_clones.contains(&key) {
            return sym;
        }
        self.emitted_vec_clones.insert(key);
        self.used_vec_type = true;
        self.used_malloc = true;
        self.used_oom_fail = true;

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc %ArchxVec {sym}(%ArchxVec %v) {{");
        let _ = writeln!(h, "entry:");
        let _ = writeln!(h, "  %len = extractvalue %ArchxVec %v, 0");
        let _ = writeln!(h, "  %src = extractvalue %ArchxVec %v, 2");
        let _ = writeln!(h, "  %empty = icmp sle i64 %len, 0");
        let _ = writeln!(h, "  br i1 %empty, label %ret.empty, label %alloc");
        let _ = writeln!(h, "ret.empty:");
        let _ = writeln!(h, "  ret %ArchxVec zeroinitializer");
        let _ = writeln!(h, "alloc:");
        let esz = self.emit_elem_sizeof(elem_ty, &mut h);
        let bytes = self.emit_elem_bytes_val_mul("%len", &esz, &mut h);
        let dst = self.emit_checked_malloc(&bytes, &mut h);
        if !self.type_needs_drop(elem_ty) {
            self.used_memcpy = true;
            let _ = writeln!(
                h,
                "  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 {dst}, ptr nonnull align 1 %src, i64 {bytes}, i1 false)"
            );
            let _ = writeln!(h, "  br label %finish");
        } else {
            let mem_ty = elem_mem_ir_type(elem_ty);
            let _ = writeln!(h, "  br label %loop.pre");
            let _ = writeln!(h, "loop.pre:");
            let _ = writeln!(h, "  br label %loop");
            let _ = writeln!(h, "loop:");
            let _ = writeln!(h, "  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]");
            let _ = writeln!(h, "  %sp = getelementptr inbounds {mem_ty}, ptr %src, i64 %i");
            let _ = writeln!(h, "  %dp = getelementptr inbounds {mem_ty}, ptr {dst}, i64 %i");
            let sv = self.emit_elem_load(elem_ty, "%sp", &mut h);
            let cv = self.emit_clone_value(elem_ty, &sv, &mut h);
            self.emit_elem_store(elem_ty, &cv, "%dp", &mut h);
            let _ = writeln!(h, "  br label %loop.latch");
            let _ = writeln!(h, "loop.latch:");
            let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
            let _ = writeln!(h, "  %more = icmp slt i64 %inext, %len");
            let _ = writeln!(h, "  br i1 %more, label %loop, label %finish");
        }
        let _ = writeln!(h, "finish:");
        let out_vec = self.build_vec_val("%len", "%len", &dst, &mut h);
        let _ = writeln!(h, "  ret %ArchxVec {out_vec}");
        let _ = writeln!(h, "}}\n");

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }

    // ---------------- Array & Memory Helpers ---------------------------------

    fn build_vec_val(&mut self, len: &str, cap: &str, data: &str, out: &mut String) -> String {
        let v0 = self.next_tmp();
        let _ = writeln!(out, "  {v0} = insertvalue %ArchxVec poison, i64 {len}, 0");
        let v1 = self.next_tmp();
        let _ = writeln!(out, "  {v1} = insertvalue %ArchxVec {v0}, i64 {cap}, 1");
        let v2 = self.next_tmp();
        let _ = writeln!(out, "  {v2} = insertvalue %ArchxVec {v1}, ptr {data}, 2");
        v2
    }

    fn emit_elem_sizeof(&mut self, elem_ty: &Type, out: &mut String) -> String {
        match elem_ty {
            Type::Bool => "1".to_string(),
            Type::Int => "8".to_string(),
            Type::Str => "16".to_string(),
            Type::Array(_) => "24".to_string(),
            Type::Struct(sname) => {
                let gp = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {gp} = getelementptr %ArchxStruct_{sname}, ptr null, i64 1"
                );
                let sz = self.next_tmp();
                let _ = writeln!(out, "  {sz} = ptrtoint ptr {gp} to i64");
                sz
            }
            Type::Void => "0".to_string(),
        }
    }

    fn emit_type_bytes_const_mul(&mut self, elem_ty: &Type, count: i64, out: &mut String) -> String {
        if count == 0 {
            return "1".to_string();
        }
        let sz = self.emit_elem_sizeof(elem_ty, out);
        if let Ok(c_sz) = sz.parse::<i64>() {
            return (count * c_sz).to_string();
        }
        self.emit_elem_bytes_val_mul(&count.to_string(), &sz, out)
    }

    fn emit_elem_bytes_val_mul(&mut self, count: &str, elem_sz: &str, out: &mut String) -> String {
        if elem_sz == "1" {
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = icmp eq i64 {count}, 0");
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = select i1 {z}, i64 1, i64 {count}");
            return r;
        }
        self.used_smul_ovf = true;
        self.used_oom_fail = true;
        let pair = self.next_tmp();
        let _ = writeln!(
            out,
            "  {pair} = call {{ i64, i1 }} @llvm.smul.with.overflow.i64(i64 {count}, i64 {elem_sz})"
        );
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = extractvalue {{ i64, i1 }} {pair}, 0");
        let ovf = self.next_tmp();
        let _ = writeln!(out, "  {ovf} = extractvalue {{ i64, i1 }} {pair}, 1");
        let oom_lbl = self.fresh_label("mul.oom");
        let ok_lbl = self.fresh_label("mul.ok");
        self.emit_cond_br(&ovf, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let z = self.next_tmp();
        let _ = writeln!(out, "  {z} = icmp eq i64 {raw}, 0");
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = select i1 {z}, i64 1, i64 {raw}");
        r
    }

    fn emit_elem_bytes_mul(&mut self, count: &str, elem_size: i64, out: &mut String) -> String {
        let raw = if elem_size == 1 {
            count.to_string()
        } else {
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = mul nuw nsw i64 {count}, {elem_size}");
            r
        };
        let z = self.next_tmp();
        let _ = writeln!(out, "  {z} = icmp eq i64 {raw}, 0");
        let safe = self.next_tmp();
        let _ = writeln!(out, "  {safe} = select i1 {z}, i64 1, i64 {raw}");
        safe
    }

    fn emit_checked_malloc(&mut self, bytes: &str, out: &mut String) -> String {
        self.used_malloc = true;
        self.used_oom_fail = true;
        let ptr = self.next_tmp();
        let _ = writeln!(out, "  {ptr} = call noalias align 16 ptr @malloc(i64 {bytes})");
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("alloc.ok");
        let oom_lbl = self.fresh_label("alloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    fn emit_checked_calloc(&mut self, count: &str, elem_size: i64, out: &mut String) -> String {
        self.used_calloc = true;
        self.used_oom_fail = true;
        let safe_count = if count == "0" {
            "1".to_string()
        } else {
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = icmp eq i64 {count}, 0");
            let s = self.next_tmp();
            let _ = writeln!(out, "  {s} = select i1 {z}, i64 1, i64 {count}");
            s
        };
        let ptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ptr} = call noalias align 16 ptr @calloc(i64 {safe_count}, i64 {elem_size})"
        );
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("calloc.ok");
        let oom_lbl = self.fresh_label("calloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    fn emit_checked_realloc(&mut self, old_ptr: &str, bytes: &str, out: &mut String) -> String {
        self.used_realloc = true;
        self.used_oom_fail = true;
        let ptr = self.next_tmp();
        let _ = writeln!(out, "  {ptr} = call align 16 ptr @realloc(ptr {old_ptr}, i64 {bytes})");
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("realloc.ok");
        let oom_lbl = self.fresh_label("realloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    fn emit_scalar_fill_loop(
        &mut self,
        elem_ty: &Type,
        init_val: &str,
        data_ptr: &str,
        count_val: &str,
        out: &mut String,
    ) {
        if *elem_ty == Type::Bool {
            self.used_memset = true;
            let byte_val = self.next_tmp();
            let _ = writeln!(out, "  {byte_val} = zext i1 {init_val} to i8");
            let _ = writeln!(
                out,
                "  call void @llvm.memset.p0.i64(ptr nonnull align 16 {data_ptr}, i8 {byte_val}, i64 {count_val}, i1 false)"
            );
            return;
        }
        if *elem_ty == Type::Int && init_val == "0" {
            self.used_memset = true;
            let bytes = self.next_tmp();
            let _ = writeln!(out, "  {bytes} = shl nuw nsw i64 {count_val}, 3");
            let _ = writeln!(
                out,
                "  call void @llvm.memset.p0.i64(ptr nonnull align 16 {data_ptr}, i8 0, i64 {bytes}, i1 false)"
            );
            return;
        }

        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = icmp sgt i64 {count_val}, 0");
        let pre_lbl = self.fresh_label("fill.pre");
        let body_lbl = self.fresh_label("fill.body");
        let end_lbl = self.fresh_label("fill.end");
        self.emit_cond_br(&pos, &pre_lbl, &end_lbl, out);

        self.start_block(&pre_lbl, out);
        self.emit_br(&body_lbl, out);

        self.start_block(&body_lbl, out);
        let fi = self.next_tmp();
        let fnext = self.next_tmp();
        let _ = writeln!(
            out,
            "  {fi} = phi i64 [ 0, %{pre_lbl} ], [ {fnext}, %{body_lbl} ]"
        );
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds i64, ptr {data_ptr}, i64 {fi}"
        );
        let _ = writeln!(out, "  store i64 {init_val}, ptr {ep}, align 8");
        let _ = writeln!(out, "  {fnext} = add nuw nsw i64 {fi}, 1");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {fnext}, {count_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&end_lbl, out);
    }

    fn emit_general_fill_loop(
        &mut self,
        elem_ty: &Type,
        raw_init: &str,
        data_ptr: &str,
        count_val: &str,
        out: &mut String,
    ) {
        if matches!(elem_ty, Type::Int | Type::Bool) {
            self.emit_scalar_fill_loop(elem_ty, raw_init, data_ptr, count_val, out);
            return;
        }

        let needs_drop = self.type_needs_drop(elem_ty);
        let owned_proto = needs_drop && self.claim_stmt_temp(raw_init);

        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = icmp sgt i64 {count_val}, 0");
        let pre_lbl = self.fresh_label("gfill.pre");
        let body_lbl = self.fresh_label("gfill.body");
        let latch_lbl = self.fresh_label("gfill.latch");
        let end_lbl = self.fresh_label("gfill.end");
        self.emit_cond_br(&pos, &pre_lbl, &end_lbl, out);

        self.start_block(&pre_lbl, out);
        self.emit_br(&body_lbl, out);

        self.start_block(&body_lbl, out);
        let fi = self.next_tmp();
        let fnext = self.next_tmp();
        let _ = writeln!(
            out,
            "  {fi} = phi i64 [ 0, %{pre_lbl} ], [ {fnext}, %{latch_lbl} ]"
        );
        let mem_ty = elem_mem_ir_type(elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {fi}"
        );
        let elem_copy = if needs_drop {
            self.emit_clone_value(elem_ty, raw_init, out)
        } else {
            raw_init.to_string()
        };
        self.emit_elem_store(elem_ty, &elem_copy, &ep, out);
        self.emit_br(&latch_lbl, out);

        self.start_block(&latch_lbl, out);
        let _ = writeln!(out, "  {fnext} = add nuw nsw i64 {fi}, 1");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {fnext}, {count_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&end_lbl, out);
        if owned_proto {
            self.emit_drop_value(elem_ty, raw_init, out);
        }
    }

    fn emit_elem_store(&mut self, elem_ty: &Type, val: &str, ptr: &str, out: &mut String) {
        if *elem_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = zext i1 {val} to i8");
            let _ = writeln!(out, "  store i8 {b}, ptr {ptr}, align 1");
        } else {
            let _ = writeln!(
                out,
                "  store {} {val}, ptr {ptr}, align {}",
                ir_type(elem_ty),
                ir_align(elem_ty)
            );
        }
    }

    fn emit_elem_load(&mut self, elem_ty: &Type, ptr: &str, out: &mut String) -> String {
        if *elem_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = load i8, ptr {ptr}, align 1");
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = trunc i8 {b} to i1");
            r
        } else {
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = load {}, ptr {ptr}, align {}",
                ir_type(elem_ty),
                ir_align(elem_ty)
            );
            r
        }
    }

    fn emit_repeat_count_check(
        &mut self,
        count_expr: &Expr,
        count_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(count_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array repeat count cannot be negative (`{c}`)"),
                    count_expr.span,
                ));
            }
            if c > MAX_ARRAY_LEN {
                return Err(Diagnostic::new(
                    format!("array repeat count `{c}` exceeds maximum supported size"),
                    count_expr.span,
                ));
            }
            return Ok(());
        }

        if let ExprKind::Call { name, args } = &count_expr.kind {
            if name == "len" && args.len() == 1 {
                return Ok(());
            }
        }

        self.used_neg_len_fail = true;
        let out_of_range = self.next_tmp();
        let _ = writeln!(
            out,
            "  {out_of_range} = icmp ugt i64 {count_val}, {MAX_ARRAY_LEN}"
        );
        let ok_lbl = self.fresh_label("repeat.ok");
        let bad_lbl = self.fresh_label("repeat.bad");
        self.emit_cond_br(&out_of_range, &bad_lbl, &ok_lbl, out);

        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_neg_len_fail(i64 {count_val})");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        if let ExprKind::Var(v) = &count_expr.kind {
            if !self.mutated_vars.contains(v) {
                self.scopes.last_mut().unwrap().bounded_vars.insert(v.clone());
            }
        }
        Ok(())
    }

    fn is_bounded_var(&self, name: &str) -> bool {
        self.scopes.iter().rev().any(|s| s.bounded_vars.contains(name))
    }

    fn emit_bounds_check_if_needed(
        &mut self,
        arr_expr: &Expr,
        idx_expr: &Expr,
        vec_val: &str,
        idx_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(idx_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array index cannot be negative (`{c}`)"),
                    idx_expr.span,
                ));
            }
            if let ExprKind::Var(name) = &arr_expr.kind {
                if let Some(&KnownLen::Const(len_c)) = self.lookup_known_len(name) {
                    if c >= len_c {
                        return Err(Diagnostic::new(
                            format!("array index `{c}` is out of bounds for length `{len_c}`"),
                            idx_expr.span,
                        ));
                    }
                    return Ok(());
                }
            }
        }

        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return Ok(());
        }

        self.used_bounds_fail = true;
        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {vec_val}, 0");
        let oob = self.next_tmp();
        let _ = writeln!(out, "  {oob} = icmp uge i64 {idx_val}, {len_val}");
        let ok_lbl = self.fresh_label("idx.ok");
        let fail_lbl = self.fresh_label("idx.oob");
        self.emit_cond_br(&oob, &fail_lbl, &ok_lbl, out);

        self.start_block(&fail_lbl, out);
        let _ = writeln!(
            out,
            "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len_val})"
        );
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        Ok(())
    }

    fn emit_raw_len_bounds_check(
        &mut self,
        arr_expr: &Expr,
        idx_expr: &Expr,
        len_val: &str,
        idx_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(idx_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array index cannot be negative (`{c}`)"),
                    idx_expr.span,
                ));
            }
            if let ExprKind::Var(name) = &arr_expr.kind {
                if let Some(&KnownLen::Const(len_c)) = self.lookup_known_len(name) {
                    if c >= len_c {
                        return Err(Diagnostic::new(
                            format!("array index `{c}` is out of bounds for length `{len_c}`"),
                            idx_expr.span,
                        ));
                    }
                    return Ok(());
                }
            }
        }
        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return Ok(());
        }
        self.used_bounds_fail = true;
        let oob = self.next_tmp();
        let _ = writeln!(out, "  {oob} = icmp uge i64 {idx_val}, {len_val}");
        let ok_lbl = self.fresh_label("idx.ok");
        let fail_lbl = self.fresh_label("idx.oob");
        self.emit_cond_br(&oob, &fail_lbl, &ok_lbl, out);
        self.start_block(&fail_lbl, out);
        let _ = writeln!(
            out,
            "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len_val})"
        );
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);
        Ok(())
    }

    fn can_elide_bounds_check(&self, arr_expr: &Expr, idx_expr: &Expr) -> bool {
        let ExprKind::Var(arr_name) = &arr_expr.kind else {
            return false;
        };
        let ExprKind::Var(idx_name) = &idx_expr.kind else {
            return false;
        };

        let known_len = self.lookup_known_len(arr_name);

        for bound in self.loop_bounds.iter().rev() {
            if bound.var != *idx_name {
                continue;
            }
            match (&bound.upper, known_len) {
                (UpperBound::LenOf(a), _) if a == arr_name => return true,
                (UpperBound::Const(n), Some(KnownLen::Const(m))) if *n <= *m => return true,
                (UpperBound::Var(v), Some(KnownLen::SameAsVar(w))) if v == w => return true,
                (UpperBound::LenOf(a), Some(KnownLen::SameAsArray(b))) if a == b => return true,
                _ => {}
            }
        }
        false
    }

    fn infer_known_array_len(&self, expr: &Expr) -> Option<KnownLen> {
        match &expr.kind {
            ExprKind::ArrayLit(elems) => Some(KnownLen::Const(elems.len() as i64)),
            ExprKind::ArrayRepeat { count, .. } => {
                if let Some(c) = eval_const_int(count) {
                    if c >= 0 {
                        return Some(KnownLen::Const(c));
                    }
                }
                match &count.kind {
                    ExprKind::Var(v) if !self.mutated_vars.contains(v) => {
                        Some(KnownLen::SameAsVar(v.clone()))
                    }
                    ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                        if let ExprKind::Var(arr) = &args[0].kind {
                            if !self.mutated_vars.contains(arr) {
                                return Some(KnownLen::SameAsArray(arr.clone()));
                            }
                        }
                        None
                    }
                    _ => None,
                }
            }
            _ => None,
        }
    }

    fn derive_for_bound(
        &self,
        iv: &str,
        start: &Expr,
        end: &Expr,
        body: &[Stmt],
    ) -> Option<InductionBound> {
        let start_const = eval_const_int(start)?;
        if start_const < 0 {
            return None;
        }
        if stmts_assign_var(body, iv) {
            return None;
        }

        if let Some(end_const) = eval_const_int(end) {
            return Some(InductionBound {
                var: iv.to_string(),
                upper: UpperBound::Const(end_const),
            });
        }

        match &end.kind {
            ExprKind::Var(v) if !stmts_assign_var(body, v) => Some(InductionBound {
                var: iv.to_string(),
                upper: UpperBound::Var(v.clone()),
            }),
            ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    if !stmts_mutate_array_len(body, arr_name) {
                        return Some(InductionBound {
                            var: iv.to_string(),
                            upper: UpperBound::LenOf(arr_name.clone()),
                        });
                    }
                }
                None
            }
            _ => None,
        }
    }

    fn collect_unchecked_for_arrays(&self, iv: &str, stmts: &[Stmt]) -> Vec<String> {
        let mut out = Vec::new();
        for s in stmts {
            self.scan_stmt_for_iv_arrays(iv, stmts, s, &mut out);
        }
        out
    }

    fn scan_stmt_for_iv_arrays(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        stmt: &Stmt,
        out: &mut Vec<String>,
    ) {
        match &stmt.kind {
            StmtKind::Let { value, .. } => self.scan_expr_for_iv_arrays(iv, loop_body, value, out),
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Index {
                        target: arr,
                        index: idx,
                    } => {
                        self.consider_iv_array(iv, loop_body, arr, idx, out);
                        self.scan_expr_for_iv_arrays(iv, loop_body, arr, out);
                        self.scan_expr_for_iv_arrays(iv, loop_body, idx, out);
                    }
                    AssignTarget::Field { target: base, .. } => {
                        if let ExprKind::Index {
                            target: arr,
                            index: idx,
                        } = &base.kind
                        {
                            self.consider_iv_array(iv, loop_body, arr, idx, out);
                        }
                        self.scan_expr_for_iv_arrays(iv, loop_body, base, out);
                    }
                    AssignTarget::Var(_) => {}
                }
                self.scan_expr_for_iv_arrays(iv, loop_body, value, out);
            }
            StmtKind::Expr(e) => self.scan_expr_for_iv_arrays(iv, loop_body, e, out),
            StmtKind::Return(Some(e)) => self.scan_expr_for_iv_arrays(iv, loop_body, e, out),
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, cond, out);
                for inner in then_body {
                    self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                }
                if let Some(eb) = else_body {
                    for inner in eb {
                        self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                    }
                }
            }
            StmtKind::Region { body } => {
                for inner in body {
                    self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                }
            }
            _ => {}
        }
    }

    fn scan_expr_for_iv_arrays(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        expr: &Expr,
        out: &mut Vec<String>,
    ) {
        match &expr.kind {
            ExprKind::Index { target, index } => {
                self.consider_iv_array(iv, loop_body, target, index, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, target, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, index, out);
            }
            ExprKind::Field { target, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, target, out);
            }
            ExprKind::Unary { expr: inner, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, inner, out);
            }
            ExprKind::Binary { lhs, rhs, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, lhs, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, rhs, out);
            }
            ExprKind::Call { args, .. } | ExprKind::ArrayLit(args) => {
                for a in args {
                    self.scan_expr_for_iv_arrays(iv, loop_body, a, out);
                }
            }
            ExprKind::ArrayRepeat { value, count } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, value, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, count, out);
            }
            ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) | ExprKind::Var(_) => {}
        }
    }

    fn consider_iv_array(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        arr_expr: &Expr,
        idx_expr: &Expr,
        out: &mut Vec<String>,
    ) {
        let ExprKind::Var(idx_name) = &idx_expr.kind else {
            return;
        };
        if idx_name != iv {
            return;
        }
        let ExprKind::Var(arr_name) = &arr_expr.kind else {
            return;
        };
        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return;
        }
        let Some(entry) = self.lookup_var(arr_name) else {
            return;
        };
        if !entry.ty.is_array() || stmts_mutate_array_len(loop_body, arr_name) {
            return;
        }
        if !out.contains(arr_name) {
            out.push(arr_name.clone());
        }
    }

    fn analyze_strided_while(&self, cond: &Expr, body: &[Stmt]) -> Option<StridedWhilePlan> {
        let ExprKind::Binary {
            op: BinOp::Lt,
            lhs,
            rhs,
        } = &cond.kind
        else {
            return None;
        };
        let ExprKind::Var(idx_name) = &lhs.kind else {
            return None;
        };
        if stmts_contain_loop(body) {
            return None;
        }
        let idx_entry = self.lookup_var(idx_name)?;
        if idx_entry.ty != Type::Int {
            return None;
        }
        let VarStorage::Slot(idx_slot) = &idx_entry.storage else {
            return None;
        };

        let (bound_kind, proven_upper) = match &rhs.kind {
            ExprKind::Var(bname) => {
                let b_entry = self.lookup_var(bname)?;
                if b_entry.ty != Type::Int || stmts_assign_var(body, bname) {
                    return None;
                }
                (WhileBoundKind::Var(bname.clone()), UpperBound::Var(bname.clone()))
            }
            ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                let ExprKind::Var(aname) = &args[0].kind else {
                    return None;
                };
                let a_entry = self.lookup_var(aname)?;
                if !a_entry.ty.is_array() || stmts_mutate_array_len(body, aname) {
                    return None;
                }
                (
                    WhileBoundKind::LenOf(aname.clone()),
                    UpperBound::LenOf(aname.clone()),
                )
            }
            _ => return None,
        };

        let mut stride: Option<StrideVal> = None;
        if !check_only_monotone_step(body, idx_name, body, &mut stride, self) {
            return None;
        }
        let stride = stride?;

        Some(StridedWhilePlan {
            idx_slot: idx_slot.clone(),
            bound: bound_kind,
            stride,
            proven_bound: InductionBound {
                var: idx_name.clone(),
                upper: proven_upper,
            },
        })
    }

    // ---------------- Scopes, RAII Drops & SSA Helpers -----------------------

    fn push_scope(&mut self) {
        self.scopes.push(Scope::default());
    }

    fn pop_scope_with_drops(&mut self, out: &mut String) {
        let scope = self.scopes.pop().expect("scope stack underflow");
        if !self.terminated {
            self.emit_drops_for_targets(&scope.owned_buffers, None, out);
        }
    }

    fn emit_drops_down_to(&mut self, target_depth: usize, skip_slot: Option<&str>, out: &mut String) {
        let mut all_targets = Vec::new();
        for scope in self.scopes[target_depth..].iter().rev() {
            for t in scope.owned_buffers.iter().rev() {
                all_targets.push(t.clone());
            }
        }
        self.emit_drops_for_targets(&all_targets, skip_slot, out);
    }

    fn emit_drops_for_targets(
        &mut self,
        targets: &[DropTarget],
        skip_slot: Option<&str>,
        out: &mut String,
    ) {
        for target in targets {
            match target {
                DropTarget::DataPtr(data_ptr) => {
                    self.used_free = true;
                    let _ = writeln!(out, "  call void @free(ptr {data_ptr})");
                }
                DropTarget::TypedSlot { ptr, ty } => {
                    if skip_slot == Some(ptr.as_str()) {
                        continue;
                    }
                    let val = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {val} = load {}, ptr {ptr}, align {}",
                        ir_type(ty),
                        ir_align(ty)
                    );
                    self.emit_drop_value(ty, &val, out);
                }
            }
        }
    }

    fn lookup_var(&self, name: &str) -> Option<&VarEntry> {
        for scope in self.scopes.iter().rev() {
            if let Some(entry) = scope.vars.get(name) {
                return Some(entry);
            }
        }
        None
    }

    fn lookup_known_len(&self, name: &str) -> Option<&KnownLen> {
        for scope in self.scopes.iter().rev() {
            if let Some(k) = scope.known_lens.get(name) {
                return Some(k);
            }
        }
        None
    }

    fn next_tmp(&mut self) -> String {
        let id = self.next_tmp;
        self.next_tmp += 1;
        format!("%t{id}")
    }

    fn next_slot(&mut self, hint: &str) -> String {
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

    fn fresh_label(&mut self, prefix: &str) -> String {
        let id = self.next_label;
        self.next_label += 1;
        format!("{prefix}.{id}")
    }

    fn start_block(&mut self, label: &str, out: &mut String) {
        let _ = writeln!(out, "{label}:");
        self.terminated = false;
    }

    fn emit_br(&mut self, target: &str, out: &mut String) {
        let _ = writeln!(out, "  br label %{target}");
        self.terminated = true;
    }

    fn emit_cond_br(&mut self, cond: &str, then_lbl: &str, else_lbl: &str, out: &mut String) {
        let _ = writeln!(
            out,
            "  br i1 {cond}, label %{then_lbl}, label %{else_lbl}"
        );
        self.terminated = true;
    }

    // ---------------- Runtime Helpers & Externs ------------------------------

    fn emit_runtime_helpers(&self, out: &mut String) {
        let needs_abort_io = self.used_bounds_fail
            || self.used_neg_len_fail
            || self.used_pop_empty_fail
            || self.used_oom_fail
            || self.used_div_zero_fail
            || self.used_region
            || self.used_str_concat
            || self.used_str_promote
            || self.used_str_clone;

        if self.used_region {
            out.push_str(
                r#"define private fastcc void @archx_region_release_from(ptr %first) nounwind {
entry:
  %empty = icmp eq ptr %first, null
  br i1 %empty, label %done, label %loop
loop:
  %cur = phi ptr [ %first, %entry ], [ %next, %loop ]
  %next = load ptr, ptr %cur, align 8
  call void @free(ptr %cur)
  %more = icmp ne ptr %next, null
  br i1 %more, label %loop, label %done
done:
  ret void
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned) noinline {
entry:
  %min_body = icmp slt i64 %aligned, 65536
  %body_sz = select i1 %min_body, i64 65536, i64 %aligned
  %ovf_chk = icmp sgt i64 %body_sz, 9223372036854775791
  br i1 %ovf_chk, label %oom, label %do_malloc
do_malloc:
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok
oom:
  call void @archx_oom_fail()
  unreachable
ok:
  store ptr null, ptr %blk, align 8
  %cap_ptr = getelementptr inbounds i8, ptr %blk, i64 8
  store i64 %body_sz, ptr %cap_ptr, align 8
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %old_tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %old_tail, null
  br i1 %has_tail, label %link_tail, label %link_head
link_tail:
  store ptr %blk, ptr %old_tail, align 8
  br label %finish
link_head:
  store ptr %blk, ptr %head_slot, align 8
  br label %finish
finish:
  store ptr %blk, ptr %tail_slot, align 8
  %data = getelementptr inbounds i8, ptr %blk, i64 16
  %new_cur = getelementptr inbounds i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds i8, ptr %data, i64 %body_sz
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  store ptr %new_cur, ptr %cur_slot, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %size) alwaysinline {
entry:
  %z = icmp sle i64 %size, 0
  %sz = select i1 %z, i64 16, i64 %size
  %too_big = icmp sgt i64 %sz, 9223372036854775776
  br i1 %too_big, label %oom, label %align_ok
oom:
  call void @archx_oom_fail()
  unreachable
align_ok:
  %a1 = add nuw nsw i64 %sz, 15
  %aligned = and i64 %a1, -16
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %cur = load ptr, ptr %cur_slot, align 8
  %end = load ptr, ptr %end_slot, align 8
  %cur_i = ptrtoint ptr %cur to i64
  %end_i = ptrtoint ptr %end to i64
  %rem = sub i64 %end_i, %cur_i
  %fits = icmp sge i64 %rem, %aligned
  br i1 %fits, label %fast, label %check_reuse
fast:
  %next = getelementptr inbounds i8, ptr %cur, i64 %aligned
  store ptr %next, ptr %cur_slot, align 8
  ret ptr %cur
check_reuse:
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %tail, null
  br i1 %has_tail, label %try_next_blk, label %try_head_blk
try_head_blk:
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %head = load ptr, ptr %head_slot, align 8
  br label %inspect_cand
try_next_blk:
  %tnext = load ptr, ptr %tail, align 8
  br label %inspect_cand
inspect_cand:
  %cand = phi ptr [ %head, %try_head_blk ], [ %tnext, %try_next_blk ]
  %has_cand = icmp ne ptr %cand, null
  br i1 %has_cand, label %check_cand_cap, label %slow
check_cand_cap:
  %ccap_ptr = getelementptr inbounds i8, ptr %cand, i64 8
  %ccap = load i64, ptr %ccap_ptr, align 8
  %cfits = icmp sge i64 %ccap, %aligned
  br i1 %cfits, label %reuse_cand, label %drop_stale_chain
reuse_cand:
  store ptr %cand, ptr %tail_slot, align 8
  %cdata = getelementptr inbounds i8, ptr %cand, i64 16
  %ccur = getelementptr inbounds i8, ptr %cdata, i64 %aligned
  %cend = getelementptr inbounds i8, ptr %cdata, i64 %ccap
  store ptr %ccur, ptr %cur_slot, align 8
  store ptr %cend, ptr %end_slot, align 8
  ret ptr %cdata
drop_stale_chain:
  br i1 %has_tail, label %unlink_from_tail, label %unlink_from_head
unlink_from_tail:
  store ptr null, ptr %tail, align 8
  br label %free_cand
unlink_from_head:
  %hs2 = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  store ptr null, ptr %hs2, align 8
  br label %free_cand
free_cand:
  call fastcc void @archx_region_release_from(ptr %cand)
  br label %slow
slow:
  %res = call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned)
  ret ptr %res
}

"#,
            );
        }

        if self.used_str_drop {
            out.push_str(
                r#"define private fastcc void @archx_str_drop(%ArchxStr %s) alwaysinline nounwind {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %done
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 1
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %do_free, label %done
do_free:
  %raw = and i64 %w1, -2
  %ptr = inttoptr i64 %raw to ptr
  call void @free(ptr %ptr)
  br label %done
done:
  ret void
}

"#,
            );
        }

        if self.used_str_clone || self.used_str_promote {
            out.push_str(
                r#"define private fastcc %ArchxStr @archx_str_clone(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %ret_same
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 1
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -2
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

"#,
            );
        }

        if self.used_str_promote {
            out.push_str(
                r#"define private fastcc %ArchxStr @archx_str_promote(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_reg, label %ret_same
chk_reg:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 3
  %is_reg = icmp eq i64 %tag, 2
  br i1 %is_reg, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -4
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

"#,
            );
        }

        if self.used_str_eq {
            out.push_str(
                r#"define private fastcc i1 @archx_str_eq(%ArchxStr %a, %ArchxStr %b) nounwind {
entry:
  %aw0 = extractvalue %ArchxStr %a, 0
  %bw0 = extractvalue %ArchxStr %b, 0
  %w0_eq = icmp eq i64 %aw0, %bw0
  br i1 %w0_eq, label %chk_len, label %ret_false
chk_len:
  %len = and i64 %aw0, 4294967295
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw1 = extractvalue %ArchxStr %b, 1
  %short = icmp ule i64 %len, 12
  br i1 %short, label %cmp_short, label %cmp_long
cmp_short:
  %eq_s = icmp eq i64 %aw1, %bw1
  ret i1 %eq_s
cmp_long:
  %ap_i = and i64 %aw1, -4
  %bp_i = and i64 %bw1, -4
  %same_ptr = icmp eq i64 %ap_i, %bp_i
  br i1 %same_ptr, label %ret_true, label %do_memcmp
do_memcmp:
  %ap = inttoptr i64 %ap_i to ptr
  %bp = inttoptr i64 %bp_i to ptr
  %ap4 = getelementptr inbounds i8, ptr %ap, i64 4
  %bp4 = getelementptr inbounds i8, ptr %bp, i64 4
  %rem = sub nuw nsw i64 %len, 4
  %mc = call i32 @memcmp(ptr nonnull %ap4, ptr nonnull %bp4, i64 %rem)
  %eq_m = icmp eq i32 %mc, 0
  ret i1 %eq_m
ret_true:
  ret i1 true
ret_false:
  ret i1 false
}

"#,
            );
        }

        if self.used_str_print {
            emit_cstr_global(out, "@.fmt.pstr.nl", "%.*s\n");
            emit_cstr_global(out, "@.fmt.pstr", "%.*s");
            out.push_str(
                r#"
define private fastcc void @archx_str_print(%ArchxStr %s, i1 %newline) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %prep_short, label %prep_long
prep_short:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %tmp4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %tmp4, align 4
  br label %emit
prep_long:
  %raw = and i64 %w1, -4
  %lptr = inttoptr i64 %raw to ptr
  br label %emit
emit:
  %data = phi ptr [ %tmp, %prep_short ], [ %lptr, %prep_long ]
  %pos = icmp ugt i64 %len, 0
  br i1 %pos, label %chk_nul, label %chk_nl
chk_nul:
  %nul = call ptr @memchr(ptr nonnull %data, i32 0, i64 %len)
  %has_nul = icmp ne ptr %nul, null
  br i1 %has_nul, label %byte_loop_pre, label %fast_printf
fast_printf:
  %len32 = trunc i64 %len to i32
  %fmt = select i1 %newline, ptr @.fmt.pstr.nl, ptr @.fmt.pstr
  %np = call i32 (ptr, ...) @printf(ptr %fmt, i32 %len32, ptr nonnull %data)
  ret void
byte_loop_pre:
  br label %byte_loop
byte_loop:
  %bi = phi i64 [ 0, %byte_loop_pre ], [ %bnext, %byte_loop ]
  %bp = getelementptr inbounds i8, ptr %data, i64 %bi
  %ch8 = load i8, ptr %bp, align 1
  %ch32 = zext i8 %ch8 to i32
  %pc = call i32 @putchar(i32 %ch32)
  %bnext = add nuw nsw i64 %bi, 1
  %bmore = icmp ult i64 %bnext, %len
  br i1 %bmore, label %byte_loop, label %chk_nl
chk_nl:
  br i1 %newline, label %do_nl, label %done
do_nl:
  %nc = call i32 @putchar(i32 10)
  br label %done
done:
  ret void
}

"#,
            );
        }

        if self.used_str_concat {
            out.push_str(
                r#"define private fastcc %ArchxStr @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr %reg) {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %out_sso = alloca [16 x i8], align 8
  %aw0 = extractvalue %ArchxStr %a, 0
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw0 = extractvalue %ArchxStr %b, 0
  %bw1 = extractvalue %ArchxStr %b, 1
  %alen = and i64 %aw0, 4294967295
  %blen = and i64 %bw0, 4294967295
  %az = icmp eq i64 %alen, 0
  br i1 %az, label %ret_b, label %chk_bz
ret_b:
  %b_in_reg = icmp ne ptr %reg, null
  br i1 %b_in_reg, label %ret_b_raw, label %ret_b_clone
ret_b_raw:
  %bw1_tag = and i64 %bw1, 1
  %b_owned = icmp ne i64 %bw1_tag, 0
  br i1 %b_owned, label %ret_b_clone, label %ret_b_direct
ret_b_direct:
  ret %ArchxStr %b
ret_b_clone:
  %bc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %b)
  ret %ArchxStr %bc
chk_bz:
  %bz = icmp eq i64 %blen, 0
  br i1 %bz, label %ret_a, label %calc_tot
ret_a:
  %a_in_reg = icmp ne ptr %reg, null
  br i1 %a_in_reg, label %ret_a_raw, label %ret_a_clone
ret_a_raw:
  %aw1_tag = and i64 %aw1, 1
  %a_owned = icmp ne i64 %aw1_tag, 0
  br i1 %a_owned, label %ret_a_clone, label %ret_a_direct
ret_a_direct:
  ret %ArchxStr %a
ret_a_clone:
  %ac = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %a)
  ret %ArchxStr %ac
calc_tot:
  %tot = add nuw nsw i64 %alen, %blen
  %too_big = icmp sgt i64 %tot, 2147483647
  br i1 %too_big, label %oom, label %mat_a
oom:
  call void @archx_oom_fail()
  unreachable
mat_a:
  %ashort = icmp ule i64 %alen, 12
  br i1 %ashort, label %mat_a_short, label %mat_a_long
mat_a_short:
  %ap4 = lshr i64 %aw0, 32
  %ap4_32 = trunc i64 %ap4 to i32
  store i32 %ap4_32, ptr %atmp, align 4
  %atmp4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %aw1, ptr %atmp4, align 4
  br label %mat_b
mat_a_long:
  %araw = and i64 %aw1, -4
  %alptr = inttoptr i64 %araw to ptr
  br label %mat_b
mat_b:
  %aptr = phi ptr [ %atmp, %mat_a_short ], [ %alptr, %mat_a_long ]
  %bshort = icmp ule i64 %blen, 12
  br i1 %bshort, label %mat_b_short, label %mat_b_long
mat_b_short:
  %bp4 = lshr i64 %bw0, 32
  %bp4_32 = trunc i64 %bp4 to i32
  store i32 %bp4_32, ptr %btmp, align 4
  %btmp4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %bw1, ptr %btmp4, align 4
  br label %build
mat_b_long:
  %braw = and i64 %bw1, -4
  %blptr = inttoptr i64 %braw to ptr
  br label %build
build:
  %bptr = phi ptr [ %btmp, %mat_b_short ], [ %blptr, %mat_b_long ]
  %fits_sso = icmp ule i64 %tot, 12
  br i1 %fits_sso, label %build_sso, label %build_long
build_sso:
  store i64 0, ptr %out_sso, align 8
  %out_sso8 = getelementptr inbounds i8, ptr %out_sso, i64 8
  store i64 0, ptr %out_sso8, align 8
  %tot32 = trunc i64 %tot to i32
  store i32 %tot32, ptr %out_sso, align 8
  %sso_dst_a = getelementptr inbounds i8, ptr %out_sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %sso_dst_b = getelementptr inbounds i8, ptr %sso_dst_a, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %rw0 = load i64, ptr %out_sso, align 8
  %rw1 = load i64, ptr %out_sso8, align 8
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 %rw1, 1
  ret %ArchxStr %rs1
"#,
            );
            if self.used_region {
                out.push_str(
                    r#"build_long:
  %use_reg = icmp ne ptr %reg, null
  br i1 %use_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %tot)
  %rp_i = ptrtoint ptr %rp to i64
  %rtagged = or i64 %rp_i, 2
  br label %copy_long
alloc_heap:
  %hp = call noalias align 16 ptr @malloc(i64 %tot)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap
tag_heap:
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or i64 %hp_i, 1
  br label %copy_long
copy_long:
  %dst = phi ptr [ %rp, %alloc_reg ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %alloc_reg ], [ %htagged, %tag_heap ]
"#,
                );
            } else {
                out.push_str(
                    r#"build_long:
  %hp = call noalias align 16 ptr @malloc(i64 %tot)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %copy_long
copy_long:
  %dst = phi ptr [ %hp, %build_long ]
  %hp_i = ptrtoint ptr %hp to i64
  %w1_out = or i64 %hp_i, 1
"#,
                );
            }
            out.push_str(
                r#"  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %dst_b = getelementptr inbounds i8, ptr %dst, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %tot, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}

"#,
            );
        }

        if self.used_bounds_fail {
            emit_cstr_global(
                out,
                "@.err.bounds",
                "archx runtime panic: index %lld out of bounds for length %lld\n",
            );
            out.push_str(
                r#"
define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.bounds, i64 %idx, i64 %len)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_neg_len_fail {
            emit_cstr_global(
                out,
                "@.err.neglen",
                "archx runtime panic: invalid array/step size (%lld)\n",
            );
            out.push_str(
                r#"
define private void @archx_neg_len_fail(i64 %n) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.neglen, i64 %n)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_pop_empty_fail {
            emit_cstr_global(
                out,
                "@.err.pop",
                "archx runtime panic: pop from an empty array\n",
            );
            out.push_str(
                r#"
define private void @archx_pop_empty_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.pop)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_div_zero_fail {
            emit_cstr_global(out, "@.err.divz", "archx runtime panic: division by zero\n");
            out.push_str(
                r#"
define private void @archx_div_zero_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.divz)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_oom_fail || self.used_region || self.used_str_concat || self.used_str_clone || self.used_str_promote {
            emit_cstr_global(out, "@.err.oom", "archx runtime panic: out of memory\n");
            out.push_str(
                r#"
define private void @archx_oom_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.oom)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        out.push_str("declare i32 @printf(ptr nocapture readonly, ...)\n");
        if self.used_malloc || self.used_region || self.used_str_clone || self.used_str_promote || self.used_str_concat {
            out.push_str("declare noalias ptr @malloc(i64) nounwind allocsize(0)\n");
        }
        if self.used_calloc {
            out.push_str("declare noalias ptr @calloc(i64, i64) nounwind allocsize(0, 1)\n");
        }
        if self.used_realloc {
            out.push_str("declare ptr @realloc(ptr, i64) nounwind allocsize(1)\n");
        }
        if self.used_free || self.used_region || self.used_str_drop {
            out.push_str("declare void @free(ptr) nounwind\n");
        }
        if self.used_memset {
            out.push_str(
                "declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg)\n",
            );
        }
        if self.used_memcpy || self.used_str_clone || self.used_str_promote || self.used_str_concat {
            out.push_str(
                "declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)\n",
            );
        }
        if self.used_smul_ovf {
            out.push_str("declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable\n");
        }
        if self.used_str_eq {
            out.push_str("declare i32 @memcmp(ptr nocapture, ptr nocapture, i64) nounwind readonly\n");
        }
        if self.used_str_print {
            out.push_str("declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly\n");
            out.push_str("declare i32 @putchar(i32)\n");
        }
        if needs_abort_io {
            out.push_str("declare void @exit(i32) cold noreturn nounwind\n");
        }
    }
}

// ============================================================================
// Pure static-analysis helpers
// ============================================================================

fn pack_sso_str_words(bytes: &[u8]) -> (i64, i64) {
    debug_assert!(bytes.len() <= 12);
    let mut buf = [0u8; 16];
    let len32 = (bytes.len() as u32).to_le_bytes();
    buf[0..4].copy_from_slice(&len32);
    buf[4..4 + bytes.len()].copy_from_slice(bytes);
    let w0 = i64::from_le_bytes(buf[0..8].try_into().unwrap());
    let w1 = i64::from_le_bytes(buf[8..16].try_into().unwrap());
    (w0, w1)
}

fn pack_long_str_w0(bytes: &[u8]) -> i64 {
    debug_assert!(bytes.len() > 12);
    let mut buf = [0u8; 8];
    let len32 = (bytes.len() as u32).to_le_bytes();
    buf[0..4].copy_from_slice(&len32);
    buf[4..8].copy_from_slice(&bytes[0..4]);
    i64::from_le_bytes(buf)
}

fn root_var_of_expr(expr: &Expr) -> Option<&str> {
    match &expr.kind {
        ExprKind::Var(name) => Some(name),
        ExprKind::Index { target, .. } | ExprKind::Field { target, .. } => root_var_of_expr(target),
        _ => None,
    }
}

fn var_escapes_soa(stmts: &[Stmt], var: &str) -> bool {
    for s in stmts {
        if stmt_escapes_soa(s, var) {
            return true;
        }
    }
    false
}

fn stmt_escapes_soa(stmt: &Stmt, var: &str) -> bool {
    match &stmt.kind {
        StmtKind::Let { value, .. } => expr_escapes_soa(value, var),
        StmtKind::Assign { target, value, .. } => {
            match target {
                AssignTarget::Var(n) if n == var => return true,
                AssignTarget::Index { target: t, index } => {
                    if !matches!(&t.kind, ExprKind::Var(n) if n == var) && expr_escapes_soa(t, var)
                    {
                        return true;
                    }
                    if expr_escapes_soa(index, var) {
                        return true;
                    }
                }
                AssignTarget::Field { target: t, .. } => {
                    if let ExprKind::Index {
                        target: arr,
                        index: idx,
                    } = &t.kind
                    {
                        if !matches!(&arr.kind, ExprKind::Var(n) if n == var)
                            && expr_escapes_soa(arr, var)
                        {
                            return true;
                        }
                        if expr_escapes_soa(idx, var) {
                            return true;
                        }
                    } else if expr_escapes_soa(t, var) {
                        return true;
                    }
                }
                _ => {}
            }
            expr_escapes_soa(value, var)
        }
        StmtKind::Expr(e) => expr_escapes_soa(e, var),
        StmtKind::Return(Some(e)) => expr_escapes_soa(e, var),
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => false,
        StmtKind::If {
            cond,
            then_body,
            else_body,
        } => {
            expr_escapes_soa(cond, var)
                || var_escapes_soa(then_body, var)
                || else_body.as_ref().map_or(false, |b| var_escapes_soa(b, var))
        }
        StmtKind::While { cond, body } => expr_escapes_soa(cond, var) || var_escapes_soa(body, var),
        StmtKind::For {
            start,
            end,
            step,
            body,
            ..
        } => {
            expr_escapes_soa(start, var)
                || expr_escapes_soa(end, var)
                || step.as_ref().map_or(false, |se| expr_escapes_soa(se, var))
                || var_escapes_soa(body, var)
        }
        StmtKind::ForEach { iter, body, .. } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var)) || var_escapes_soa(body, var)
        }
        StmtKind::Region { body } => var_escapes_soa(body, var),
    }
}

fn expr_escapes_soa(expr: &Expr, var: &str) -> bool {
    match &expr.kind {
        ExprKind::Var(n) => n == var,
        ExprKind::Index { target, index } => {
            let direct = matches!(&target.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(target, var)) || expr_escapes_soa(index, var)
        }
        ExprKind::Field { target, .. } => expr_escapes_soa(target, var),
        ExprKind::Call { name, args } => {
            if name == "len" && args.len() == 1 && matches!(&args[0].kind, ExprKind::Var(n) if n == var)
            {
                return false;
            }
            args.iter().any(|a| expr_escapes_soa(a, var))
        }
        ExprKind::Unary { expr: inner, .. } => expr_escapes_soa(inner, var),
        ExprKind::Binary { lhs, rhs, .. } => {
            expr_escapes_soa(lhs, var) || expr_escapes_soa(rhs, var)
        }
        ExprKind::ArrayLit(es) => es.iter().any(|e| expr_escapes_soa(e, var)),
        ExprKind::ArrayRepeat { value, count } => {
            expr_escapes_soa(value, var) || expr_escapes_soa(count, var)
        }
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) => false,
    }
}

fn check_only_monotone_step(
    stmts: &[Stmt],
    idx: &str,
    full_body: &[Stmt],
    stride_out: &mut Option<StrideVal>,
    cg: &Codegen,
) -> bool {
    for s in stmts {
        match &s.kind {
            StmtKind::Assign { target, op, value } => {
                if let AssignTarget::Var(name) = target {
                    if name == idx {
                        let add_rhs = match op {
                            Some(BinOp::Add) => Some(value),
                            None => match &value.kind {
                                ExprKind::Binary {
                                    op: BinOp::Add,
                                    lhs,
                                    rhs,
                                } => {
                                    if matches!(&lhs.kind, ExprKind::Var(v) if v == idx) {
                                        Some(rhs.as_ref())
                                    } else if matches!(&rhs.kind, ExprKind::Var(v) if v == idx) {
                                        Some(lhs.as_ref())
                                    } else {
                                        None
                                    }
                                }
                                _ => None,
                            },
                            _ => None,
                        };
                        let Some(step_expr) = add_rhs else {
                            return false;
                        };
                        let this_stride = if let Some(c) = eval_const_int(step_expr) {
                            if c <= 0 || c > MAX_ARRAY_LEN {
                                return false;
                            }
                            StrideVal::Const
                        } else if let ExprKind::Var(sname) = &step_expr.kind {
                            if sname == idx || stmts_assign_var(full_body, sname) {
                                return false;
                            }
                            let Some(s_entry) = cg.lookup_var(sname) else {
                                return false;
                            };
                            if s_entry.ty != Type::Int {
                                return false;
                            }
                            StrideVal::Var(sname.clone())
                        } else {
                            return false;
                        };

                        match stride_out {
                            None => *stride_out = Some(this_stride),
                            Some(prev) => match (&prev, &this_stride) {
                                (StrideVal::Const, StrideVal::Const) => {}
                                (StrideVal::Var(a), StrideVal::Var(b)) if a == b => {}
                                _ => return false,
                            },
                        }
                    }
                }
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                if !check_only_monotone_step(then_body, idx, full_body, stride_out, cg) {
                    return false;
                }
                if let Some(eb) = else_body {
                    if !check_only_monotone_step(eb, idx, full_body, stride_out, cg) {
                        return false;
                    }
                }
            }
            StmtKind::Region { body } => {
                if !check_only_monotone_step(body, idx, full_body, stride_out, cg) {
                    return false;
                }
            }
            StmtKind::While { .. } | StmtKind::For { .. } | StmtKind::ForEach { .. } => {
                return false;
            }
            _ => {}
        }
    }
    true
}

fn stmts_use_region(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::Region { .. } => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_use_region(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_use_region(b))
        }
        StmtKind::While { body, .. }
        | StmtKind::For { body, .. }
        | StmtKind::ForEach { body, .. } => stmts_use_region(body),
        _ => false,
    })
}

fn stmts_contain_loop(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::While { .. } | StmtKind::For { .. } | StmtKind::ForEach { .. } => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_contain_loop(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_contain_loop(b))
        }
        StmtKind::Region { body } => stmts_contain_loop(body),
        _ => false,
    })
}

fn collect_mutated_vars(stmts: &[Stmt]) -> HashSet<String> {
    let mut set = HashSet::new();
    walk_mutations(stmts, &mut set);
    set
}

fn collect_returned_vars(stmts: &[Stmt]) -> HashSet<String> {
    let mut set = HashSet::new();
    walk_returns(stmts, &mut set);
    set
}

fn walk_returns(stmts: &[Stmt], set: &mut HashSet<String>) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Return(Some(expr)) => {
                if let ExprKind::Var(name) = &expr.kind {
                    set.insert(name.clone());
                }
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                walk_returns(then_body, set);
                if let Some(eb) = else_body {
                    walk_returns(eb, set);
                }
            }
            StmtKind::While { body, .. }
            | StmtKind::For { body, .. }
            | StmtKind::ForEach { body, .. }
            | StmtKind::Region { body } => walk_returns(body, set),
            _ => {}
        }
    }
}

fn walk_mutations(stmts: &[Stmt], set: &mut HashSet<String>) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Var(name) => {
                        set.insert(name.clone());
                    }
                    AssignTarget::Field { target: base, .. } => {
                        if let ExprKind::Var(vname) = &base.kind {
                            set.insert(vname.clone());
                        }
                        walk_expr_mutations(base, set);
                    }
                    AssignTarget::Index { target: t, index } => {
                        walk_expr_mutations(t, set);
                        walk_expr_mutations(index, set);
                    }
                }
                walk_expr_mutations(value, set);
            }
            StmtKind::Let { value, .. } => walk_expr_mutations(value, set),
            StmtKind::Expr(e) => walk_expr_mutations(e, set),
            StmtKind::Return(Some(e)) => walk_expr_mutations(e, set),
            StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                walk_expr_mutations(cond, set);
                walk_mutations(then_body, set);
                if let Some(eb) = else_body {
                    walk_mutations(eb, set);
                }
            }
            StmtKind::While { cond, body } => {
                walk_expr_mutations(cond, set);
                walk_mutations(body, set);
            }
            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
            } => {
                set.insert(var.clone());
                walk_expr_mutations(start, set);
                walk_expr_mutations(end, set);
                if let Some(se) = step {
                    walk_expr_mutations(se, set);
                }
                walk_mutations(body, set);
            }
            StmtKind::ForEach { iter, body, .. } => {
                walk_expr_mutations(iter, set);
                walk_mutations(body, set);
            }
            StmtKind::Region { body } => walk_mutations(body, set),
        }
    }
}

fn walk_expr_mutations(expr: &Expr, set: &mut HashSet<String>) {
    match &expr.kind {
        ExprKind::Call { name, args } => {
            if (name == "push" || name == "pop") && !args.is_empty() {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    set.insert(arr_name.clone());
                }
            }
            for a in args {
                walk_expr_mutations(a, set);
            }
        }
        ExprKind::Unary { expr: inner, .. } | ExprKind::Field { target: inner, .. } => {
            walk_expr_mutations(inner, set)
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            walk_expr_mutations(lhs, set);
            walk_expr_mutations(rhs, set);
        }
        ExprKind::Index { target, index } => {
            walk_expr_mutations(target, set);
            walk_expr_mutations(index, set);
        }
        ExprKind::ArrayLit(elems) => {
            for e in elems {
                walk_expr_mutations(e, set);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            walk_expr_mutations(value, set);
            walk_expr_mutations(count, set);
        }
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) | ExprKind::Var(_) => {}
    }
}

fn stmts_assign_var(stmts: &[Stmt], name: &str) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::Assign {
            target: AssignTarget::Var(v),
            ..
        } => v == name,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_assign_var(then_body, name)
                || else_body.as_ref().map_or(false, |b| stmts_assign_var(b, name))
        }
        StmtKind::While { body, .. }
        | StmtKind::For { body, .. }
        | StmtKind::ForEach { body, .. }
        | StmtKind::Region { body } => stmts_assign_var(body, name),
        _ => false,
    })
}

fn stmts_mutate_array_len(stmts: &[Stmt], arr_name: &str) -> bool {
    let mut set = HashSet::new();
    walk_mutations(stmts, &mut set);
    set.contains(arr_name)
}

fn eval_const_int(expr: &Expr) -> Option<i64> {
    match &expr.kind {
        ExprKind::Int(v) => Some(*v),
        ExprKind::Unary {
            op: UnOp::Neg,
            expr: inner,
        } => eval_const_int(inner)?.checked_neg(),
        ExprKind::Binary { op, lhs, rhs } => {
            let a = eval_const_int(lhs)?;
            let b = eval_const_int(rhs)?;
            match op {
                BinOp::Add => a.checked_add(b),
                BinOp::Sub => a.checked_sub(b),
                BinOp::Mul => a.checked_mul(b),
                BinOp::Div if b != 0 => a.checked_div(b),
                BinOp::Mod if b != 0 => a.checked_rem(b),
                _ => None,
            }
        }
        _ => None,
    }
}

// ============================================================================
// LLVM IR formatting helpers
// ============================================================================

fn mangle(name: &str) -> String {
    format!("@archx_fn_{name}")
}

fn type_mangle_key(ty: &Type) -> String {
    match ty {
        Type::Int => "i".to_string(),
        Type::Bool => "b".to_string(),
        Type::Str => "s".to_string(),
        Type::Void => "v".to_string(),
        Type::Struct(name) => format!("S{}_{name}", name.len()),
        Type::Array(inner) => format!("A_{}", type_mangle_key(inner)),
    }
}

fn ir_type(ty: &Type) -> String {
    match ty {
        Type::Int => "i64".to_string(),
        Type::Bool => "i1".to_string(),
        Type::Str => "%ArchxStr".to_string(),
        Type::Array(_) => "%ArchxVec".to_string(),
        Type::Struct(name) => format!("%ArchxStruct_{name}"),
        Type::Void => "void".to_string(),
    }
}

fn ir_align(ty: &Type) -> u32 {
    match ty {
        Type::Bool => 1,
        Type::Int | Type::Str | Type::Array(_) | Type::Struct(_) => 8,
        Type::Void => 1,
    }
}

fn elem_mem_ir_type(ty: &Type) -> String {
    match ty {
        Type::Bool => "i8".to_string(),
        other => ir_type(other),
    }
}

fn ir_ret_type(ty: Option<&Type>) -> String {
    match ty {
        Some(t) => ir_type(t),
        None => "void".to_string(),
    }
}

fn emit_cstr_global(out: &mut String, name: &str, value: &str) {
    emit_cstr_global_aligned(out, name, value, 1);
}

fn emit_cstr_global_aligned(out: &mut String, name: &str, value: &str, align: u32) {
    let bytes = value.as_bytes();
    let len = bytes.len() + 1; // trailing NUL
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lexer::Lexer;
    use crate::parser::Parser;

    fn lower_src(src: &str) -> Result<String> {
        let toks = Lexer::new(src).tokenize()?;
        let prog = Parser::new(toks).parse_program()?;
        lower(&prog)
    }

    #[test]
    fn lowers_hello_world_to_llvm_ir() {
        let ir = lower_src("func main():\n    print(\"Hello, Archx!\")\n").unwrap();
        assert!(ir.contains("define i32 @main()"));
        assert!(ir.contains("Hello, Archx!"));
        assert!(ir.contains("call i32 (ptr, ...) @printf"));
    }

    #[test]
    fn lowers_recursion_and_arithmetic_with_fastcc() {
        let src = "\
func fib(n: int) -> int:
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

func main():
    print(fib(10))
";
        let ir = lower_src(src).unwrap();
        assert!(ir.contains("define internal fastcc i64 @archx_fn_fib(i64 %arg.n)"));
        assert!(ir.contains("icmp sle i64"));
        assert!(ir.contains("sub i64"));
        assert!(ir.contains("add i64"));
    }

    #[test]
    fn bounds_checks_elided_for_proven_range_and_sized_arrays() {
        let src = "\
func sum_slice(xs: [int]) -> int:
    let total = 0
    for i in 0..len(xs):
        total += xs[i]
    return total

func combine(n: int) -> int:
    let a = [1; n]
    let b = [0; n]
    for i in 0..n:
        b[i] = a[i] * 3
    return sum_slice(b)

func main():
    let lit = [10, 20, 30]
    print(lit[2] + combine(16))
";
        let ir = lower_src(src).unwrap();
        assert!(
            !ir.contains("@archx_bounds_fail"),
            "all array accesses in proven loops and literal constants must elide bounds checks:\n{ir}"
        );
    }

    #[test]
    fn bounds_check_emitted_for_unproven_dynamic_index() {
        let src = "\
func get_at(xs: [int], k: int) -> int:
    return xs[k]

func main():
    let xs = [1, 2, 3]
    print(get_at(xs, 1))
";
        let ir = lower_src(src).unwrap();
        assert!(ir.contains("@archx_bounds_fail"));
    }

    #[test]
    fn compile_time_rejects_constant_oob_and_negative_repeat() {
        let oob = lower_src("func main():\n    let xs = [1, 2]\n    print(xs[2])\n").unwrap_err();
        assert!(oob.message.contains("out of bounds"));

        let neg = lower_src("func main():\n    let xs = [0; -3]\n    print(len(xs))\n").unwrap_err();
        assert!(neg.message.contains("negative"));
    }

    #[test]
    fn sso_strings_and_soa_structs_lower_cleanly() {
        let src = "\
struct Body:
    x: int
    vx: int

func main():
    let s = \"hello\"
    let bodies = [Body(1, 2); 64]
    for i in 0..64:
        bodies[i].x += bodies[i].vx
    print(s)
    print(bodies[0].x)
";
        let ir = lower_src(src).unwrap();
        assert!(
            !ir.contains("@archx_str_clone"),
            "short SSO literal must not heap-allocate:\n{ir}"
        );
        assert!(
            !ir.contains("%ArchxVec"),
            "non-escaping [Body; 64] should lower to transparent SoA planes without %ArchxVec:\n{ir}"
        );
    }

    #[test]
    fn region_rejects_escape_to_outer_variable() {
        let src = "\
func main():
    let outer = [1, 2]
    region:
        let tmp = [3, 4]
        outer = tmp
    print(len(outer))
";
        let err = lower_src(src).unwrap_err();
        assert!(err.message.contains("region"));
    }
}

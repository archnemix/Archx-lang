//! Abstract syntax tree (AST) definitions for Archx types, declarations, statements, and expressions.

use crate::diag::Span;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Type {
    Int,
    Float,
    Bool,
    Str,
    Void,
    Any,
    Array(Box<Type>),
    Dict(Box<Type>, Box<Type>),
    Set(Box<Type>),
    Tuple(Vec<Type>),
    Optional(Box<Type>),
    Struct(String),
    Enum(String),
    GenericInst {
        name: String,
        args: Vec<Type>,
    },
}

impl Type {
    pub fn name(&self) -> String {
        match self {
            Type::Int => "int".to_string(),
            Type::Float => "float".to_string(),
            Type::Bool => "bool".to_string(),
            Type::Str => "str".to_string(),
            Type::Void => "None".to_string(),
            Type::Any => "any".to_string(),
            Type::Array(elem) => format!("list[{}]", elem.name()),
            Type::Dict(k, v) => format!("dict[{}, {}]", k.name(), v.name()),
            Type::Set(elem) => format!("set[{}]", elem.name()),
            Type::Tuple(elems) => format!(
                "tuple[{}]",
                elems.iter().map(|t| t.name()).collect::<Vec<_>>().join(", ")
            ),
            Type::Optional(inner) => format!("{} | None", inner.name()),
            Type::Struct(name) | Type::Enum(name) => name.clone(),
            Type::GenericInst { name, args } => format!(
                "{name}[{}]",
                args.iter().map(|t| t.name()).collect::<Vec<_>>().join(", ")
            ),
        }
    }

    pub fn is_array(&self) -> bool {
        matches!(self, Type::Array(_))
    }

    pub fn is_hashable_key(&self) -> bool {
        matches!(self, Type::Int | Type::Bool | Type::Str | Type::Any)
    }
}

#[derive(Debug, Clone)]
pub struct Program {
    /// The dialect this module declared, and how it was chosen. Later passes read this instead of
    /// inferring a contract from syntax.
    pub dialect: crate::dialect::DialectSpec,
    pub structs: Vec<StructDef>,
    pub enums: Vec<EnumDef>,
    pub funcs: Vec<Func>,
    /// Module-level `CONST: int = 3` bindings: compile-time constants readable from every
    /// function, compiled to SSA immediates with no global storage.
    pub consts: Vec<GlobalConst>,
}

/// One module-level binding. Only initializers that fold to a literal (or a literal container of
/// literals) are accepted, which keeps the value free of runtime storage and drops.
#[derive(Debug, Clone)]
pub struct GlobalConst {
    pub name: String,
    pub ty: Option<Type>,
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct EnumDef {
    pub name: String,
    pub variants: Vec<EnumVariant>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct EnumVariant {
    pub name: String,
    pub fields: Vec<Type>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct StructDef {
    pub name: String,
    pub type_params: Vec<String>,
    pub fields: Vec<Param>,
    pub methods: Vec<Func>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Func {
    pub name: String,
    pub type_params: Vec<String>,
    pub params: Vec<Param>,
    pub ret: Option<Type>,
    pub body: Vec<Stmt>,
    /// `global name` declarations: names in this list resolve to the module-level `consts`
    /// binding instead of a local variable.
    pub globals: Vec<String>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Param {
    pub name: String,
    pub ty: Type,
    /// `def f(a: int, b: int = 3)` — the default is applied at the call site when the argument is
    /// omitted, exactly like Python's.
    pub default: Option<Expr>,
}

#[derive(Debug, Clone)]
pub struct Stmt {
    pub kind: StmtKind,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum AssignTarget {
    Var(String),
    Index {
        target: Box<Expr>,
        index: Box<Expr>,
    },
    Field {
        target: Box<Expr>,
        field: String,
    },
}

#[derive(Debug, Clone)]
pub enum StmtKind {
    Let {
        name: String,
        ty: Option<Type>,
        value: Expr,
    },
    Assign {
        target: AssignTarget,
        op: Option<BinOp>,
        value: Expr,
    },
    Return(Option<Expr>),
    Expr(Expr),
    If {
        cond: Expr,
        then_body: Vec<Stmt>,
        else_body: Option<Vec<Stmt>>,
    },
    While {
        cond: Expr,
        body: Vec<Stmt>,
    },
    For {
        var: String,
        start: Expr,
        end: Expr,
        step: Option<Expr>,
        body: Vec<Stmt>,
        /// `for i in 0..n: ... else: ...` — runs only when the loop was not exited by `break`.
        else_body: Option<Vec<Stmt>>,
    },
    ForEach {
        var: String,
        iter: Expr,
        body: Vec<Stmt>,
        /// `for ...: ... else: ...` — runs only when the loop was not exited by `break`.
        else_body: Option<Vec<Stmt>>,
    },
    ForEnumerate {
        idx_var: String,
        elem_var: String,
        iter: Expr,
        start: Option<Expr>,
        body: Vec<Stmt>,
    },
    ForDictItems {
        key_var: String,
        val_var: String,
        dict: Expr,
        body: Vec<Stmt>,
    },
    ForZip {
        vars: Vec<String>,
        iters: Vec<Expr>,
        body: Vec<Stmt>,
    },
    ForTupleUnpack {
        vars: Vec<String>,
        iter: Expr,
        body: Vec<Stmt>,
    },
    TupleAssign {
        targets: Vec<String>,
        value: Expr,
    },
    Match {
        subject: Expr,
        cases: Vec<MatchCase>,
    },
    Region {
        body: Vec<Stmt>,
    },
    Assert {
        cond: Expr,
        msg: Option<Expr>,
    },
    /// `del x` — drop the value and forget the binding; a later use reports `undefined variable`
    /// the way Python raises `UnboundLocalError`.
    Del {
        name: String,
    },
    /// `global NAME` — resolve `NAME` against the module-level constants rather than a local.
    Global {
        names: Vec<String>,
    },
    Pass,
    Break,
    Continue,
    /// `for ...: ... else: ...` — the body runs when the loop finishes without `break`.
    ForElse {
        body: Vec<Stmt>,
        else_body: Vec<Stmt>,
    },
}

#[derive(Debug, Clone)]
pub struct MatchCase {
    pub pattern: Pattern,
    pub guard: Option<Expr>,
    pub body: Vec<Stmt>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum Pattern {
    Wildcard(Span),
    Bind(String, Span),
    Int(i64, Span),
    Float(f64, Span),
    Bool(bool, Span),
    Str(String, Span),
    NonePat(Span),
    Tuple(Vec<Pattern>, Span),
    Or(Vec<Pattern>, Span),
    EnumVariant {
        enum_name: String,
        variant: String,
        args: Vec<Pattern>,
        span: Span,
    },
}

impl Pattern {
    pub fn span(&self) -> Span {
        match self {
            Pattern::Wildcard(s)
            | Pattern::Bind(_, s)
            | Pattern::Int(_, s)
            | Pattern::Float(_, s)
            | Pattern::Bool(_, s)
            | Pattern::Str(_, s)
            | Pattern::NonePat(s)
            | Pattern::Tuple(_, s)
            | Pattern::Or(_, s)
            | Pattern::EnumVariant { span: s, .. } => *s,
        }
    }
}

#[derive(Debug, Clone)]
pub enum FStrPart {
    Lit(String),
    Expr(Expr),
    /// `{expr:spec}` — the format specification after the colon.
    Spec {
        expr: Expr,
        spec: String,
    },
}

#[derive(Debug, Clone)]
pub struct Expr {
    pub kind: ExprKind,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct CompClause {
    pub vars: Vec<String>,
    pub iter: Expr,
    pub conds: Vec<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum ExprKind {
    Int(i64),
    Float(f64),
    Bool(bool),
    NoneLit,
    Str(String),
    FString(Vec<FStrPart>),
    Var(String),
    ArrayLit(Vec<Expr>),
    ArrayRepeat {
        value: Box<Expr>,
        count: Box<Expr>,
    },
    DictLit(Vec<(Expr, Expr)>),
    SetLit(Vec<Expr>),
    TupleLit(Vec<Expr>),
    ListComp {
        elt: Box<Expr>,
        clauses: Vec<CompClause>,
    },
    DictComp {
        key: Box<Expr>,
        val: Box<Expr>,
        clauses: Vec<CompClause>,
    },
    SetComp {
        elt: Box<Expr>,
        clauses: Vec<CompClause>,
    },
    GenExpr {
        elt: Box<Expr>,
        clauses: Vec<CompClause>,
    },
    Lambda {
        params: Vec<Param>,
        body: Box<Expr>,
    },
    /// A chained comparison (`a < b < c`). Python evaluates each operand once and short-circuits.
    CompareChain(Vec<(Box<Expr>, BinOp)>),
    /// `"fmt" % args` — Python's printf-style formatting. Only a literal template is supported;
    /// the right-hand side is a single value or a tuple of values.
    PercentFormat {
        template: String,
        args: Box<Expr>,
    },
    Index {
        target: Box<Expr>,
        index: Box<Expr>,
    },
    Slice {
        target: Box<Expr>,
        start: Option<Box<Expr>>,
        stop: Option<Box<Expr>>,
        step: Option<Box<Expr>>,
    },
    Field {
        target: Box<Expr>,
        field: String,
    },
    MethodCall {
        target: Box<Expr>,
        method: String,
        args: Vec<Expr>,
    },
    MethodCallKw {
        target: Box<Expr>,
        method: String,
        pos_args: Vec<Expr>,
        kw_args: Vec<(String, Expr, Span)>,
    },
    Call {
        name: String,
        args: Vec<Expr>,
    },
    CallKw {
        name: String,
        pos_args: Vec<Expr>,
        kw_args: Vec<(String, Expr, Span)>,
    },
    CallGeneric {
        name: String,
        type_args: Vec<Type>,
        pos_args: Vec<Expr>,
        kw_args: Vec<(String, Expr, Span)>,
    },
    CallExpr {
        callee: Box<Expr>,
        args: Vec<Expr>,
    },
    IfExpr {
        then_expr: Box<Expr>,
        cond: Box<Expr>,
        else_expr: Box<Expr>,
    },
    Binary {
        op: BinOp,
        lhs: Box<Expr>,
        rhs: Box<Expr>,
    },
    Unary {
        op: UnOp,
        expr: Box<Expr>,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    FloorDiv,
    Mod,
    Pow,
    Eq,
    Ne,
    Lt,
    Gt,
    Le,
    Ge,
    In,
    NotIn,
    And,
    Or,
    BitAnd,
    BitOr,
    BitXor,
    Shl,
    Shr,
}

impl BinOp {
    pub fn symbol(&self) -> &'static str {
        match self {
            BinOp::Add => "+",
            BinOp::Sub => "-",
            BinOp::Mul => "*",
            BinOp::Div => "/",
            BinOp::FloorDiv => "//",
            BinOp::Mod => "%",
            BinOp::Pow => "**",
            BinOp::Eq => "==",
            BinOp::Ne => "!=",
            BinOp::Lt => "<",
            BinOp::Gt => ">",
            BinOp::Le => "<=",
            BinOp::Ge => ">=",
            BinOp::In => "in",
            BinOp::NotIn => "not in",
            BinOp::And => "and",
            BinOp::Or => "or",
            BinOp::BitAnd => "&",
            BinOp::BitOr => "|",
            BinOp::BitXor => "^",
            BinOp::Shl => "<<",
            BinOp::Shr => ">>",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnOp {
    Neg,
    Not,
    BitNot,
}

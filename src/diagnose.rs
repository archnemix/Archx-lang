//! Classification of diagnostic messages into stable error codes (AX-011).
//!
//! Archx raises diagnostics from ~460 sites across the frontend and the code generator. Attaching a
//! code at each of those sites would mean the taxonomy is re-decided at every `Err(...)`, and the
//! labels would drift as messages are reworded. Instead the *message* stays the authority on what
//! went wrong and this module owns the single mapping from a message to its code.
//!
//! That does not make the codes fragile. `tests/error_codes.rs` extracts every diagnostic literal in
//! `src/` and fails the build if any of them does not classify, so a new diagnostic cannot ship
//! without a code. The rules are ordered from most to least specific and are matched against the
//! message *template*, so a message with a computed part (`undefined variable `x``) still classifies.
//!
//! Why this shape rather than a variant per message: the message is already the precise, user-facing
//! description, and there are hundreds of them. What a code needs to be is *stable* and *documented*
//! — a small, closed set that tooling can switch on — and that is exactly what this table is.

use crate::error_codes::Code;

/// Ordered `(message fragment, code)` rules; the first fragment contained in the message wins.
///
/// Order matters and is deliberate: internal invariants come first (so a message that mentions a
/// "slot" is never misfiled as a type error), then lexing, then parsing, then name resolution, then
/// control flow, then collections, and only then the broad type/call rules — because almost every
/// message contains the word `expects`, which would match everything if it came first.
const RULES: &[(&str, &str)] = &[
    ("internal error", "E0901"),
    ("lacked a slot", "E0901"),
    ("slot missing", "E0901"),
    ("slot vanished", "E0901"),
    ("storage slot", "E0901"),
    ("module slot", "E0901"),
    ("scan slot", "E0901"),
    ("insert slot", "E0901"),
    ("remove slot", "E0901"),
    ("string literal", "E0201"),
    ("f-string", "E0204"),
    ("escape sequence", "E0204"),
    ("numeric literal", "E0202"),
    ("number literal", "E0202"),
    ("float literal", "E0202"),
    ("integer literal", "E0202"),
    ("unexpected character", "E0203"),
    ("unindent", "E0303"),
    ("indentation", "E0303"),
    ("nesting depth", "E0301"),
    ("format ends with a dangling", "E0204"),
    ("unsupported format spec", "E0204"),
    ("format has more conversions", "E0204"),
    ("unsupported `{}` conversion", "E0204"),
    ("single `}` is not allowed in", "E0204"),
    ("empty expression not allowed", "E0204"),
    ("single `{}` in", "E0204"),
    ("unterminated `{}` in", "E0204"),
    ("cannot be empty", "E0302"),
    ("unexpected token", "E0301"),
    ("expected a type", "E0301"),
    ("expected an expression", "E0301"),
    ("expected `case`", "E0301"),
    ("expected `:` after dictionary", "E0301"),
    ("unexpected `:` inside set", "E0301"),
    ("left-hand side of assignment", "E0301"),
    ("tuple unpacking targets", "E0301"),
    ("positional argument cannot follow", "E0301"),
    ("expected numeric literal after", "E0301"),
    ("expected a match pattern", "E0301"),
    ("must have at least one `case` arm", "E0301"),
    ("must take `self`", "E0301"),
    ("must name its first parameter", "E0301"),
    ("`self` in", "E0301"),
    ("must have at least one variant", "E0301"),
    ("must have at least one field", "E0301"),
    ("type parameter list", "E0301"),
    ("duplicate type parameter", "E0301"),
    ("payload field cannot", "E0301"),
    ("only supported on `for`", "E0301"),
    ("in f-string", "E0204"),
    ("requires at least one type argument", "E0301"),
    ("undefined variable", "E0501"),
    ("undefined function", "E0502"),
    ("unknown type", "E0503"),
    ("unknown enum", "E0503"),
    ("unknown struct", "E0503"),
    ("no `main` function found", "E0502"),
    ("does not match enum", "E0503"),
    ("has no field", "E0504"),
    ("has no method", "E0504"),
    ("has no variant", "E0504"),
    ("has no method `{}` (supported", "E0504"),
    ("type `{}` has no method", "E0504"),
    ("cannot access field", "E0504"),
    ("is not a generic class/struct", "E0503"),
    ("is not a generic function", "E0502"),
    ("is not defined (define", "E0503"),
    ("reserved name", "E0506"),
    ("builtin/type and cannot be redefined", "E0506"),
    ("defined more than once", "E0505"),
    ("defined twice", "E0505"),
    ("already defined in this scope", "E0505"),
    ("duplicate field", "E0505"),
    ("duplicate variant", "E0505"),
    ("duplicate parameter", "E0505"),
    ("conflicts with type", "E0505"),
    ("only allowed inside a loop", "E0701"),
    ("must return a value", "E0702"),
    ("must return an `int`", "E0702"),
    ("must return `int`", "E0702"),
    ("does not return a value", "E0702"),
    ("non-exhaustive", "E0703"),
    ("step cannot be zero", "E0704"),
    ("exceeds maximum range stride", "E0704"),
    ("start must be", "E0704"),
    ("end must be", "E0704"),
    ("step must be", "E0704"),
    ("cannot resize", "E0704"),
    ("cannot reassign", "E0704"),
    ("match on a `void`", "E0703"),
    ("cannot match", "E0703"),
    ("pattern", "E0703"),
    ("alternatives in an `|`", "E0703"),
    ("out of bounds", "E0601"),
    ("cannot be negative", "E0601"),
    ("out of range for tuple", "E0601"),
    ("empty tuple", "E0601"),
    ("heterogeneous tuple", "E0602"),
    ("repeat count", "E0602"),
    ("not supported for scalar element lists", "E0602"),
    ("is not hashable", "E0602"),
    ("not support `{}` elements", "E0602"),
    ("argument(s), found", "E0403"),
    ("arguments, found", "E0403"),
    ("takes exactly", "E0403"),
    ("takes at most", "E0403"),
    ("takes no positional", "E0403"),
    ("takes 0 arguments", "E0403"),
    ("takes 1 or 2 arguments", "E0403"),
    ("takes 2 `", "E0403"),
    ("takes exactly one argument", "E0403"),
    ("expects {} argument", "E0403"),
    ("expects 1 or 2 arguments", "E0403"),
    ("expects 2 arguments", "E0403"),
    ("expects at least", "E0403"),
    ("expects {} field", "E0403"),
    ("requires at least 1 argument", "E0403"),
    ("duplicate keyword argument", "E0403"),
    ("unexpected keyword argument", "E0403"),
    ("no parameter named", "E0403"),
    ("got multiple values", "E0403"),
    ("is missing a value for parameter", "E0403"),
    ("keyword arguments are supported", "E0403"),
    ("does not accept keyword arguments", "E0403"),
    ("has no method `{}` accepting keyword", "E0403"),
    ("cannot be called directly", "E0403"),
    ("expects a top-level function name", "E0403"),
    ("a `lambda` passed to", "E0403"),
    ("`key=` lambdas take exactly", "E0403"),
    ("`key=` must be a", "E0403"),
    ("operand", "E0401"),
    ("operators", "E0401"),
    ("operator", "E0401"),
    ("operands", "E0401"),
    ("cannot compare", "E0401"),
    ("type mismatch", "E0402"),
    ("expects", "E0402"),
    ("must be `", "E0402"),
    ("value must be", "E0402"),
    ("cannot convert", "E0402"),
    ("value must be `", "E0402"),
    ("element type", "E0402"),
    ("cannot index into", "E0602"),
    ("cannot slice", "E0602"),
    ("slice index", "E0402"),
    ("index must be", "E0402"),
    ("cannot unpack", "E0402"),
    ("unpacking type mismatch", "E0402"),
    ("comparison must produce", "E0401"),
    ("conditional expression branches", "E0402"),
    ("cannot box", "E0402"),
    ("cannot implicitly unbox", "E0402"),
    ("cannot assign", "E0402"),
    ("cannot store", "E0402"),
    ("cannot declare a variable", "E0402"),
    ("field expects", "E0402"),
    ("must produce a value", "E0402"),
    ("requires matching", "E0401"),
    ("requires numeric", "E0401"),
    ("requires a `", "E0401"),
    ("is not defined for sets", "E0401"),
    ("is not supported on dict value type", "E0401"),
    ("must return", "E0702"),
    ("requires `int` or `float` elements", "E0402"),
    ("does not match list element type", "E0404"),
    ("must have matching types", "E0403"),
    ("start value must match", "E0403"),
    ("borrowed parameter", "E0602"),
    ("must be called on a list variable", "E0602"),
    ("must be a list variable", "E0602"),
    ("requires a local list variable", "E0602"),
    ("uses local SoA layout", "E0602"),
    ("requires a list", "E0402"),
    ("requires lists or strings", "E0402"),
    ("expects a list of tuples", "E0402"),
    ("supplies {} iterable", "E0403"),
    ("supplies {} iterables", "E0403"),
    ("loop unpacks", "E0403"),
    ("passes 1 element", "E0403"),
    ("has infinite size", "E0404"),
    ("must be initialized with a literal", "E0402"),
    ("cannot have type", "E0404"),
    ("field cannot be", "E0404"),
    ("format", "E0402"),
    ("a comprehension element cannot be", "E0402"),
    ("cannot infer the element type", "E0402"),
    ("cannot delete undefined variable", "E0501"),
    ("must be bound to a name", "E0402"),
    ("only named closures", "E0402"),
    ("which is not a local variable", "E0402"),
    ("can only be called directly", "E0402"),
    ("exceeded the monomorphization budget", "E0402"),
    ("maximum nesting depth", "E0404"),
    ("`main` cannot take parameters", "E0402"),
    ("expects `int` or `float`", "E0402"),
    ("not support dynamic", "E0402"),
    ("has no supported method", "E0504"),
    ("does not format", "E0402"),
    ("unsupported compound assignment", "E0401"),
    ("isinstance` second argument must be a type name", "E0404"),
    ("single-argument `", "E0402"),
    ("are not hashable", "E0602"),
    ("`+=` on `str` requires", "E0401"),
    ("unsupported `%` conversion", "E0204"),
    ("`in` requires", "E0401"),
    ("type argument for", "E0404"),
    ("duplicate loop variable", "E0505"),
    ("only supported for scalar element lists", "E0602"),
    ("on a `void` expression", "E0703"),
    ("but the key record holds", "E0402"),
    ("cannot sort `", "E0602"),
    ("`reverse=` in", "E0403"),
    ("but this assignment stores", "E0402"),
    ("compound assignment is not supported on whole structs", "E0401"),
    ("field assignment requires", "E0301"),
    ("equality `==` / `!=`", "E0401"),
    ("types cannot be `void`", "E0404"),
];

/// The code for a diagnostic message.
///
/// A message that already begins with a code (`"E0101: unknown dialect …"`) keeps it: the dialect
/// layer owns its own codes and says so in the text, which is what `archx explain E0101` documents.
pub fn classify(message: &str) -> Option<Code> {
    if let Some(code) = message
        .split_once(':')
        .and_then(|(head, _)| Code::parse(head))
    {
        return Some(code);
    }
    RULES
        .iter()
        .find(|(fragment, _)| message.contains(fragment))
        .and_then(|(_, code)| Code::parse(code))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn representative_messages_get_their_area() {
        let cases = [
            ("undefined variable `xs`", Code::UndefinedVariable),
            ("`str` has no method `title`", Code::UnknownMember),
            (
                "operator `+` requires matching `int` or `float` operands, found `bool` and `int`",
                Code::OperatorTypeMismatch,
            ),
            ("`list.append()` takes exactly 1 argument", Code::BadCallArguments),
            ("unterminated string literal", Code::UnterminatedLiteral),
            ("`for` body cannot be empty", Code::EmptyBlock),
            ("non-exhaustive `match` on enum `Shape`", Code::NonExhaustiveMatch),
            ("`break` is only allowed inside a loop", Code::LoopControlOutsideLoop),
            ("array index `7` is out of bounds for length `3`", Code::IndexOutOfRange),
            (
                "internal error: inserted-into list `xs` lacked a slot",
                Code::InternalInvariant,
            ),
            ("E0100: this module does not declare its dialect", Code::MissingDirective),
            ("E0101: unknown dialect `python`", Code::MalformedDirective),
        ];
        for (message, expected) in cases {
            assert_eq!(classify(message), Some(expected), "{message}");
        }
    }

    #[test]
    fn rules_are_ordered_specific_before_general() {
        // "expects" alone would match both of these; the specific internal rule must win.
        assert_eq!(
            classify("internal error: mutated variable `x` lacked a slot"),
            Some(Code::InternalInvariant)
        );
        // The broadest type rule still has to agree with the narrow collection rule.
        assert_eq!(
            classify("cannot `append` onto borrowed parameter `xs`"),
            Some(Code::UnsupportedCollectionOp)
        );
    }

    #[test]
    fn every_rule_names_a_real_code() {
        for (fragment, code) in RULES {
            assert!(!fragment.is_empty(), "an empty fragment matches everything");
            assert!(
                Code::parse(code).is_some(),
                "{fragment} names unknown code {code}"
            );
        }
    }

    #[test]
    fn unclassified_messages_stay_unclassified() {
        // `None`, not a guess: the coverage test in `tests/error_codes.rs` is what guarantees this
        // never happens for a message the compiler can actually emit.
        assert_eq!(classify("some brand new message"), None);
    }
}

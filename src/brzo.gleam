//// An implementation of the regex algorithm described in the paper
//// 'Parsing with Derivatives'. It uses Brzozowski derivativation to
//// implement a simple, easily-understood form of regular
//// expressions.

import gleam/io
import gleam/string
import gleam/list

/// A recursive regular expression. 
pub type Exp {
  // The empty set, representing no more possible matching values.
  Null
  // An empty string (the "null language"), representing having
  // successfully consumed all values.
  Epsilon
  // Any given single character in our alphabet.
  Symbol(char: String)
  Union(left: Exp, right: Exp)
  Cat(left: Exp, right: Exp)
  Star(exp: Exp)
}

/// The nullability function, ẟ. "This function returns the null
/// language if its input language contains the null string, and the
/// empty set otherwise."
fn is_nullable(exp: Exp) -> Bool {
  case exp {
    Null -> False
    Epsilon -> True
    Symbol(_) -> False
    Union(left: left, right: right) -> is_nullable(left) || is_nullable(right)
    Cat(left: left, right: right) -> is_nullable(left) && is_nullable(right)
    Star(_) -> True
  }
}

/// Calculate the derivative of an expression *with respect to* a
/// String `chr`.
fn derive_c(chr: String, exp: Exp) -> Exp {
  case exp {
    Symbol(char: chr2) if chr == chr2 -> Epsilon
    Symbol(_) -> Null
    Epsilon -> Null
    Null -> Null
    Star(exp: exp) -> Cat(left: derive_c(chr, exp), right: Star(exp: exp))
    Cat(left: left, right: right) -> {
      let first = Cat(left: derive_c(chr, left), right: right)
      case is_nullable(left) {
        False -> first
        True -> Union(left: first, right: derive_c(chr, right))
      }
    }
    Union(left: left, right: right) ->
      Union(left: derive_c(chr, left), right: derive_c(chr, right))
  }
}

/// Recursively derive an expression with respect to a string of
/// symbols in our language.
pub fn derive(exp: Exp, str: String) -> Exp {
  string.to_graphemes(str)
  |> list.fold(exp, derive_c)
}

/// Use a Regular Expression to match against a given string.
pub fn is_match(exp: Exp, str: String) -> Bool {
  exp
  |> derive(str)
  |> is_nullable
}

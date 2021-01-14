import brzo as b
import gleam/should

const exp = b.Cat(
  left: b.Star(exp: b.Union(left: b.Symbol("f"), right: b.Symbol("a"))),
  right: b.Star(exp: b.Cat(left: b.Symbol("r"), right: b.Symbol("s"))),
)

pub fn empty_match_test() {
  b.is_match(exp, "")
  |> should.be_true()
}

pub fn no_match_test() {
  b.is_match(exp, "x")
  |> should.be_false()
}

pub fn union_test() {
  b.is_match(exp, "f")
  |> should.be_true()

  b.is_match(exp, "a")
  |> should.be_true()
}

pub fn star_test() {
  b.is_match(exp, "ff")
  |> should.be_true()

  b.is_match(exp, "aa")
  |> should.be_true()

  b.is_match(exp, "fa")
  |> should.be_true()

  b.is_match(exp, "af")
  |> should.be_true()

  b.is_match(exp, "afx")
  |> should.be_false()
}

import brzo
import gleam/should

const exp = brzo.Cat(
  left: brzo.Star(
    exp: brzo.Union(left: brzo.Symbol("f"), right: brzo.Symbol("a")),
  ),
  right: brzo.Star(
    exp: brzo.Cat(left: brzo.Symbol("r"), right: brzo.Symbol("s")),
  ),
)

pub fn empty_match_test() {
  brzo.is_match(exp, "")
  |> should.be_true()
}

pub fn no_match_test() {
  brzo.is_match(exp, "x")
  |> should.be_false()
}

pub fn union_test() {
  brzo.is_match(exp, "f")
  |> should.be_true()

  brzo.is_match(exp, "a")
  |> should.be_true()
}

pub fn star_test() {
  brzo.is_match(exp, "ff")
  |> should.be_true()

  brzo.is_match(exp, "aa")
  |> should.be_true()

  brzo.is_match(exp, "fa")
  |> should.be_true()

  brzo.is_match(exp, "af")
  |> should.be_true()

  brzo.is_match(exp, "afx")
  |> should.be_false()
}

pub fn cat_test() {
  brzo.is_match(exp, "rs")
  |> should.be_true()

  brzo.is_match(exp, "rsrs")
  |> should.be_true()

  brzo.is_match(exp, "rsr")
  |> should.be_false()

  brzo.is_match(exp, "ffaarsrsrs")
  |> should.be_true()
}

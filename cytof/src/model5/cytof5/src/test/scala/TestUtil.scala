import org.scalatest.FunSuite

class TestUtil extends FunSuite {
  test("cumsum") {
    import cytof5.Util.cumsum

    val x = Array(2.0, 3.0, 5.0)
    val expected = Array(2.0, 5.0, 10.0)
    val answer = cumsum(x)
    assert(expected.size == answer.size)
    answer.zip(expected).foreach{ case (e, a) => assert(e == a) }
  }

  test("new Data") {
    import cytof5.Data
    val y = Array.ofDim[Double](5,4)
    val d = new Data(y, Array(2,1,2))
    assert(d.idxOffset.size == 3)
    assert(d.idxOffset(0) == 0)
    assert(d.idxOffset(1) == 2)
    assert(d.idxOffset(2) == 3)
    assert(d.I == 3)
    assert(d.N == 5)
    assert(d.J == 4)
  }
}


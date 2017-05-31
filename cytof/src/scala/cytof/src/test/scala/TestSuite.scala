import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  test("Get dimensions of Data") {
    import cytof._
    val y = Array(Array(Array(4.0, 5, 6), Array(2.0, 3, 4)),
                  Array(Array(1.0, 2, 3)))
    assert(getI(y) == 2)
    assert(getJ(y) == 3)
    assert(getNi(y,0) == 2)
    assert(getNi(y,1) == 1)
  }
  

}

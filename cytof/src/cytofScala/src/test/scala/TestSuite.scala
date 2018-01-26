import org.scalatest.FunSuite
import cytof.util._
import scala.util.Random

class TestSuite extends FunSuite {
  test("matrix init") {
    val N = 50000
    val J = 32
    val M = 10
    val x = timer { breeze.linalg.DenseMatrix.fill(N,J)(Random.nextGaussian) }
    //println(x)
  }

  test("matrix mult") {
    val J = 32
    val M = 10
    val x = breeze.linalg.DenseMatrix.fill(J,M)(Random.nextGaussian)
    timer{ x.t * x }
  }

}

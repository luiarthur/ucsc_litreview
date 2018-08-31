import org.scalatest.FunSuite


class TestSuite extends FunSuite {
  val printDebug = false //true
  def arrayToString[T](a:Array[T]): String = s"Array(${a.mkString(",")})"

  test("Gibbs") {
    case class StateTest(var x:Int, var y:Double,
      a:Array[Int], aad:Array[Array[Double]]) {

      override def toString = s"StateTest(${x},${y},${arrayToString(a)},${aad})"
    }

    object GibbsTest extends cytof5.Gibbs {
      
      type State = StateTest

      def deepcopy(s:State) = s.copy(a=s.a.clone, aad=s.aad.map(_.clone))

      val updateFunctions = List(
        ("x", (state:State) => state.x += 1),
        ("a", (state:State) => state.a(0) -= 1),
        ("y", (state:State) => state.y *= 2)
      )

      def main() {
        val sa = StateTest(0, 2.0, Array(0), Array.ofDim[Double](2,3))
        val outA = gibbs(sa, nmcmc=5, showTimings=true)
        //val outA = Gibbs.gibbs(sa, nmcmc=5, updateFunctions=updateFunctions, showTimings=false)

        val sb = StateTest(0, 2.0, Array(0), Array.ofDim[Double](2,3))
        val outB = gibbs(sb, nmcmc=5, 
                         monitors=Vector(List("x", "a")), thins=Vector(1))

        val sc = StateTest(0, 1.0, Array(0), Array.ofDim[Double](0,0))
        val outC = gibbs(deepcopy(sc), nmcmc=10, 
                         monitors=Vector(List("x", "a"), List("y")), thins=Vector(1,1))

        val ocMonitorOneA = outC(0).map(_("a").asInstanceOf[Array[Int]])
        assert(ocMonitorOneA.head(0) == -10)
        assert(ocMonitorOneA.last(0) == -1)

        val ocMonitorTwoY = outC(1).map(_("y").asInstanceOf[Double])
        ocMonitorTwoY.indices.foreach{i => 
          assert(ocMonitorTwoY(i) == math.pow(2, 10-i))
        }
        //outC(1).foreach(println)
      }
    }

    GibbsTest.main
  }

  test("Clone X-d Array") {
    import cytof5.CloneXdArray._
    val x2d = Array.ofDim[Int](2,3)
    val x3d = Array.ofDim[Int](2,3,4)
    val x4d = Array.ofDim[Int](2,3,4,5)
    val x5d = Array.ofDim[Int](2,3,4,5,6)

    val y2d = clone2dInt(x2d)
    y2d(0)(0) += 1
    assert(y2d.head.head != x2d.head.head)

    val y3d = clone3dInt(x3d)
    y3d(0)(0)(0) += 1
    assert(y3d.head.head.head != x3d.head.head.head)

    val y4d = clone4dInt(x4d)
    y4d(0)(0)(0)(0) += 1
    assert(y4d.head.head.head.head != x4d.head.head.head.head)

    val y5d = clone5dInt(x5d)
    y5d(0)(0)(0)(0)(0) += 1
    assert(y5d.head.head.head.head.head != x5d.head.head.head.head.head)
  }
}

import org.scalatest.FunSuite


class TestExperimental extends FunSuite {
  val printDebug = false //true

  test("Gibbs") {
    import cytof5.experimental._
    object MCMC extends Gibbs

    def arrayToString[T](a:Array[T]): String = s"Array(${a.mkString(",")})"

    case class State(var x:Int, var y:Double,
                     a:Array[Int], aad:Array[Array[Double]]) extends MCMC.State {
      def deepcopy = this.copy(a=a.clone, aad=aad.map(_.clone))
      override def toString = s"State(${x},${y},${arrayToString(a)},${aad})"
    }

    val updateFunctions = List(
      ("x", (state:State) => state.x += 1),
      ("a", (state:State) => state.a(0) -= 1),
      ("y", (state:State) => state.y *= 2)
    )

    val sa = State(0, 2.0, Array(0), Array.ofDim[Double](2,3))
    val outA = MCMC.gibbs(sa, nmcmc=5, updateFunctions=updateFunctions, showTimings=true)
    //val outA = MCMC.gibbs(sa, nmcmc=5, updateFunctions=updateFunctions, showTimings=false)

    val sb = State(0, 2.0, Array(0), Array.ofDim[Double](2,3))
    val outB = MCMC.gibbs(sb, nmcmc=5, updateFunctions=updateFunctions,
                     monitors=Vector(List("x", "a")), thins=Vector(1))

    val sc = State(0, 1.0, Array(0), Array.ofDim[Double](0,0))
    val outC = MCMC.gibbs(sc.deepcopy, nmcmc=10, updateFunctions=updateFunctions,
                     monitors=Vector(List("x", "a"), List("y")), thins=Vector(1,1))

    if (printDebug) {
      println
      outC(0).foreach(o => println(arrayToString(o("a").asInstanceOf[Array[Int]])))
      outC(1).foreach(println)
    }
  }

  test("Clone X-d Array") {
    import cytof5.experimental.CloneXdArray._
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

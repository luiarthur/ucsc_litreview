import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  val printDebug = false

  test("Gibbs") {
    case class Param(var x: Int, val y: Array[Int])
    case class Sub2(var x: Int)

    object TestGibbs extends mcmc.Gibbs {
      type State = Param 
      def deepcopy(s:State) = s.copy(s.x+0, s.y.clone)

      type Substate2 = Sub2
      override def deepcopy2(s:State) = Some(Sub2(s.x+0))
      override val thin2 = 2

      def update(s:State) {
        s.x += 1
        s.y(0) -= 1
      }
    }


    val state = Param(0, Array(0))
    val (niter, nburn) = (10, 5)
    val out = TestGibbs.gibbs(state, niter=niter, nburn=nburn, printProgress=true)
    if (printDebug) println(out)
    assert(out._1.head.x == niter+nburn && out._1.last.x == 1 + nburn)
    assert(out._1.head.y(0) == -(niter+nburn) && out._1.last.y(0) == -(1 + nburn))

    out._2.last match {
      case Some(Sub2(x)) => assert(x == nburn + 1)
      case _ => assert(false)
    }

    out._2.head match {
      case Some(Sub2(x)) => 
        assert(x == nburn + (if (nburn % 2 == 0) niter else niter-1))
      case _ => assert(false)
    }

    assert(out._3 == List())
  }
}

import org.scalatest.FunSuite

class TestSuite extends FunSuite {
  val printDebug = false

  test("Gibbs with Substate2") {
    case class Param(var x: Int, val y: Array[Int]) 
    case class Sub1(var x: Int, val y:Array[Int])
    case class Sub2(var x: Int)

    object TestGibbs extends mcmc.Gibbs {
      type State = Param 
      
      type Substate1 = Sub1
      override def deepcopy1(s:State) = Some(Sub1(s.x+0, s.y.clone))

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

    assert(out._2.last.x == nburn + 1)
    assert(out._2.head.x == nburn + (if (nburn % 2 == 0) niter else niter-1))

    assert(out._3 == List())
  }
}

import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  test("wsample") {
    import ass1.util._
    val x = Vector(1.0,2.0,3.0,4.0,5.0)
    val p1 = Vector(.2, .4, .1, .2, .1)
    val p2 = Vector(2.0, 4.0, 1.0, 2.0, 1.0)
    val n = 100000
    val out1 = timer { Vector.fill(n)(wsample(x,p1)) }
    val out2 = timer { Vector.fill(n)(wsample(x,p2)) }
    val trueMean = x.zip(p1).map(z => z._1*z._2).sum 

    println(out1.sum / n, trueMean)
    println(out2.sum / n, trueMean)
    assert(math.abs(out1.sum/n - trueMean) < .1)
    assert(math.abs(out2.sum/n - trueMean) < .1)
  }

  test("sim data") {
    import ass1.util._
    import ass1.GenerateData.simOneObs
    val trueData = simOneObs(phiMean=0.0, phiVar=1.0, mu=0.3, 
                             c=30.0, minM=0, maxM=5, wM=.5, 
                             setV=Set(.3,.2,.6), S=10)
    println(trueData)
  }
}

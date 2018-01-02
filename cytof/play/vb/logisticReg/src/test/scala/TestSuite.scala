import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  def logdnorm(x:Double, mean:Double, sd:Double) = {
    val s2 = sd*sd
    -0.5 * math.log(2*math.Pi*s2) - math.pow(x-mean,2) / (2 * s2)
  }
  def rnorm(mean:Double, sd:Double) = {
    scala.util.Random.nextGaussian * sd + mean
  }
  def rbern(p:Double):Int = {
    require(p > 0 && p < 1)
    val u = scala.util.Random.nextDouble 
    if (p > u) 1 else 0
  }
  def logistic(x:Double) = 1 / (1 + math.exp(-x))
  def logit(p:Double) = {
    require(p > 0 && p < 1)
    math.log(p) - math.log(1-p)
  }

  def approx(x:Double, truth:Double, eps:Double=1E-3) =
    assert(math.abs(x - truth) < eps)

  test("Logistic Regression") {
    case class Hyper(b0Mean:Double, b0Sd:Double, b1Mean:Double, b1Sd:Double)
    case class State(b0:Double, b1:Double)
    val bTruth = State(2, 3)
    val n = 1000
    val x = List.tabulate(n)(i => rnorm(0,3))
    val y = x.map(xi => rbern(logistic(xi*bTruth.b1 + bTruth.b0)))
    val init = State(0,0)

    def ll(b0:Double, b1:Double):Double = {
      val p = x.map(xi => logistic(xi*b1 + b0))
      p.zip(y).map{py =>
        py._2 * math.log(py._1) + (1-py._2) * math.log(1-py._1)
      }.sum
    }
    def lp(b0:Double, b1:Double):Double = {
      logdnorm(b0, 0, 100) + logdnorm(b1, 0, 100)
    }
    def fc(b0:Double, b1:Double): Double = lp(b0,b1) + ll(b0,b1)

    //val out = VB.optim(init, update, elbo)
  }

  test("newton") {
    def f(x:Double) = x*x - 2*x + 1
    val out = VB.newton(10, 11, f, maxIter=1000, verbose=true, eps=1E-6)
    println(out)

    approx(out, 1)
  }
}

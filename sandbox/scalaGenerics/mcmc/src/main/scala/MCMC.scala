package mcmc

import org.apache.commons.math3.random.RandomDataGenerator

case class TuningParam[T](var value:T, var accCount:Int=0, var currIter:Int=1) {

  def update(accept:Boolean) {
    if (accept) { accCount += 1 }
    currIter += 1
  }

  def accRate:Double = accCount.toDouble / currIter
}

//case class TuningParam[Double](var value:Double) extends TuningParam(value)



/* Test
case class C(var value:Double) extends TuningParam(value)
val c = C(10)
*/


trait MCMC {
  import org.apache.commons.math3.linear.{
    Array2DRowRealMatrix, ArrayRealVector, CholeskyDecomposition
  }

  def rmvnorm(m:Array[Double], cov:Array[Array[Double]], rdg:RandomDataGenerator): Array[Double] = {
    val n = m.size
    val mVec = new Array2DRowRealMatrix(m)
    val z = new Array2DRowRealMatrix(Array.fill(n){ rdg.nextGaussian(0,1) })
    val covMat = new Array2DRowRealMatrix(cov)
    val A = (new CholeskyDecomposition(covMat)).getL
    A.multiply(z).add(mVec).getData.flatten
  }

  def metropolis(curr:Double, logFullCond: Double=>Double,
                 stepSig:Double, rdg:RandomDataGenerator): Double = {

    val cand = rdg.nextGaussian(curr, stepSig)
    val u = math.log(rdg.nextUniform(0,1))
    val p = logFullCond(cand) - logFullCond(curr)
    if (p > u) cand else curr
  }

  def metropolis_vec(curr:Array[Double], logFullCond:Array[Double]=>Double, stepCovMat:Array[Array[Double]], rdg:RandomDataGenerator): Array[Double] = {
    val cand = rmvnorm(curr, stepCovMat, rdg)
    val u = math.log(rdg.nextUniform(0,1))
    val p = logFullCond(cand) - logFullCond(curr)
    if (p > u) cand else curr
  }

  /* Adaptive metropolis (within Gibbs). See section 3 of the paper below:
   *   http://probability.ca/jeff/ftpdir/adaptex.pdf
   *
   * Another useful website:
   *   https://m-clark.github.io/docs/ld_mcmc/index_onepage.html
   */
  def metropolisAdaptive(curr:Double, logFullCond:Double=>Double, stepSig:TuningParam[Double], rdg:RandomDataGenerator, delta:Int=>Double=defaultDelta, targetAcc:Double=.44) = {

    val iter = stepSig.currIter
    val factor = math.exp(delta(iter))

    if (stepSig.accRate > targetAcc) {
      stepSig.value *= factor
    } else {
      stepSig.value /= factor
    }

    val cand = rdg.nextGaussian(curr, stepSig.value)
    val u = math.log(rdg.nextUniform(0,1))
    val p = logFullCond(cand) - logFullCond(curr)
    val accept = p > u

    stepSig.update(accept)

    if (accept) cand else curr
  }

  def defaultDelta(n:Int):Double = {
    List(math.pow(n.toDouble,-0.5), 0.01).min
  }

  def sech(x:Double):Double = 1 / math.cosh(x)

  def sigmoid(x:Double, a:Double=0, b:Double=1): Double = {
    (a, b) match {
      case (0, 1) => 1 / (1 + math.exp(-x))
      case _ => {
        val ex = math.exp(x)
        (b * ex + a) / (1 + ex)
      }
    }
  }

  def logit(p:Double, a:Double=0, b:Double=1): Double = {
    math.log(p - a) - math.log(b - p)
  }

  // TODO: Needs testing.
  def logpdfLogX2Param(logX:Double, logpdfX:(Double,Double,Double)=>Double, params:Double, a:Double, b:Double): Double = {
    logpdfX(math.exp(logX), a, b) + logX
  }

  def pdfLogistic(x:Double, loc:Double=0, scale:Double=1):Double = {
    (loc, scale) match {
      case (0, 1) => 0.25 * math.pow(sech(x / 2.0), 2.0)
      case _ => pdfLogistic((x - loc) / scale) / scale
    }
  }

  def logpdfLogistic(x:Double, loc:Double=0, scale:Double=1): Double = {
    (loc, scale) match {
      case (0, 1) => math.log(0.25) + 2.0 * math.log(sech(x / 2.0))
      case _ => logpdfLogistic((x - loc) / scale) - math.log(scale)
    }
  }
}

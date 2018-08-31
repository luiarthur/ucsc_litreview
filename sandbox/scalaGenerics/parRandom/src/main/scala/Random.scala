package parRandom

/* Notes:
 * What I am learning from this exercise is that you really only need a random uniform
 * to generate other random variables.
 * From a uniform, you can generate Normals using box-mueller,
 * then you can sample several other distributions.
 * The other critical distribution is the gamma, which from there, you can easily
 * sample some distributions.
 * For discrete distributions, Poisson presents most challenges. From Poisson
 * (and gamma), though, you can get negative binomial (and geometric).
 *
 * In conclusion, given that you have a random unit uniform sampler, implement these first:
 * - normal
 * - gamma
 * - poisson
 * The other distributions will transformations of (an assortment of) these and the uniform.
 *
 * Then, the two most important multivariate distributions are 
 *   - multivariate Normal
 *   - Dirichlet
 *
 * For discrete, you also need a (weighted) categorical sampler.
 *
 * See common distributions to implement here:
 * http://commons.apache.org/proper/commons-math/javadocs/api-3.6/org/apache/commons/math3/random/RandomDataGenerator.html
 */

trait RandomGeneric {
  import SpecialFunctions.logFactorial // for rpois
  import SpecialFunctions.{vvAdd, mvMult, choleskyL} // for rmvnorm
 
  val Rand: RandomFactory

  def round(x:Double, d:Int) = {
    require(d >= 0)
    val dMax = x.toString.split('.').last.size
    val factor = math.pow(10, if(d>dMax) dMax else d)
    (x * factor).toInt / factor
  }

  private def rU() = Rand.nextDouble

  // univairate continuous
  def runif(a: Double=0, b: Double=1) = {
    require(b > a)
    rU * (b-a) + a
  }

  /* Reference implementatoin using optional variance
  def rnorm(mean: Double=0, sd: Double=1, variance: Option[Double]=None) = {
    require(sd > 0)
    variance match {
      case Some(v) => Rand.nextGaussian * math.sqrt(v) + mean
      case _ => Rand.nextGaussian * sd + mean
    }
  }
  */

  def rnorm(mean: Double=0, sd: Double=1) = {
    require(sd > 0)
    Rand.nextGaussian * sd + mean
  }


  def rexp(rate: Double=1) = {
    require(rate > 0)
    -math.log(1 - rU) / rate
  }
  
  private def rgammaRateIsOneShapeGeOne(shape:Double): Double = {
    val d = shape - 1.0 / 3.0
    val c = 1.0 / math.sqrt(9*d)

    def engine(): Double = {
      val z = Rand.nextGaussian
      lazy val u = rU()
      lazy val v = math.pow(1 + c*z, 3)
      if (z > -1.0/c && math.log(u) < z*z/2.0 + d*(1-v+math.log(v))) {
        d * v
      } else engine()
    }

    engine()
  }

  def rgamma(shape:Double, rate:Double):Double = {
    require(shape > 0 && rate > 0)
    if (shape >= 1) {
      rgammaRateIsOneShapeGeOne(shape) / rate
    } else {
      rgamma(shape+1, rate) * math.pow(rU,1/shape)
    }
  }


  /** random draw from inverse gamma where 
   *  - expected value is b/(a-1)
   *  - variance is b^2/( (a-1)^2 * (a-2)), for a > 2
   */
  def rinvgamma(a:Double, b:Double):Double = {
    1 / rgamma(a, b)
  }

  def rbeta(a:Double, b:Double):Double = {
    require(a > 0 && b > 0)
    lazy val x = rgamma(a, 1)
    lazy val y = rgamma(b, 1)
    x / (x + y)
  }

  def rchisq(nu:Double):Double = {
    rgamma(nu/2, 0.5)
  }

  private def sdHatFast(x:List[Double], xbar:Double):Double = {
    val ss = x.map{xi => math.pow(xi - xbar, 2)}.sum
    math.sqrt(ss / (x.size - 1))
  }

  def rtdist(df:Double):Double = {
    lazy val z = Rand.nextGaussian
    lazy val v = rchisq(df)
    z * math.sqrt(df / v)
  }

  def rF(d1:Double, d2:Double) = {
    lazy val u1 = rchisq(d1)
    lazy val u2 = rchisq(d2)
    (u1 / d1) / (u2 / d2)
  }

  def rweibull(shape:Double, scale:Double):Double = {
    scale * math.pow(-math.log(rU), 1 / shape)
  }

  def rbern(p:Double):Int = {
    require(p >= 0 && p <= 1)
    if (p > Rand.nextDouble) 1 else 0
  }

  def rbinom(n:Int, p:Double):Int = {
    require(n >= 0 && p >= 0 && p <= 1)
    List.fill(n)(rbern(p)).sum
  }


  // Discrete univariate
  def rpoisKnuth(lam:Double):Int = {
    val L = math.exp(-lam)

    def engine(k:Int=0, p:Double=1): Int = {
      if (p > L) {
        engine(k+1, p*rU) 
      } else k-1
    }

    engine()
  }

  def rpoisAccRej(lam:Double):Int = {
    val c = 0.767 - 3.36/lam
    val beta = math.Pi / math.sqrt(3.0 * lam)
    val alpha = beta * lam
    val k = math.log(c) - lam - math.log(beta)
    def engine(): Int = {
      val u = rU()
      val x = (alpha - math.log(1/u - 1)) / beta
      val n = math.floor(x).toInt
      if (n < 0) engine() else {
        val v = rU()
        val y = alpha - beta * x
        val lhs = y + math.log(v) - 2 * math.log(1 + math.exp(y))
        val rhs = k + n * math.log(lam) - logFactorial(n)
        if (lhs <= rhs) n.toInt else engine()
      }
    }
    engine()
  }

  def rpois(lam:Double):Int = {
    //https://www.johndcook.com/blog/2010/06/14/generating-poisson-random-values/
    require(lam > 0)
    if (lam < 30) rpoisKnuth(lam) else rpoisAccRej(lam)
  }

  def rnegbinom(numSuccess:Double, probSuccess:Double):Int = {
    // numSuccess: target for number of successful trials (>0)
    // mean: numSuccess * (1-probSuccess) / probSuccess
    // samples: number of failures that occur before `r` successes are reached
    // TODO: Test using bernoulli trials!
    rpois(rgamma(shape=numSuccess, rate=probSuccess/(1-probSuccess)))
  }

  def rgeom(r:Int, p:Double):Int = {
    rnegbinom(1, p)
  }

  def wsampleIndex(prob:IndexedSeq[Double]): Int = {
    val pSum = prob.sum
    val u = rU() * pSum

    def engine(cumsum:Double=prob.head, p:IndexedSeq[Double]=prob.tail, i:Int = 0):Int = {
      if (cumsum < u) {
        engine(cumsum + p.head, p.tail, i+1)
      } else i
    }

    engine()
  }

  def wsampleIndexByLogProb(logProb:IndexedSeq[Double]): Int = {
    val logProbMax = logProb.max
    val prob = logProb.map(_ - logProbMax)
    wsampleIndex(prob)
  }

  // multivariate
  def rdir(a:IndexedSeq[Double]): IndexedSeq[Double] = {
    lazy val x = a.map{ai => rgamma(ai, 1)}
    lazy val xSum = x.sum
    x.map{_ / xSum}
  }

  /* Commons Math version. (1.75x speed slowdown from Personal Version1)
  import org.apache.commons.math3.linear.{
    Array2DRowRealMatrix, ArrayRealVector, CholeskyDecomposition
  }
  def rmvnorm(m:Array[Double], cov:Array[Array[Double]]): Array[Double] = {
    val n = m.size
    val mVec = new Array2DRowRealMatrix(m)
    val z = new Array2DRowRealMatrix(Array.fill(n){ Rand.nextGaussian })
    val covMat = new Array2DRowRealMatrix(cov)
    val A = (new CholeskyDecomposition(covMat)).getL
    A.multiply(z).add(mVec).getData.flatten
  }
  */
  
  // Personal Version 
  /* @param m: mean
   * @param cov: covariance matrix
   * @return sample from multivariate normal
   */
  def rmvnorm(m:Array[Double], cov:Array[Array[Double]]): Array[Double] = {
    /* Basic idea:
     *
     * LL' = covMat
     * z ~ N(0, I)
     * x = m + L*z
     */

    // Version1
    lazy val n = m.size
    lazy val z = Array.fill(n){Rand.nextGaussian}
    lazy val L = choleskyL(cov)
    vvAdd(m, mvMult(L, z))

    // Version2 (twice as slow as version 1)
    //Linalg.rmvnorm(m, cov)

    // Version3 (way slow)
    //val n = m.size
    //val L = choleskyL(cov)
    //Array.tabulate(n){ i => {
    //  def engine(j:Int=0, s:Double=0): Double = j match {
    //    case j if j == i + 1 => s
    //    case j => engine(j + 1, L(i)(j) * Rand.nextGaussian + s)
    //  }
    //  engine() + m(i) 
    //}}
  }
}

object Random extends RandomGeneric {
  val Rand = new _ThreadLocalRandom()
}

object _RandomTest extends RandomGeneric {
  val Rand = new _ScalaUtilRandom()
}

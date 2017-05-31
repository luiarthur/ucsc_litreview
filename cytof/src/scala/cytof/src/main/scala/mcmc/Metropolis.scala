package cytof.mcmc

object Metropolis {
  import math.{exp, log}
  import org.apache.commons.math3.special.Gamma.{gamma, logGamma}

  val Rand = new org.apache.commons.math3.random.RandomDataGenerator()
  def reSeed(s: Long) = Rand.reSeed(s)
  def rig(shp: Double, rate: Double) = 1.0 / Rand.nextGamma(shp, 1.0/rate)
  def rgamma(shp: Double, rate: Double) = Rand.nextGamma(shp, 1.0/rate)

  def wsample(x: Vector[Double], p: Vector[Double]) = {
    require(p.min>=0)
    require(p.length == x.length)
    val sump = p.sum
    val rescaledP = if (sump == 1) p else p.map(pi => pi / sump)
    val u = Rand.nextUniform(0,1)
    val cumP = rescaledP.scanLeft(0.0)(_+_).tail
    x.view.zip(cumP).dropWhile(_._2<u).head._1
  }


  private[Metropolis] trait GenericMetropolis {
    // To Implement:
    type State
    type Cov
    def rnorm(mu:State,sig:Cov): State

    // Pre-implemented:
    // curr:     current state
    // lfc:      the log full conditional
    // candSig:  step size in the random walk
    def update(curr:State, lfc: State=>Double, candSig:Cov): State = {
      val cand = rnorm(curr,candSig)
      val u = math.log(Rand.nextUniform(0,1))
      val p = lfc(cand) - lfc(curr)

      if (p > u) cand else curr
    }
  }

  object Univariate extends GenericMetropolis {
    type State = Double
    type Cov = Double
    def rnorm(x: State, sig:Cov) = {
      Rand.nextGaussian(x,sig)
    }
  }

  object Multivariate extends GenericMetropolis {
    import org.apache.commons.math3.linear._
    import org.apache.commons.math3.distribution.{
      MultivariateNormalDistribution => MvNormal
    }
    type State = Array[Double]
    type Cov = Array[Array[Double]]
    def rnorm(x: State, cov:Cov) = {
      new MvNormal(x, cov).sample
    }
  }

  /** Retruns the log density of log(X) given (a two-parameter) density of X*/
  def logDensityLogXTwoParam(lf:(Double,Double,Double) => Double) = { // GOOD
    (logx:Double, a:Double, b:Double) => lf(exp(logx), a, b) + logx
  }

  /** log (prior) distribution of Gamma parameter without normalizing constant*/
  def lpGamma(x:Double, shape:Double, rate:Double) = { // GOOD
    (shape - 1) * log(x) - rate * x
  }

  /** log (prior) distribution of Gamma parameter with normalizing constant*/
  def lpGammaWithConst(x:Double, shape:Double, rate:Double) = { // GOOD
    lpGamma(x, shape, rate) + shape * log(rate) - logGamma(shape)
  }

  /** log (prior) distribution of Inverse Gamma parameter 
   *  without normalizing constant*/
  def lpInvGamma(x:Double, a:Double, bNumer:Double) = { // GOOD
    -(a + 1) * log(x) - bNumer / x 
  }

  /** log (prior) distribution of Inverse Gamma parameter 
   *  with normalizing constant*/
  def lpInvGammaWithConst(x:Double, a:Double, bNumer:Double) = { // GOOD
    lpInvGamma(x,a,bNumer) + a * log(bNumer) - logGamma(a)
  }

  /** log (prior) distribution of log(X) where parameter X ~ Gamma(a,b) 
   *  without normalizing constant*/
  val lpLogGamma = logDensityLogXTwoParam(lpGamma) // GOOD
  /** log (prior) distribution of log(X) where parameter X ~ InverseGamma(a,b) 
   *  without normalizing constant*/
  val lpLogInvGamma = logDensityLogXTwoParam(lpInvGamma) // GOOD

  def invLogit(x:Double, a:Double=0.0, b:Double=1.0) = { // GOOD
    (b * exp(x) + a) / (1 + exp(x)) 
  }

  def logit(p:Double, a:Double=0.0, b:Double=1.0) = { // GOOD
    log((p-a) / (b-p))
  }

  /** log (prior) distribution of logit of U, where U ~ Unif(a,b) */
  def lpLogitUnif(logitU:Double) = { // GOOD
    logitU - 2 * log(1 + exp(logitU))
  }

  // for cytof
  def logpdfnorm(x:Double, m:Double, s:Double) = {
    val z = (x - m) / s
    -log(2*math.Pi)/2 - log(s) -z*z/2
  }

  def logpdfTnorm(x:Double,m:Double,s:Double,thresh:Double,lt:Boolean) = {
    import org.apache.commons.math3.distribution.NormalDistribution
    val ldnorm = logpdfnorm(x, m, s)
    val Phi = new NormalDistribution(m+thresh,s).cumulativeProbability(x)

    if (lt) {
      ldnorm - log(Phi)
    } else {
      ldnorm - log(1-Phi)
    }
  }

  def delta0(x:Double) = if (x==0) 1 else 0
  def Ind(x:Boolean) = if (x) 1 else 0
   
  def rdir(a:Array[Double]) = {
    val n = a.size
    val x = a.map(rgamma(_,1))
    val xsum = x.sum

    x.map(_ / xsum)
  }

  def rtnorm(m:Double, s:Double, lo:Double, hi:Double) = {

    def loop(draw:Double):Double = {
      if (lo < draw && draw < hi) draw else {
        loop(Rand.nextGaussian(m,s))
      }
    }

    loop(Rand.nextGaussian(m,s))
  }

}

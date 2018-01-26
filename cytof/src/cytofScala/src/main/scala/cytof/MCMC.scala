package cytof

object MCMC {
  import breeze.linalg.{DenseMatrix=>Mat, DenseVector=>Vec}
  import breeze.numerics.{lgamma, log, exp, pow, sqrt}
  import org.apache.commons.math3.special.Gamma.{gamma, logGamma}
  val Rand = new org.apache.commons.math3.random.RandomDataGenerator()

  def rgamma(shp: Double, rate: Double) = Rand.nextGamma(shp, 1.0/rate)
  def rig(shp: Double, rate: Double) = 1.0 / rgamma(shp, rate)

  def gibbs[T](state:T, update:T=>Unit, assign:(T,Int)=>Unit,
               iterations:Int, burn:Int, printEvery:Int=0) {
    if (printEvery > 0 && (iterations+burn) % printEvery == 0) 
      print("\rIterations Remaining: " + (iterations+burn) + "\t")

    update(state)

    if (burn > 0) {
      gibbs(state, update, assign, iterations, burn - 1, printEvery)
    } else if (iterations > 0) {
      gibbs(state, update, assign, iterations - 1, 0, printEvery)
      assign(state, iterations)
    }
  }

  def logit(p:Double, a:Double=0, b:Double=1):Double = log(p-a) - log(1-p)
  def logistic(x:Double, a:Double=0, b:Double=1) = { // inverse logit
    val u = exp(-x)
    (b + a * u) / (1 + u)
  }

  def metropolis(curr:Double,logLikePlusLogPrior:Double=>Double,cs:Double) = {
    val cand = scala.util.Random.nextGaussian * cs + curr
    val logu = math.log(scala.util.Random.nextDouble)
    val logp = logLikePlusLogPrior(cand) - logLikePlusLogPrior(curr)
    if (logp > logu) cand else curr
  }

  def metropolisMV(curr:Vec[Double], logLikePlusLogPrior:Vec[Double]=>Vec[Double],
                   S:Mat[Double]) {
    ???
  }

  // weighted sampling
  def wsample(x: Vector[Double], p: Vector[Double]) = {
    val u = scala.util.Random.nextDouble * p.sum
    def loop(i:Int=0, cumsum:Double=0.0): Double = {
      if (cumsum < u) loop(i+1, cumsum+p(i)) else x(i-1)
    }
    loop()
  }

  /** Retruns the log density of log(X) given (a two-parameter) density of X*/
  def logpdfLogXTwoParam(lf:(Double,Double,Double) => Double) = { // GOOD
    (logx:Double, a:Double, b:Double) => lf(exp(logx), a, b) + logx
  }

  /** log (prior) distribution of Gamma parameter without normalizing constant*/
  def lpGamma(x:Double, shape:Double, rate:Double) = { // GOOD
    (shape - 1) * log(x) - rate * x
  }

  /** log (prior) distribution of Gamma parameter with normalizing constant*/
  def lpGammaWithConst(x:Double, shape:Double, rate:Double) = { // GOOD
    lpGamma(x, shape, rate) + shape * log(rate) - lgamma(shape)
  }

  /** log (prior) distribution of Inverse Gamma parameter 
   *  without normalizing constant*/
  def lpInvGamma(x:Double, a:Double, bNumer:Double) = { // GOOD
    -(a + 1) * log(x) - bNumer / x 
  }

  /** log (prior) distribution of Inverse Gamma parameter 
   *  with normalizing constant*/
  def lpInvGammaWithConst(x:Double, a:Double, bNumer:Double) = { // GOOD
    lpInvGamma(x,a,bNumer) + a * log(bNumer) - lgamma(a)
  }

  /** log (prior) distribution of log(X) where parameter X ~ Gamma(a,b) 
   *  without normalizing constant*/
  val lpLogGamma = logpdfLogXTwoParam(lpGamma) // GOOD
  /** log (prior) distribution of log(X) where parameter X ~ InverseGamma(a,b) 
   *  without normalizing constant*/
  val lpLogInvGamma = logpdfLogXTwoParam(lpInvGamma) // GOOD

  def logpdfLogitsic(x:Double, m:Double=0, s:Double=1) = { // GOOD
    val z = (x - m) / s
    -z - 2 * log(1 + exp(-z))
  }

  def logpdfBeta(p:Double, a:Double, b:Double) = { // GOOD
    lgamma(a + b) - lgamma(a) - lgamma(b) + (a-1) * log(p) + (b-1) * log(1-p)
  }

  /** log (prior) distribution of logit of U, where U ~ Unif(a,b) */
  def lpLogitUnif(logitU:Double):Double = { // GOOD
    logpdfLogitsic(logitU)
  }

  def lpLogitBeta(logitU: Double, a:Double, b:Double):Double = {
    val u = logistic(logitU)
    logpdfBeta(u, a, b) + logpdfLogitsic(logitU)
  }


  // TODO: Copy the rest from the c++ implementation
  def rdir(a: Vec[Double]):Vec[Double] = {
    val n = a.size
    val x = Vec.tabulate(n){ i => rgamma(a(i), 1) }
    x / x.sum
  }
}


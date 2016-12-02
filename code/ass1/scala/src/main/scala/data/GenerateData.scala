package tumor.data

object GenerateData {
  import tumor.util._
  import tumor.data.{Obs,Param}

  // Ms: a reasonable range would be {0,1,2,3,4,5}
  private def simP(mu: Double, v: Double, M: Double) = {
    require(v>0 && v <1, "0 < v < 1 needs to be a proportion.")
    require(mu>0 && mu <1, "0 < mu < 1 needs to be a proportion.")
    mu * v * M / (2.0 *(1.0-mu) + mu*M)
  }

  private def simPhi(m: Double, phiVar: Double) = 
    Rand.nextGaussian(m,math.sqrt(phiVar))

  private def simM(min: Double, max: Double, w: Double):Double = {
    val discrete = { w > Rand.nextUniform(0,1) }
    if (discrete) {
      val out = Rand.nextInt(min.toInt,max.toInt).toDouble
      if (out == 0) simM(min,max,w) else out
    }
    else 
      Rand.nextUniform(min,max)
  }

  private def simLogN1OverN0(phi: Double, mu: Double, M: Double, s2:Double): Double = {
    val mean = math.log((2*(1-mu) + mu*M)/2) + phi
    Rand.nextGaussian(mean, math.sqrt(s2))
  }

  private def simN0(meanN0: Double): Int = {
    val out = Rand.nextPoisson(meanN0).toInt
    if (out > 0) out else simN0(meanN0)
  }

  private def simN1(N0:Double, logN1OverN0:Double): Int = {
    val out = (math.exp(logN1OverN0) * N0).toInt
    if (out == 0) 1 else out
  }

  private def simn1(N1: Int, p: Double) = {
    Rand.nextBinomial(N1,p)
  }

  private def simV(setV: Set[Double], n: Int): Vector[Double] = {
    setV.foreach{ uv => require(uv>0 && uv < 1) }
    val J = setV.size
    val uv = setV.toVector
    val out = Vector.fill(n)(uv(Rand.nextInt(0,J-1)))
    if (out.toSet == setV) out else simV(setV, n)
  }

  def genData(phiMean: Double, phiVar: Double, 
              mu: Double, sig2:Double,
              meanN0:Double=30, minM:Double=0, maxM: Double=5, 
              wM: Double=.5, 
              setV: Set[Double], numLoci:Int) = {
    val M = Vector.fill(numLoci)(simM(minM,maxM,wM))
    val phi = Vector.fill(numLoci)(simPhi(phiMean,phiVar))
    val N0 = Vector.fill(numLoci)(simN0(meanN0))
    val x = Vector.tabulate(numLoci)(s=>simLogN1OverN0(phi(s),mu,M(s),sig2))
    val N1 = Vector.tabulate(numLoci)(s=>simN1(N0(s),x(s)))
    val v = simV(setV,numLoci)
    val p = Vector.tabulate(numLoci)(s=>simP(mu,v(s),M(s)))
    val n1 = Vector.tabulate(numLoci)(s=>simn1(N1(s),p(s)))
    val obs = new Obs(n1, N1, N0, M)
    val param = new Param(mu, phi, v, sig2)

    (obs,param)
  }
}

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

  private def simPhi(m: Double, s2: Double) = Rand.nextGaussian(m,math.sqrt(s2))

  private def simM(min: Double, max: Double, w: Double) = {
    val discrete = { Rand.nextUniform(0,1) < w }
    if (discrete) 
      Rand.nextInt(min.toInt,max.toInt).toDouble
    else 
      Rand.nextUniform(min,max)
  }
  
  //FIXME: check this
  private def simN1(phi: Double, mu: Double, M: Double, c: Double): Int = {
    val out = Rand.nextPoisson( math.exp(phi) * c * (2*(1-mu) + mu*M) ).toInt
    if (out > 0) out else simN1(phi,mu,M,c)
  }

  //FIXME: check this
  private def simN0(c: Double): Int = {
    val out = Rand.nextPoisson(2*c).toInt
    if (out > 0) out else simN0(c)
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

  def genData(phiMean: Double, phiVar: Double, mu: Double, 
              c: Double=30, minM: Double=0, maxM: Double=5, wM: Double=.5, 
              setV: Set[Double], numLoci:Int) = {
    val M = Vector.fill(numLoci)(simM(minM,maxM,wM))
    val phi = Vector.fill(numLoci)(simPhi(phiMean,phiVar))
    val N0 = Vector.fill(numLoci)(simN0(c))
    val N1 = Vector.tabulate(numLoci)(s=>simN1(phi(s),mu,M(s),c))
    val v = simV(setV,numLoci)
    val p = Vector.tabulate(numLoci)(s=>simP(mu,v(s),M(s)))
    val n1 = Vector.tabulate(numLoci)(s=>simn1(N1(s),p(s)))
    val obs = new Obs(n1, N1, N0, M)
    val param = new Param(mu, phi, v)

    (obs,param)
  }
}
package ass1

object GenerateData {
  import ass1.util._
  import ass1.Data

  def rig(shp: Double, rate: Double) = 1.0 / Rand.nextGamma(shp, 1.0/rate)

  /* Ms: a reasonable range would be {0,1,2,3,4,5} */
  def p(mu: Double, v: Double, M: Double) = {
    assert(v>0 && v <1, "0 < v < 1 needs to be a proportion.")
    assert(mu>0 && mu <1, "0 < mu < 1 needs to be a proportion.")
    mu * v * M / (2.0 *(1.0-mu) + mu*M)
  }

  def simPhi(m: Double=0.0, s2: Double) = Rand.nextGaussian(m,math.sqrt(s2))
  //def simMu(a: Double, b: Double) = Rand.nextBeta(a,b)
  def simM(min: Double=0, max: Double=5, w: Double=0.5) = {
    val discrete = { Rand.nextUniform(0,1) < w }
    if (discrete) 
      Rand.nextInt(min.toInt,max.toInt)
    else 
      Rand.nextUniform(min,max)
  }
  def simN1(phi: Double, mu: Double, M: Double, c: Double=30): Int = { //FIXME: check this
    val out = Rand.nextPoisson( (math.exp(phi)*2*(1-mu) + mu*M) * c ).toInt
    if (out > 0) out else simN1(phi,mu,M,c)
  }
  def simN0(c: Double=30): Int = { //FIXME: check this
    val out = Rand.nextPoisson(2*c).toInt
    if (out > 0) out else simN0(c)
  }
  def simn1(N: Int, mu: Double, v: Double, M: Double) = {
    val p = mu * v * M / (2*(1-mu) + mu*M) 
    Rand.nextBinomial(N,p)
  }
  def simV(setV: Set[Double], n: Int): Vector[Double] = {
    setV.foreach{ uv => assert(uv>0 && uv < 0) }
    val J = setV.size
    val uv = setV.toVector
    val out = Vector.fill(n)(uv(Rand.nextInt(0,J-1)))
    if (out.toSet == setV) out else simV(setV, n)
  }

  def simOneObs(phiMean: Double, phiVar: Double, mu: Double, 
                c: Double=30, minM: Double=0, maxM: Double=5, wM: Double=.5, 
                S:Int) = {
    val M = Vector.fill(S)(simM(minM,maxM,w))
    //val N1 = Vector.fill(S)(simN1()) stopped here FIXME
  }
}

package ass1

object GenerateData {

  def rig(shp: Double, rate: Double) = 1.0 / ass1.util.Rand.nextGamma(shp, 1.0/rate)

  /* Ms: a reasonable range would be {0,1,2,3,4,5} */
  def p(mu: Double, vs: Double, Ms: Int) = {
    assert(vs>0 && vs <1, "0 < vs < 1 needs to be a proportion.")
    assert(mu>0 && mu <1, "0 < mu < 1 needs to be a proportion.")
    mu * vs * Ms / (2.0 *(1.0-mu) + mu*Ms)
  }

  def sim(mu: Double, sig2: Double, phi: Vector[Double], M: Vector[Int], v: Vector[Double]) = {
    //def sim1() 
  }
}

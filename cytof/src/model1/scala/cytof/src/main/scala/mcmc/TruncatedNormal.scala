package cytof.mcmc

object TruncatedNormal {
  import org.apache.commons.math3.distribution.NormalDistribution
  import math.{log, Pi}

  def logpdf(x:Double, m:Double, s:Double, a:Double, b:Double) = {
    val z = (x - m) / s
    val ldnorm = -(log(2*Pi *s*s) + z*z) / 2

    val Phi = new NormalDistribution(m,s)
    val phiB = Phi.cumulativeProbability(b)
    val phiA = Phi.cumulativeProbability(a)

    ldnorm - log(phiB - phiA)
  }

  //http://web.michaelchughes.com/research/sampling-from-truncated-normal
  def sample(m:Double, s:Double, a:Double, b:Double) = ???
  def sampleNearMean(m:Double, s:Double, a:Double, b:Double) = ???
  def sampleAwayMean(m:Double, s:Double, a:Double, b:Double) = ???

}

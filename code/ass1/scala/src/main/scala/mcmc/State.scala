package ass1.mcmc

import ass1.util._
import math.{pow,log,exp}

case class State(phi: Vector[Double], sig2: Double, mu: Double, v: Vector[Double]) {

  override def toString = {
    Console.CYAN+"True Parameters:\n" + Console.RESET +
    "mu:  " + mu + "\n" +
    "sig2:  " + sig2 + "\n" +
    "phi: " + phi.map(i => round(i)).mkString(", ") + "\n" + 
    "v:   " + v.map(i => round(i)).mkString(", ") + "\n"
  }

  /* Let:
   *   Y_s = N_{1s} / N_{0s}
   *   z_s = (2(1-mu) + mu*M_s) / 2
   *   w_s = Y_s / z_s = 2*N_{1s} / (N_{0s} * (2(1-mu) + mu*M_s))
   */
  def update(priors:Priors, data: ass1.data.Data) = {

    // speed of these functions?
    def p(mu: Double, vs: Double, Ms: Double) = mu*vs*Ms / (2.0*(1.0-mu) + mu*Ms) 
    def w(mu: Double, s:Int) =
      2.0 * data.N1(s) / ( data.N0(s) * (2.0*(1.0-mu) + mu*data.M(s)) )
    def ss(mu: Double, phi: Vector[Double]) = 
      data.idx.map(s => pow(log(w(mu,s)) - phi(s),2.0) ).sum


    // update sig2 (Gibbs step)
    val newSig2 = rig(priors.aSig + data.S/2.0, priors.bSig + ss(mu,phi)/2.0)


    // update phi (Gibbs step)
    val denom = newSig2 + priors.s2Phi
    val newPhi = data.idx.map{ s =>
      val mean = (log(w(mu,s)) * priors.s2Phi + priors.mPhi * newSig2) / denom
      val sd = math.sqrt(newSig2*priors.s2Phi / denom)
      Rand.nextGaussian(mu,sd)
    }


    // update mu ( Metropolis step)
    def invLogit(logitP: Double) = 1.0 / (1+exp(-logitP))
    def logit(p: Double) = {
      require(p>0 && p<1)
      log( p / (1-p) )
    }
    def logLikePluslogPriorLogitMu(logitMu: Double) = {
      val mu = invLogit(logitMu)
      val logJ = -logitMu + 2*log(mu)

      val logPriorLogitMu = 
        (priors.aMu-1.0) * log(mu) + (priors.bMu-1.0) * log(1-mu) + logJ

      val loglikeMu1 = -ss(mu, newPhi) / (2.0 * newSig2) 
      // speed?
      val loglikeMu2 = data.idx.map{ s =>
        val ps = p(mu,v(s),data.M(s))
        data.n1(s) * log(ps) + (data.N1(s)-data.n1(s)) * log(1-ps)
      }.sum
      loglikeMu1 + loglikeMu2 + logPriorLogitMu
    }
    val newMu = 
      invLogit(metropolis(logit(mu), logLikePluslogPriorLogitMu, priors.csMu))
    
    // update v
    val newv = { 
      def logf(t:Double, s:Int) = data.n1(s) * log(t) + (data.N1(s)-data.n1(s)) * log(p(newMu,t,data.M(s)))
      def logg0(t:Double) = (priors.aMu-1)*log(t) + (priors.bMu-1)*log(1-t)
      def rg0() = Rand.nextBeta(1,1)
      neal8Update(priors.alpha, v, logf, logg0, rg0, priors.csV)
    }

    ass1.mcmc.State(phi=newPhi, sig2=newSig2, v=newv, mu=newMu)
  }

}

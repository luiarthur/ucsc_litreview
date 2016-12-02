package tumor.mcmc

import tumor.util._
import tumor.data.Obs
import math.{pow,log,exp,sqrt}

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
  def update(prior:Prior, obs: Obs) = {

    def p(mu: Double, vs: Double, Ms: Double) = {
      mu*vs*Ms / (2.0*(1.0-mu) + mu*Ms) 
    }

    def w(mu: Double, s:Int) = {
      2.0*obs.N1(s) / (obs.N0(s) * (2.0*(1.0-mu) + mu*obs.M(s)))
    }

    def ss(mu: Double, phi: Vector[Double]) = {
      Vector.tabulate(obs.numLoci){ 
        s => pow(log(w(mu,s)) - phi(s),2.0) 
      }.sum
    }


    // update sig2 (Gibbs step)
    val newSig2 = 
      rig(prior.aSig+obs.numLoci/2.0, prior.bSig+ss(mu,phi)/2.0)


    // update phi (Gibbs step)
    val newPhi = {
      val denom = newSig2 + prior.s2Phi
      Vector.tabulate(obs.numLoci){ s =>
        val mean = (log(w(mu,s))*prior.s2Phi + prior.mPhi*newSig2) / denom
        val sd = sqrt(newSig2*prior.s2Phi / denom)
        Rand.nextGaussian(mean,sd)
      }
    }

    // update mu ( Metropolis step)
    val newMu = {
      def llMu(mu:Double) = {
        val loglikeMu1 = -ss(mu, newPhi) / (2.0 * newSig2) 
        val loglikeMu2 = Vector.tabulate(obs.numLoci){ s =>
          val ps = p(mu, v(s), obs.M(s))
          obs.n1(s)*log(ps) + (obs.N1(s)-obs.n1(s))*log(1-ps)
        }.sum
        loglikeMu1 + loglikeMu2
      }
      def lpMu(mu:Double) = 
          (prior.aMu-1.0)*log(mu) + (prior.bMu-1.0)*log(1-mu)

      metLogit(mu, llMu, lpMu, prior.csMu)
    }
    
    // update v
    val newv = { 
      def logf(v:Double, s:Int) = {
        val ps = p(newMu,v,obs.M(s))
        obs.n1(s)*log(ps) + (obs.N1(s)-obs.n1(s))*log(1-ps)
      }

      def rg0() = Rand.nextBeta(1,1)
      algo8(prior.alpha,v,logf,prior.lg0,rg0,
            metLogit,prior.csV,prior.clusterUpdates)
    }
    //val newv = v

    tumor.mcmc.State(phi=newPhi, sig2=newSig2, v=newv, mu=newMu)
  }

}

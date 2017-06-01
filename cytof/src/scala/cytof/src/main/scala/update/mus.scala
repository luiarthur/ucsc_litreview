package cytof.update

import cytof.mcmc._
import cytof._

object mus {
  import math.sqrt

  def lfc(mus_jk:Double, state:State, y:Data, prior:Prior, j:Int,k:Int) = {

    val ll = List.range(0,getI(y)).map{ i =>
      List.range(0,getNi(y,i)).map { n =>
        if (state.e(i)(n)(j) == 0 && state.lam(i)(n) == k) {
          val sigi = sqrt(state.sig2(i))
          Metropolis.logpdfTnorm(y(i)(n)(j), mus_jk, sigi, 0, lt=true)
        } else 0
      }.sum
    }.sum

    val tauj = sqrt(state.tau2(j))
    val psij = state.psi(j)
    val thresh = prior.musThresh

    val lp = if (mus_jk > thresh && state.z(j)(k) == 0) {
      Metropolis.logpdfTnorm(mus_jk, psij, tauj, thresh, lt=true)
    } else if (mus_jk < thresh && state.z(j)(k) == 1) {
      Metropolis.logpdfTnorm(mus_jk, psij, tauj, thresh, lt=false)
    } else Double.NegativeInfinity // shouldn't ever happen

    ll + lp
  }

  def update(state: State, y:Data, prior:Prior) = {

    for (j <- 0 until getJ(y); k <- 0 until state.K) {
      def logfc(mus_jk: Double) = {
        lfc(mus_jk, state, y, prior, j, k)
      }

      state.mus(j)(k) = Metropolis.Univariate.update(
        state.mus(j)(k), logfc, prior.csMu)
    }

  }

  def rmus(psi:Double, tau:Double, z:Int, thresh:Double) = {
    if (z==1) {
      Metropolis.rtnorm(psi, tau, thresh, Double.PositiveInfinity)
    } else {
      Metropolis.rtnorm(psi, tau, Double.NegativeInfinity, thresh)
    }
  }

}


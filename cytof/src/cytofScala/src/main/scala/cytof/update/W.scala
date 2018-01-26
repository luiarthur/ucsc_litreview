package cytof.update

import cytof.{State, Prior}
import cytof.util._ // Import Type Data
import breeze.linalg.{DenseVector=>Vec, DenseMatrix=>Mat}
import cytof.MCMC

object W {
  def update(state:State, y:Data, prior:Prior) {
    val I = getI(y)
    val N = getN(y)

    (0 until I).foreach{ i =>
      val dNew = Vec.fill(state.K)(1.0 / state.K) // TODO: CHANGE THIS!
      (0 until N(i)).foreach { n=>
        dNew( state.lam(i)(n) ) += 1
      }

      state.W(i, ::) := MCMC.rdir(dNew).t
    }
  }
}

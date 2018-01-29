package cytof.update

import cytof.{State, Prior}
import cytof.util._ // Import Type Data
import breeze.linalg.{DenseVector=>Vec, DenseMatrix=>Mat}
import cytof.MCMC


object Theta {
  def update(state:State, y:Data, prior:Prior) {
    W.update(state, y, prior)
  }
}

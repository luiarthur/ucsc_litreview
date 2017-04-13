package sbIBP

import breeze.linalg.{DenseVector, DenseMatrix}

/** Feature Allocatoin Model */
object FAM {

  case class State(
    sig2:Double,
    alpha:Double,
    v:Vector[Double],
    Z:DenseMatrix[Double]
  )

}

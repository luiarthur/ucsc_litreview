package cytof
import breeze.linalg.{DenseVector=>Vec, DenseMatrix=>Mat}

case class StateCompact(
  beta1: Vec[Double], beta0: Mat[Double], betaBar0: Vec[Double],
  gams0: Mat[Double], mus: Array[Mat[Double]], sig2: Vec[Double],
  psi: Vec[Double], tau2: Vec[Double],
  Z:Mat[Int], W: Mat[Double], lam: Array[Vec[Int]], impYsum:Array[Mat[Double]]
)

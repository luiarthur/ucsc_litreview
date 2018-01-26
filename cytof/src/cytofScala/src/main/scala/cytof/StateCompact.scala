package cytof
import breeze.linalg.{DenseVector=>Vec, DenseMatrix=>Mat}

case class StateCompact(
  beta1: Vec[Double], beta0: Mat[Double], betaBar0: Vec[Double],
  gams0: Mat[Double], mus: Vector[Mat[Double]], sig2: Vec[Double],
  psi: Vec[Double], tau2: Vec[Double],
  Z:Mat[Int], W: Mat[Double], lam: Vector[Vec[Int]], impYsum:Vector[Mat[Double]]
)

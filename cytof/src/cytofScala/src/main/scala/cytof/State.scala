package cytof
import breeze.linalg.{DenseVector=>Vec, DenseMatrix=>Mat}

case class State(
  beta1: Vec[Double], beta0: Mat[Double], betaBar0: Vec[Double],
  gams0: Mat[Double], mus: Vector[Mat[Double]], sig2: Vec[Double],
  psi: Vec[Double], tau2: Vec[Double],
  v: Vec[Double], H:Mat[Double], Z:Mat[Int], W: Mat[Double], lam: Vector[Vec[Int]],
  impY: Vector[Mat[Double]], var K:Int) {

  def deepCopy() = {
    State( 
      beta1=beta1.copy, beta0=beta0.copy, betaBar0=betaBar0.copy,
      gams0=gams0.copy, mus=mus.map(_.copy), sig2=sig2.copy,
      psi=psi.copy, tau2=tau2.copy, v=v.copy, H=H.copy, Z=Z.copy,
      W=W.copy, lam=lam.map(_.copy), impY=impY.map(_.copy), K=K)
  }

  def toCompact(impYsum:Vector[Mat[Double]]) = {
    StateCompact(
      beta1=beta1.copy, beta0=beta0.copy, betaBar0=betaBar0.copy,
      gams0=gams0.copy, mus=mus.map(_.copy), sig2=sig2.copy,
      psi=psi.copy, tau2=tau2.copy, Z=Z.copy, W=W.copy, lam=lam.map(_.copy),
      impYsum=Vector.tabulate(impYsum.size){i => impYsum(i) + impY(i)})
  }
}

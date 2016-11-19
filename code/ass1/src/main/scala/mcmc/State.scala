package ass1.mcmc

case class State(phi: Vector[Double], sig2: Double, mu: Double, v: Vector[Double]) {

  override def toString = {
    Console.CYAN+"True Parameters:\n" + Console.RESET +
    "mu:  " + mu + "\n" +
    "sig2:  " + sig2 + "\n" +
    "phi: " + phi.map(i => ass1.util.round(i)).mkString(", ") + "\n" + 
    "v:   " + v.map(i => ass1.util.round(i)).mkString(", ") + "\n"
  }

}

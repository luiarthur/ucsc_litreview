package ass1.data

case class Param(mu: Double, phi: Vector[Double], v: Vector[Double]) {
  override def toString = {
    Console.CYAN+"True Parameters:\n" + Console.RESET +
    "mu:  " + mu + "\n" +
    "phi: " + phi.map(i => ass1.util.round(i)).mkString(", ") + "\n" + 
    "v:   " + v.map(i => ass1.util.round(i)).mkString(", ") + "\n"
  }
}

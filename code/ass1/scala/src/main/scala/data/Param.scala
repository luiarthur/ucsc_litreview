package tumor.data

import tumor.util.round

class Param(val mu: Double, val phi: Vector[Double], val v: Vector[Double]) {
  override def toString = {
    Console.CYAN+"True Parameters:\n" + Console.RESET +
    "mu:  " + mu + "\n" +
    "phi: " + phi.map(i => round(i)).mkString(", ") + "\n" + 
    "v:   " + v.map(i => round(i)).mkString(", ") + "\n"
  }
}

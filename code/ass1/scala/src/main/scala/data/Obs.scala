package tumor.data

import tumor.util.round

class Obs(val n1:Vector[Int], 
          val N1:Vector[Int], val N0:Vector[Int], 
          val M:Vector[Double]) {

  val numLoci = M.length
  val idx = Vector.range(0,numLoci)

  override def toString = {
    Console.CYAN+"Observed Data:\n" + Console.RESET +
    "n1:  " + n1.mkString(", ") + "\n" + 
    "N1:  " + N1.mkString(", ") + "\n" + 
    "N0:  " + N0.mkString(", ") + "\n" + 
    "M:   " + M.map(i => round(i)).mkString(", ") + "\n" +
    "S:   " + numLoci 
  }
}

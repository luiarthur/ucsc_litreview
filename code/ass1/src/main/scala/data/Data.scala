package ass1.data

case class Data(n1:Vector[Int], N1:Vector[Int], N0:Vector[Int], M:Vector[Double]) {
  override def toString = {
    Console.CYAN+"Observed Data:\n" + Console.RESET +
    "n1:  " + n1.mkString(", ") + "\n" + 
    "N1:  " + N1.mkString(", ") + "\n" + 
    "N0:  " + N0.mkString(", ") + "\n" + 
    "M:   " + M.map(i => ass1.util.round(i)).mkString(", ") + "\n"
  }
}

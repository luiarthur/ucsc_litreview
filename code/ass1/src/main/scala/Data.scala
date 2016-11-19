package ass1

case class Data(n1:Vector[Int], N1:Vector[Int], N0:Vector[Int], M:Vector[Double]) {
  override def toString = {
    "n1:  " + n1.mkString(", ") + "\n" + 
    "N1:  " + N1.mkString(", ") + "\n" + 
    "N0:  " + N0.mkString(", ") + "\n" + 
    "M:   " + M.map(i => ass1.util.round(i)).mkString(", ") + "\n"
  }
}

case class Param(mu: Double, phi: Vector[Double], v: Vector[Double]) {
  override def toString = {
    "mu:  " + mu + "\n" +
    "phi: " + phi.map(i => ass1.util.round(i)).mkString(", ") + "\n" + 
    "v:   " + v.map(i => ass1.util.round(i)).mkString(", ") + "\n"
  }
}

case class TrueData(data: Data, param: Param) {
  override def toString = {
    data.toString + "\n" + param.toString
  }
}

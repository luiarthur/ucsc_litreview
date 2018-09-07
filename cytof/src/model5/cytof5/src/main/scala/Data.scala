package cytof5

class Data(val y:Array[Array[Double]], val n:Array[Int]) {
  val I = n.size
  val J = y.head.size
  val N = n.sum
  val idxOffset = n.toVector.scanLeft(0)(_+_).dropRight(1)

  // Assertions
  require(y.size == n.sum, "In Data(y,n): y.size == n.sum required!")
  y.foreach{ row => 
    require(row.size == J, "In Data(y,n): rows in y required to have same size!")
  }
}


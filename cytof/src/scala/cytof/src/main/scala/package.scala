package object cytof {
  /** times the execution of a block and returns what the block returns*/
  def timer[R](block: => R): R = {  
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
    result
  }

  // Data: y_inj is I x N_i x J
  type Data = Array[Array[Array[Double]]]
  def getI(y:Data) = y.size
  def getJ(y:Data) = y.head.head.size
  def getNi(y:Data, i:Int) = y(i).size
}

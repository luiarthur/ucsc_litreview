package cytof5

object Util {
  def timer[R](block: => R):R = {
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
    result
  }

  def cumsum(x: Array[Double]): Array[Double] = {
    x.scanLeft(0.0)(_+_).tail
  }
}

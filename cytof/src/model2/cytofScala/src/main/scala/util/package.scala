package cytof

package object util {
  /* Writing generic mean function: 
   * https://stackoverflow.com/questions/6188990/writing-a-generic-mean-function-in-scala
  */
  import Numeric.Implicits._ // mean, std

  def timer[R](block: => R) = {
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
    result
  }

  def mean[T](xs: Iterable[T])(implicit num: Numeric[T]):Double = {
    xs.sum.toDouble / xs.size
  }

  def std[T](xs: Iterable[T])(implicit num: Numeric[T]):Double = {
    val xbar = mean(xs)
    val n = xs.size
    lazy val v = xs.map{ xi => math.pow(xi.toDouble-xbar,2) / (n-1) }.sum
    math.sqrt(v)
  }
}



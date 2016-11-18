package ass1

package object util {
  val Rand = new org.apache.commons.math3.random.RandomDataGenerator()
  def reSeed(s: Long) = Rand.reSeed(s)

  def timer[R](block: => R) = {
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
    result
  }
}

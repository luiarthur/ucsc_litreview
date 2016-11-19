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

  // weighted sampling
  def wsample(x: Vector[Double], p: Vector[Double]) = {
    p.foreach( pi => assert(pi > 0 && pi < 1))
    val n = x.length
    assert(p.length == n)
    val sump = p.sum
    val rescaledP = if (sump == 1) p else p.map(pi => pi / sump)
    val u = Rand.nextUniform(0,n-1)
    val cumP = rescaledP.scanLeft(0.0)(_+_)
    // stopped here FIXME
  }
}

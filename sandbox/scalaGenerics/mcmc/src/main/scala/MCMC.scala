package mcmc

abstract class TuningParam(value:Any) {
  override def toString(): String = value.toString
}
/* Test
case class C(var value:Double) extends TuningParam(value)
val c = C(10)
*/


trait MCMC {
  def metropolis(x:Double, logFullCond: Double=>Double, stepSig:Double): Double = ???

  def metropolis_vec(x:Array[Double], logFullCond:Array[Double], stepCovMat:Array[Array[Double]]): Array[Double] = ???

  /* Adaptive metropolis (within Gibbs). See section 3 of the paper below:
   *   http://probability.ca/jeff/ftpdir/adaptex.pdf
   *
   * Another useful website:
   *   https://m-clark.github.io/docs/ld_mcmc/index_onepage.html
   */
  def metropolis_adaptive[T <: TuningParam](x:Double, logFullCondCond:Array[Double], iter:Int, delta: Int=>Double, stepSize: T) = {
    ???
  }
}

package mcmc

trait MCMC {
  def mh(x:Double): Double = ???
  def mh_vec(x:Array[Double]): Array[Double] = ???
}

package Rng
import org.apache.commons.math3.random.{RandomDataGenerator=>RDG}
import Timer._

object ParRng {
  //val nthreads = Runtime.getRuntime().availableProcessors();
  //val rng = Array.range(0,nthreads).map(_ => new RDG)
  //def tid() = Thread.currentThread().getId().toInt
  val N = 1000
  val idx = List.range(0,N)

  def bigFunction(rng:RDG, m:Int=10000) {
    val x = rng.nextGamma(2,3)
    //val x = rng.nextUniform(0,1)
    if (m > 0) bigFunction(rng, m-1)
  }

  def parSeparateRng(rng:RDG) {
    idx.par.foreach(_ => {
      bigFunction(rng)
    })
  }

  def seqRng(rng:RDG) {
    idx.foreach(_ => {
      bigFunction(rng)
    })
  }

  def main(args: Array[String]) {
    val rng = new RDG
    msg("Parallel:   "); timer{ parSeparateRng(rng) }
    msg("Sequential: "); timer{ seqRng(rng) }
  }
}

package Rng
import org.apache.commons.math3.random.{RandomDataGenerator=>RDG}
import Timer._
import java.util.concurrent._

object ParRng {
  //val nthreads = Runtime.getRuntime().availableProcessors();
  //val rng = Array.range(0,nthreads).map(_ => new RDG)
  //def tid() = Thread.currentThread().getId().toInt
  val N = 10000
  val idx = List.range(0,N)

  def bigFunction(rng:RDG, m:Int=10000) {
    val x = rng.nextGaussian(2,3)
    //val x = rng.nextUniform(0,1)
    if (m > 0) bigFunction(rng, m-1)
  }

  def bigFunctionThreadLocal(m:Int=10000) {
    val x = ThreadLocalRandom.current().nextGaussian * 3 + 2
    if (m > 0) bigFunctionThreadLocal(m-1)
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

  def threadLocalRandomRngSeq() {
    idx.foreach(_ => {
      bigFunctionThreadLocal()
    })
  }

  def threadLocalRandomRngPar() {
    idx.par.foreach(_ => {
      bigFunctionThreadLocal()
    })
  }

  def main(args: Array[String]) {
    val rng = new RDG
    threadLocalRandomRngPar()
    msg("ThreadLocalRandom Par: "); timer{ threadLocalRandomRngPar() }
    threadLocalRandomRngSeq()
    msg("ThreadLocalRandom Seq: "); timer{ threadLocalRandomRngSeq() }
    parSeparateRng(rng);

    msg("Parallel Collection:   "); timer{ parSeparateRng(rng) }
    seqRng(rng)
    msg("Sequential: "); timer{ seqRng(rng) }
  }
}

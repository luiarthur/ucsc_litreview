import java.util.concurrent._
import math.sqrt
import collection.parallel.mutable.ParArray


def timer[R](msg: String="")(block: => R): R = {  
  val t0 = System.nanoTime()
  val result = block
  val t1 = System.nanoTime()
  println(Console.GREEN + s"${msg}${(t1 - t0) / 1E9}s" + Console.RESET)
  result
}


val nBig = 1E4.toInt
val nSmall = 10
val arrBig = Array.fill(nBig)(0.toFloat)
val arrSmall = Array.fill(nSmall)(0.toFloat)
val parrBig = arrBig.par
val parrSmall = arrSmall.par


def updatePar(arr:ParArray[Float], i:Int) {
  var x = 0.0
  (1 to 10000).foreach { j => 
    x = ThreadLocalRandom.current().nextGaussian
    x /= sqrt(i+1)
    x += 2
  }
  arr(i) = x.toFloat
}

def update(arr:Array[Float], i:Int) {
  var x = 0.0
  (1 to 10000).foreach{ j =>
    x = ThreadLocalRandom.current().nextGaussian
  }
  x /= sqrt(i+1)
  x += 2
  arr(i) = x.toFloat
}


timer("warmup: ") {
  (0 until nSmall).par.foreach{i => i + 1}
}

timer("create parallel range (1 to 10):\t") {
  (0 until nSmall).par
}

timer("create parallel range (1 to 1E7):\t") {
  (0 until nBig).par
}

timer(s"do something $nSmall times in parallel:\t") {
  (0 until nSmall).par.foreach{ i => updatePar(parrSmall,i) }
}

timer(s"do something $nSmall times in sequence:\t") {
  (0 until nSmall).foreach{ i => update(arrSmall, i) }
}

timer(s"do something $nBig times in parallel:\t") {
  (0 until nBig).par.foreach{ i => update(arrBig, i) }
}

timer(s"do something $nBig times in parallel (v2):\t") {
  (0 until nBig).par.foreach{ i => updatePar(parrBig, i) }
}

timer(s"do something $nBig times in sequence:\t") {
  (0 until nBig).foreach{ i =>  update(arrBig, i) }
}

// No speed up?

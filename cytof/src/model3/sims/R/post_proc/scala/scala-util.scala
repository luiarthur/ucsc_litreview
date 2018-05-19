def sepBigMat(x: Array[Array[Double]], n: Array[Int]) = {
  //val x = Array.range(0,10)
  //val n = Array(3,5,2)
  val idxCum = n.scanLeft(0)(_+_)
  val idxLower = idxCum.dropRight(1)
  val idxUpper = idxCum.tail
  Array.tabulate(n.size){ i => x.slice(idxLower(i), idxUpper(i)) }
}

def joinMats(x: Array[Array[Array[Double]]]) = {
  x.reduceLeft(_++_)
}


def matForeach(m: Array[Array[Double]], f:(Int,Int)=>Unit) {
  m.indices.foreach{ r =>
    m.head.indices.foreach { c =>
      f(r,c)
    }
  }
}

/** Tests
val a = Array.ofDim[Double](3,2)
val b = Array.ofDim[Double](5,2)
matForeach(a, {(r,c) => a(r)(c) = 1})
matForeach(b, {(r,c) => b(r)(c) = 2})
val c = Array(a,b)

val n = c.map(_.size)
val j = joinMats(c)
val x = sepBigMat(j, n)
x.size
**/

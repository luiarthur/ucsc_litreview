object RowMajor {
  def timer[R](msg: String="")(block: => R): R = {  
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println(Console.GREEN + s"${msg}${(t1 - t0) / 1E9}s" + Console.RESET)
    result
  }


  /**
  abstract class MatGeneric(rows:Int, cols:Int) {
    type T <: AnyVal
    val data:Array[Array[T]]
    def foreach(f: (Int,Int) => Unit) {
      data.indices.foreach{ r =>
        data.head.indices.foreach{ c => 
          f(r,c)
        }
      }
    }
  }

  case class MatFloat(rows:Int, cols:Int) extends MatGeneric(rows, cols){
    type T = Float; val data = Array.ofDim[T](rows, cols)
  }
  case class MatDouble(rows:Int, cols:Int) extends MatGeneric(rows, cols){
    type T = Double; val data = Array.ofDim[T](rows, cols)
  }
  case class MatShort(rows:Int, cols:Int) extends MatGeneric(rows, cols){
    type T = Short; val data = Array.ofDim[T](rows, cols)
  }
  case class MatInt(rows:Int, cols:Int) extends MatGeneric(rows, cols){
    type T = Int; val data = Array.ofDim[T](rows, cols)
  }
  case class MatLong(rows:Int, cols:Int) extends MatGeneric(rows, cols){
    type T = Long; val data = Array.ofDim[T](rows, cols)
  }

  val mi = MatFloat(3,5)
  mi.foreach{ (r,c) => mi.data.update(r,c,1)}

  case class Mat(rows:Int, cols:Int) {
    type T
    val data = Array.ofDim[T](rows, cols)
    def foreach(f: (r:Int, c:Int) => Unit) {
      data.indices.foreach{ r =>
        data.head.indices.foreach{ c => 
          f(data(r)(c))
        }
      }
    }
  }
  **/

  def nrows[T <: AnyVal](m:Array[Array[T]]):Int = m.size
  def ncols[T <: AnyVal](m:Array[Array[T]]):Int = m.head.size
  def foreach[T <: AnyVal](m:Array[Array[T]], f: (Int,Int) => Unit):Unit = {
    m.indices.foreach{ r =>
      m.head.indices.foreach{ c =>
        f(r,c)
      }
    }
  }
  def cpMat[T <: AnyVal](m: Array[Array[T]]) = m.map(_.clone)

  val x = cpMat(arr)
  val x = arr.map(_.clone)

  val N = 10000
  val J = 1000
  val arr = timer() {Array.ofDim[Float](N,J)}
  timer("Row Major: ") { // faster
    foreach(arr, (r,c) => arr(r)(c) += 1)
  }


  timer("Row Major: ") { // faster
    arr.indices.foreach{ n =>
      arr.head.indices.foreach{ j => 
        arr(n)(j) += 1
      }
    }
  }

  timer("Col Major: ") { // slower
    arr.head.indices.foreach{ j =>
      arr.indices.foreach{ n => 
        arr(n)(j) += 1
      }
    }
  }

  def main(args: Array[String]) {
  }
}

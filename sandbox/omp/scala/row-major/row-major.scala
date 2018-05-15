object RowMajor {
  def timer[R](msg: String="")(block: => R): R = {  
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println(Console.GREEN + s"${msg}${(t1 - t0) / 1E9}s" + Console.RESET)
    result
  }


  abstract class Mat(rows:Int, cols:Int) {
    type T
    val dat: Array[Array[T]]

    def nrows():Int = dat.size
    def ncols():Int = dat.head.size
    def at(row:Int, col:Int):T = dat(row)(col)
    def update(row:Int, col:Int, x:T):Unit = {dat(row)(col) = x}
    def foreach(f: (Int,Int) => Unit) {
      dat.indices.foreach{ r =>
        dat.head.indices.foreach { c =>
          f(r,c)
        }
      }
    }
    //def cp(): Array[Array[T]] = dat.map(_.clone)
  }

  case class MatDouble (rows:Int, cols:Int) extends Mat(rows, cols) {
    type T = Double
    val dat = Array.ofDim[T](rows, cols)
  }


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


  val N = 10000
  val J = 10000
  //val arr = timer("Creating Matrix: ") {Array.ofDim[Float](N,J)}
  //val x = cpMat(arr).toArray
  def main(args: Array[String]) {
    val arr = timer("Creating Matrix: ") { MatDouble(N,J) }

    timer("Row-traversal: ") { // faster
      //foreach(arr, (r,c) => arr(r)(c) += 1)

      //arr.foreach( (r,c) => arr.update(r,c, arr.at(r,c) + 1) )
      arr.dat.indices.foreach{ n =>
        arr.dat.head.indices.foreach{ j => 
          arr.dat(n)(j) += 1
        }
      }
    }

    timer("Column-traversal: ") { // slower
      arr.dat.head.indices.foreach{ j =>
        arr.dat.indices.foreach{ n => 
          arr.dat(n)(j) += 1
        }
      }
    }
  }
}

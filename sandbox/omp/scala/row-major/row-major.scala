import java.util.concurrent._

object RowMajor {
  def timer[R](msg: String="")(block: => R): R = {  
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println(Console.GREEN + s"${msg}${(t1 - t0) / 1E9}s" + Console.RESET)
    result
  }


  abstract class Mat[T](dat: Array[Array[T]], rows:Int, cols:Int) {
    // Implement the following:
    //def this(rows:Int, cols:Int): this.type
    def cp()
    
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
    def foreachProw(f: (Int,Int) => Unit) {
      dat.indices.par.foreach{ r =>
        dat.head.indices.foreach { c =>
          f(r,c)
        }
      }
    }
    def foreachPcol(f: (Int,Int) => Unit) {
      dat.indices.foreach{ r =>
        dat.head.indices.par.foreach { c =>
          f(r,c)
        }
      }
    }
    def foreachPall(f: (Int,Int) => Unit) {
      (0 until (rows * cols)).par.foreach { z =>
        val r = z / cols
        val c = z % cols
        f(r,c)
      }
      //dat.indices.par.foreach{ r =>
      //  dat.head.indices.par.foreach { c =>
      //    f(r,c)
      //  }
      //}
    }

    override def toString():String = {
      val dims = s"${nrows} x ${cols} matrix"
      val arr = "TODO: Print part of the matrix"
      dims + "\n" + arr
    }
  }

  case class MatDouble (dat: Array[Array[Double]], rows:Int, cols:Int) extends Mat[Double](dat, rows, cols) {
    def this(rows:Int, cols:Int) {
      this(Array.ofDim[Double](rows, cols), rows, cols)
    }
    def cp() = new MatDouble(dat.map{_.clone}, rows, cols)
  }

  case class MatFloat (dat: Array[Array[Float]], rows:Int, cols:Int) extends Mat[Float](dat, rows, cols) {
    def this(rows:Int, cols:Int) {
      this(Array.ofDim[Float](rows, cols), rows, cols)
    }
    def cp() = new MatFloat(dat.map{_.clone}, rows, cols)
  }

  case class MatInt (dat: Array[Array[Int]], rows:Int, cols:Int) extends Mat[Int](dat, rows, cols) {
    def this(rows:Int, cols:Int) {
      this(Array.ofDim[Int](rows, cols), rows, cols)
    }
    def cp() = new MatInt(dat.map{_.clone}, rows, cols)
  }

  case class MatShort (dat: Array[Array[Short]], rows:Int, cols:Int) extends Mat[Short](dat, rows, cols) {
    def this(rows:Int, cols:Int) {
      this(Array.ofDim[Short](rows, cols), rows, cols)
    }
    def cp() = new MatShort(dat.map{_.clone}, rows, cols)
  }




  def main(args: Array[String]) {
    val N = 10000
    val J = 10000
    val mat = timer("Creating Matrix: ") { new MatFloat(N,J) }
    println(mat)

    timer("Row-traversal (parallel): ") { // faster
      mat.foreachProw{ (r,c) => 
        mat.update(r, c, ThreadLocalRandom.current.nextGaussian.toShort + 1)
      }
    }

    timer("Row-traversal (sequential): ") { // slower
      mat.foreach{ (r,c) => 
        mat.update(r, c, ThreadLocalRandom.current.nextGaussian.toShort + 1)
      }
    }

    timer("Col-traversal (parallel): ") { // slower
      mat.dat.head.indices.par.foreach{ c =>
        mat.dat.indices.foreach{ r =>
          mat.update(r, c, ThreadLocalRandom.current.nextGaussian.toShort + 1)
        }
      }
    }

    timer("Col-traversal (sequential): ") { // slower
      mat.dat.head.indices.foreach{ c =>
        mat.dat.indices.foreach{ r =>
          mat.update(r, c, ThreadLocalRandom.current.nextGaussian.toShort + 1)
        }
      }
    }

    timer("Row-traversal (Parallel-all): ") { // slower
      mat.foreachPall{ (r,c) => 
        mat.update(r, c, ThreadLocalRandom.current.nextGaussian.toShort + 1)
      }
    }

  }
}

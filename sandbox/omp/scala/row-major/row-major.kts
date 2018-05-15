import java.util.Random
import java.io.*
import java.util.concurrent.*

fun <R>timer(block: () -> R):R {
  val t0 = System.nanoTime()
  val result = block()
  val t1 = System.nanoTime()
  println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
  return result
}

//////////////////////////////////////////////////////////////////////////

interface Mat<A,T> {
  val dat: Array<A>
  fun nrows():Int { return dat.size }
  fun ncols():Int //{ return m.first().size }
  fun at(row:Int, col:Int):T
  fun update(row:Int, col:Int, x:T):Unit
}

class MatDouble constructor(rows:Int, cols:Int) : Mat<DoubleArray, Double> {
  override val dat = Array(rows, {DoubleArray(cols)})

  override fun ncols():Int { return dat.first().size }
  override fun at(row:Int, col:Int): Double { return dat[row][col]}
  override fun update(row:Int, col:Int, x:Double) { dat[row][col] = x}
}

class MatFloat constructor(rows:Int, cols:Int) : Mat<FloatArray, Float> {
  override val dat = Array(rows, {FloatArray(cols)})

  override fun ncols():Int { return dat.first().size }
  override fun at(row:Int, col:Int): Float { return dat[row][col]}
  override fun update(row:Int, col:Int, x:Float) { dat[row][col] = x}
}

class MatInt constructor(rows:Int, cols:Int) : Mat<IntArray, Int> {
  override val dat = Array(rows, {IntArray(cols)})

  override fun ncols():Int { return dat.first().size }
  override fun at(row:Int, col:Int):Int { return dat[row][col]}
  override fun update(row:Int, col:Int, x:Int) { dat[row][col] = x}
}

class MatShort constructor(rows:Int, cols:Int) : Mat<ShortArray, Short> {
  override val dat = Array(rows, {ShortArray(cols)})

  override fun ncols():Int { return dat.first().size }
  override fun at(row:Int, col:Int):Short { return dat[row][col]}
  override fun update(row:Int, col:Int, x:Short) { dat[row][col] = x}
}

/////////////////////////////////////////////////////////////////////////////

val N = 10000
val J = 10000

print("Create matrix: "); val mat = timer { MatDouble(N, J) }
println("nrows: ${mat.nrows()}")
println("ncols: ${mat.ncols()}")

// Row-major -> Row-traversal is faster
print("Row-traverse: ")
timer{
  for(r in mat.dat.indices) {
    for (c in mat.dat.first().indices) {
      //mat.update(r, c, mat.at(r,c) + 1)
      mat.update(r, c, ThreadLocalRandom.current().nextGaussian())
    }
  }
}
//mat.update(0, 0, {mat.at(0,0) + 1)

print("Col-traverse: ")
timer{
  for (c in mat.dat.first().indices) {
    for(r in mat.dat.indices) {
      //mat.update(r, c, (mat.at(r,c) + 1))
      mat.update(r, c, ThreadLocalRandom.current().nextGaussian())
    }
  }
}
/** to run as script: 
kotlinc -script row-major.kts
**/


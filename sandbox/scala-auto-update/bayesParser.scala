/* Version 1: Using Traits...
trait Constants {
  var N:Int
  var J:Int
  var m:Double = 0
  var s2:Double = 1.0
  val alpha:Array[Double] = Array.ofDim[Double](J)
}

trait Data extends Constants {
  val y = Array.ofDim[Double](N)
}

trait Params extends Constants {
  val c = Array.ofDim[Int](N)
  val mu = Array.ofDim[Double](J)
  var sig2:Double = 1
  val w = Array.ofDim[Double](J) 
}

case class model(var N:Int, var J:Int) extends Data with Params {
}

val b = model(10, 3)
*/

// http://www.lihaoyi.com/post/EasyParsingwithParserCombinators.html
// Version 2: Parser combinators. Probably go with this...
import scala.util.parsing.combinators._
val model = """
Constants {
  N: Int
  J: Int
  m: Double
  s2:Double
  alpha: Array[Double]
}

Data { // extends Constants
  y: Array.ofDim[Double](N)
}

model { // extends Data
  sig2 ~ IG(a, b)
  w ~ Dirichlet(alpha)

  for (i <- 0 until N) {
    y[i] ~ Normal( mu[c[i]], sig2 )
    c[i] ~ Categorical(J, w)
  }

  for (j <- 0 until J) {
    mu[j] ~ Normal(m, s2)
  }
}
"""


/* Version 3. Reflection...
import scala.reflect.runtime.universe._
typeOf[Params].members.toList
*/

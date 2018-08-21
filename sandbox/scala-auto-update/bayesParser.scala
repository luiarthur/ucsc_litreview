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

/* Version 2. Reflection...
import scala.reflect.runtime.universe._
typeOf[Params].members.toList
*/


// http://www.lihaoyi.com/post/EasyParsingwithParserCombinators.html
// Version 3: Parser combinators. Probably go with this...
import scala.util.parsing.combinator._

val model = """
Constants {
  N: Int
  J: Int
  m: Double
  s2:Double
  alpha: Array.ofDim[Double](J)
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

def parseData = ???
def parseConstants = ???
def parseLikelihood = ???
def parseAllParams = ???
def parseAllRV = ???
def parseMissingValues = ???
def parseParamsInFullConditionalOf(param:String) = ???

class ParseBayes extends RegexParsers {
  val eoi = """\z""".r // end of input
  val eol = sys.props("line.separator")
  val separator = eoi | eol
  def block = ("{" ~ (""".*""".r | separator) ~ "}") ^^ { _.toString }
  def constantBlock = """Constant\s*""".r ~ block ^^ { _.toString }
}

object test extends ParseBayes {
  def main {
    parse(block, model) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}

test.main


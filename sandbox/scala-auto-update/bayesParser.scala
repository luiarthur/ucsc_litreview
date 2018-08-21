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
// https://dzone.com/articles/getting-started-with-scala-parser-combinators
// Version 3: Parser combinators. Probably go with this...
import scala.util.parsing.combinator._
val constantsBlock = """
  Constants {
    N: Int
    J: Int
    m: Double
    s2:Double
    alpha: Array.ofDim[Double](J)
  };
""".trim


val model = """
object Cytof {
  Constants {
    N: Int
    J: Int
    m: Double
    s2:Double
    alpha: Array.ofDim[Double](J)
  };

  Data { // extends Constants
    y: Array.ofDim[Double](N)
  };

  Model { // extends Data
    sig2 ~ IG(a, b)
    w ~ Dirichlet(alpha)

    for (i <- 0 until N) {
      y[i] ~ Normal( mu[c[i]], sig2 )
      c[i] ~ Categorical(J, w)
    }

    for (j <- 0 until J) {
      mu[j] ~ Normal(m, s2)
    }
  };
}
""".trim

def parseData = ???
def parseConstants = ???
def parseLikelihood = ???
def parseAllParams = ???
def parseAllRV = ???
def parseMissingValues = ???
def parseParamsInFullConditionalOf(param:String) = ???

class ParseConstants extends RegexParsers {
  //val eol = sys.props("line.separator")
  def eol = "\n"
  def block = """\s*Constants\s*\{""".r ~ eol ~ rep(entry) ~ "};"
  def entry = """\s*""" ~ valueName ~ """\s*""".r ~ colon ~ """\s*""".r ~ valueType ~ eol
  def valueName = """\w+""".r
  def colon = ":"
  def valueType = """\w+""".r
}

object TestParseConstants extends ParseConstants {
  def main {
    parseAll(block, constantsBlock) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}
println(constantsBlock)
TestParseConstants.main

class ParseBayes extends RegexParsers {
  //def line = """\s*.*\n""".r
  //def block = ("""\w+\s*""".r ~ "{" ~ rep(line) ~ "};" ) ^^ { _.toString }
  //def code = """object\s+\w+\s\{""" ~ block ~ opt(block) ~ "}"
  //def constantBlock = """Constant\s*;*""".r ~ block ^^ { _.toString }
  def code = """object\s+\w+\s*\{""".r ~ constantsBlock ~ dataBlock ~ modelBlock ~ "}" ^^ {_.toString.replace("object", "Model name:").trim}
  def dataBlock = """\s*Data\s*\{""".r ~ content ~ "};" ^^ {_.toString}
  def constantsBlock = """\s*Constants\s*\{""".r ~ content ~ "};" ^^ {_.toString}
  def modelBlock = """\s*Model\s*\{""".r ~ content ~ "};" ^^ {_.toString}
  def kwFor = """\bfor\b""".r
  def forIterator = kwFor ~ """\s*\(""".r ~> """\w+""".r <~ """\s*\)""".r
  def blankLine = """\s*\n""".r
  def content = rep(""".*\n""".r)
}

object test extends ParseBayes {
  def main {
    parseAll(code, model) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}

test.main


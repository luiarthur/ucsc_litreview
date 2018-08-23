:load preprocess.scala
import scala.util.parsing.combinator._

// TODO: finish
class ParseModel extends RegexParsers {
  def kwFor = """\bfor\b""".r
  def expr = arrowAssignment | definition | distributedAs
  def forExpr:Parse[Any] = kwFor ~ spaces ~ "(" ~ expr ")" ~ spaces ~ block
  def block = "{" ~ repsep(expr, ";") ~ "};"
  def distributedAs = varNAme ~ "~" distribution
  def varNAme = """[\w|\[|\]]+""".r
  //def distribution = varNAme ~ "(" ~ ")"
}

object TestParseModel extends ParseModel {
  def main {
    parseAll(block, preprocess(modelChunk)) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}


println(preprocess(modelChunk))
TestParseConstants.main


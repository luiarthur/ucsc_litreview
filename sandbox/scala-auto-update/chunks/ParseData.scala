:load preprocess.scala
import scala.util.parsing.combinator._

class ParseConstants extends RegexParsers {
  def block = ("Data{" ~ repsep(entry,";") ~ ";};") ^^ {
    case _ ~ x ~ _ => s"Data{ ${x} }"
  }
  def entry = (valueName ~ colon ~ valueType) ^^ {
    case l ~ colon ~ r => "\n" + l + "<HAS_TYPE>" + r
  }
  def valueName = """\w+""".r ^^ {vn => "<VALUE>" + vn.toString + "</VALUE>"}
  def colon = ":" ^^ {_.toString}
  def numericType = ("Double" | "Float" | "Int" |  "Short" | "Long") ^^ {_.toString}
  def container = ("Array" | "Vector" | "List") ^^ {_.toString}
  def innerType = (".ofDim[" ~ numericType ~ "]") ^^ {
    case _~nt~_ => s".ofDim[${nt}]"
  }
  def seqNumeric = (container ~ innerType ~ "(" ~ "\\w+".r  ~")") ^^ {
    //_.toString
    case ct~it~_~w~_ => s"${ct}${it}(${w})"
  }
  def valueType = (numericType | seqNumeric) ^^ {t => s"<TYPE>${t.toString}</TYPE>"}
}

object TestParseConstants extends ParseConstants {
  def main {
    parseAll(block, preprocess(dataChunk)) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}


println(preprocess(dataChunk))
TestParseConstants.main


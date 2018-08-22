import scala.util.parsing.combinator._
val constantsBlock = """
Constants{
  N:Int;
  J:Int;
  m:Double;
  s2:Double;
  alpha:Array.ofDim[Double](J);
};
"""

def clean(s:String) = s.split("\n").map(_.trim).mkString

class ParseConstants extends RegexParsers {
  def block = ("Constants{" ~ repsep(entry,";") ~ ";};") ^^ {
    case _ ~ x ~ _ => s"Constants{ ${x} }"
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
    parseAll(block, clean(constantsBlock)) match {
      case Success(matched, rest) => println(matched)
      case Failure(msg, rest) => println("FAILURE: " + msg)
      case Error(msg, _) => println("ERROR: " + msg)
    }
  }
}

println(constantsBlock)
println(clean(constantsBlock))
TestParseConstants.main


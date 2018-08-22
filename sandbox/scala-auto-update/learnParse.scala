import scala.util.parsing.combinator._

class P extends RegexParsers {
  // can use ^^ instead of map (I **think** they are equivalent)
  val number = """[1-9][0-9]*""".r map {_.toDouble}
  // requires type because of recursion
  val expr: Parser[Double] = number ~ opt(operator ~ expr) map {
    case a ~ Some("+" ~ b) => a + b
    case a ~ Some("-" ~ b) => a - b
    case a ~ Some("*" ~ b) => a * b
    case a ~ Some("/" ~ b) => a / b
    case a ~ None => a
    case a ~ _ => a // For completeness. Without, a warning is shown.
  }
  val operator = "*" | "/" | "+" | "-"
}

object TestParser extends P {
  def run {
    val expressions = List("2*3+4", "2+3*4")
    expressions.foreach{ e =>
      val result = parseAll(expr, e)
      println(s"The answer to '${e}' is: ${result.get}")
    }
  }
}

TestParser.run


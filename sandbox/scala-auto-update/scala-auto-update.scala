object AutoUpdate {
  trait Expression
  case class Add(a:Expression, b:Expression) extends Expression
  case class Subtract(a:Expression, b:Expression) extends Expression
  case class Divide(a:Expression, b:Expression) extends Expression
  case class Multiply(a:Expression, b:Expression) extends Expression
  case class Power(a:Expression, b:Expression) extends Expression

  case class Sqrt(a:Expression) extends Expression
  case class Paren(a:Expression) extends Expression

  case class Real(value:Symbol) extends Expression {
    def +(that:Expression) = Add(this, that)
    def -(that:Expression) = Subtract(this, that)
    def /(that:Expression) = Divide(this, that)
    def *(that:Expression) = Multiply(this, that)
    def ^(that:Expression) = Power(this, that)
    def first() = Paren(this)
  }


  def showExpression(expr:Expression):String = expr match {
    case Power(a,b) => s"(${showExpression(a)} ^ ${showExpression(b)})"
    case Multiply(a,b) => s"(${showExpression(a)} * ${showExpression(b)})"
    case Divide(a,b) => s"(${showExpression(a)} / ${showExpression(b)})"
    case Add(a,b) => s"(${showExpression(a)} + ${showExpression(b)})"
    case Subtract(a,b) => s"(${showExpression(a)} - ${showExpression(b)})"
    case Paren(e) => s"(${showExpression(e)})"
    case Real(v) => v.toString
    //case e1:Expression => s"(${e1})"
  }

  /*Test
   val x = showExpression(Add(Real('y), Real('b)))
   val x = showExpression(Real('y) + Real('b))
   val x = showExpression(Real('y) ^ Real('b))

   val z = (Real('y) ^ Real('b)) 
   + Real('c)
   val x = showExpression(Real('y) ^ Real('b) + Real('c))
   println(x)
   */

  def hasGaussianForm(expr:Expression):Boolean = {
  }

}

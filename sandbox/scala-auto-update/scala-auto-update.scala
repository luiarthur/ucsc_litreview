object AutoUpdate {
  case class Expression(value:String) {
    def +(that:Expression) = Expression(s"${this.value}__plus__${that.value}")
    def -(that:Expression) = Expression(s"${this.value}__minus__${that.value}")
    def *(that:Expression) = Expression(s"${this.value}__times__${that.value}")
    def /(that:Expression) = Expression(s"${this.value}__div__${that.value}")
    def ^(that:Expression) = Expression(s"${this.value}__pow__${that.value}")
    def sqrt() = Expression(s"sqrt(${this.value})")

    override def toString() = value
  }
  def paren(e1:Expression): Expression = Expression(s"(${e1.value})")
  /*Test
   println(paren(Expression("y") * Expression("x")) + Expression("z"))
   println(Expression("y") + paren(Expression("x") * Expression("z")))
   println((Expression("y") + Expression("x") ^ Expression("z")).sqrt)
   */

  trait Expr
  case class Real(value:Any) extends Expr {
    override def toString() = value match {
      case v:Symbol=> v.toString.tail
      case x => x.toString
    }
  }
  object NullExpr extends Expr
  object Add extends Expr { override def toString() = "+" }
  object Minus extends Expr { override def toString() = "-" }
  object Mult extends Expr { override def toString() = "*" }
  object Div extends Expr { override def toString() = "/" }
  object Pow extends Expr { override def toString() = "^" }

  case class Expression(a:Expr, b:Expr=NullExpr, op:Expr=NullExpr) extends Expr {
    def +(that:Expression) = Expression(a, that, Add)
    def -(that:Expression) = Expression(a, that, Minus)
    def *(that:Expression) = Expression(a, that, Mult)
    def /(that:Expression) = Expression(a, that, Div)
    def ^(that:Expression) = Expression(a, that, Pow)
  }

  def showExpression(e: Expression):String = e match {
    //case Expression(Expression(aa,ab,aop), NullExpr, Sqrt) => s"sqrt(${showExpression(Expression(aa,ab,aop))})"
    case Expression(Real(a), NullExpr, NullExpr) => Real(a).toString
    case Expression(Real(a), Expression(ba,bb,bop), op) => s"${a.toString.tail} ${op.toString} ${showExpression(Expression(ba,bb,bop))}"
    case Expression(Expression(aa,ab,aop), _, NullExpr) => s"${showExpression(Expression(aa,ab,aop))}"
    case Expression(Expression(aa,ab,aop), Expression(ba,bb,bop), op) => s"${showExpression(Expression(aa,ab,aop))} ${op.toString} ${showExpression(Expression(ba,bb,bop))}"
    case Expression(Real(a), Real(b), op) => s"${Real(a).toString} ${op.toString} ${Real(b).toString}"
    case _ => "Not Implemented"
  }

  val y = Real('y)
  Expression(y) + Expression(y)
  showExpression(Expression(y))
  showExpression(Expression(y) + Expression(y))
  //showExpression(Expression(y,op=Sqrt) + (Expression(y) * Expression(y)))
  showExpression(Expression(Expression(y) + (Expression(y) * Expression(y))))
  val x = (Expression(Expression(y) + (Expression(y) * Expression(y))))
  showExpression(Expression((x * x + x) - x))

  val x = (Expression(Expression(y) + (Expression(y) ^ Expression(Real(.5)) * Expression(y))))
  showExpression(Expression((x * x + x) - x))
  showExpression(Expression((x * x + x) - x, op=Sqrt))

  Expression(y)


  def hasGaussianForm(expr:Expression):Boolean = {
  }

}

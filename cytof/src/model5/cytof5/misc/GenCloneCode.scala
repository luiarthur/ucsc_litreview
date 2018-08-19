object GenCloneCode {
  def run {
    val numericTypes = List("Double", "Float", "Int", "Short", "Long") 
    val dims = List.range(0,10)

    def typeBuilder(dim:Int, numType:String):String = {
      if (dim == 0) numType else {
        typeBuilder(dim - 1, s"Array[${numType}]")
      }
    }

    def outBuilder(dim:Int, numType:String, varName:String="x"):String = 
      dim match {
      case 0 => varName
      case 1 => "x.clone"
      case _ =>  s"x.map(clone${dim-1}d${numType})"
    }

    val buildCloneDefs = for (nt <- numericTypes; d <- dims) yield {
      val defName = s"clone${d}d${nt}"
      s"    def ${defName}(x:${typeBuilder(d, nt)}) = ${outBuilder(d, nt)}"
    }



    val smartCloneMatches = for(nt <- numericTypes; d <- dims) yield {
      s"""
        case x:${typeBuilder(d, nt)} => ${outBuilder(d,nt)}"""
    }
    val buildSmartClone = s"""
    def smartClone(a:Any): Any = a match {
      ${smartCloneMatches.mkString}
    }
    """

    val code = s"""// This file was generated by /misc/GenCloneCode.scala
package cytof5
  object CloneXdArray {
  ${buildCloneDefs.mkString("\n")}
  ${buildSmartClone}
}
    """

    println(code)
  }
}

GenCloneCode.run


def vb[S](init:S, update:S=>S, compare:(S,S)=>Double, eps:Double=1E-6) = {

  def findOpt(curr:S, its:Int): (S,Int) = {
    val next = update(curr)
    if (math.abs(compare(next, curr)) < eps) 
      (next, its)
    else
      findOpt(next, its + 1)
  }

  findOpt(init, 0)
}

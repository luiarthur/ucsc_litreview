object VB {
  def newton(curr:Double, prev:Double, f:Double=>Double,
             eps:Double=1E-6, maxIter:Int=1000, currIter:Int=0,
             verbose:Boolean=false):Double = {

    // secant method is a variant of newton raphson which is more stable
    // numerically.
    import math.{log,exp}

    val fCurr = f(curr)
    val next = curr - fCurr * (prev - curr) / (f(prev) - fCurr)

    if (math.abs(next - curr) < eps || currIter >= maxIter) {
      if (verbose) println("Number of iterations: " + currIter)
      next
    } else {
      newton(next, curr, f, eps, maxIter, currIter+1, verbose)
    }
  }

  // Coordinate Ascent Variational Inference
  def cavi[S](curr:S, update:S=>S, elbo:S=>Double, maxIter:Int=1000,
              currIter:Int=0, eps:Int=1):S = {
    val next = update(curr)
    if (math.abs(elbo(next) - elbo(curr)) < eps) next else {
      cavi(next, update, elbo, maxIter, currIter+1, eps)
    }
  }
}

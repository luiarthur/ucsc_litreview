package ass1

package object mcmc {

  def metropolis(curr:Double, loglike_plus_prior:Double=>Double, candSig:Double) = {
    val cand = ass1.util.Rand.nextGaussian(curr,candSig)
    val u = math.log(ass1.util.Rand.nextUniform(0,1))
    val p = loglike_plus_prior(cand) - loglike_plus_prior(curr)
    if (p > u) cand else curr
  }

  def gibbs(init: State, B: Int, burn: Int, printEvery: Int = 10) = {
    //def loop(S: List[T], i: Int): List[T] = {
    //  if (i < B + burn) {
    //    if (i % printEvery == 0) print("\rProgress: " + i +"/"+ (B+burn))
    //    val newState = S.head.update.asInstanceOf[T] :: S
    //    loop(newState, i+1)
    //  } else {
    //    print("\rProgress: " + i + "/" + (B + burn) + "\n")
    //    S
    //  }
    //}
    //loop(List(init),0).take(B)
  }


}

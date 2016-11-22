package ass1

package object mcmc {

  def metropolis(curr:Double, loglike_plus_prior:Double=>Double, candSig:Double) = {
    val cand = ass1.util.Rand.nextGaussian(curr,candSig)
    val u = math.log(ass1.util.Rand.nextUniform(0,1))
    val p = loglike_plus_prior(cand) - loglike_plus_prior(curr)
    if (p > u) cand else curr
  }

  def gibbs(init: State, priors: Priors, data: ass1.data.Data,
            B: Int, burn: Int, printEvery: Int = 10) = {
    def loop(S: List[State], i: Int): List[State] = {
      if (i < B + burn) {
        if (i % printEvery == 0) print("\rProgress: " + i +"/"+ (B+burn))
        val newState = S.head.update(priors,data) :: S
        loop(newState, i+1)
      } else {
        print("\rProgress: " + i + "/" + (B + burn) + "\n")
        S
      }
    }
    loop(List(init),0).take(B)
  }
 
  def neal8Update(alpha: Double, t: Vector[Double],
    logf: (Double,Int)=>Double, 
    logg0: Double=>Double, rg0: ()=>Double,
    cs: Double) = { // assumes m = 1

    def f(x:Double,i:Int) = math.exp(logf(x,i))
    val n = t.length
    def removeAt(i: Int, x: Vector[Double]) = {
      val sa = x.splitAt(i)
      sa._1 ++ sa._2.tail
    }

    def updateAt(i: Int, t: Vector[Double]): Vector[Double] = {
      if (i == n) t else {
        val tMinus = removeAt(i,t)
        val (uT,uN) = tMinus.groupBy(identity).
                        map{z => (z._1,z._2.length)}.toVector.unzip
        val aux = rg0()
        val probExisting = uT.zip(uN).map(z => z._2 * f(z._1,i))
        val pAux = alpha * f(aux, i)
        val newTi = ass1.util.wsample(uT :+ aux, probExisting :+ pAux)
        updateAt(i+1, t.updated(i,newTi))
      }
    }

    def updateClusters(t: Vector[Double]): Vector[Double] = {
      val out = Array.ofDim[Double](n)
      t.zipWithIndex.groupBy(_._1).mapValues(i => i.map(_._2)).foreach{ kv => 
        val curr = kv._1
        val idx = kv._2
        val newVal = metropolis(curr, v => idx.map(i => logf(v,i)).sum + logg0(v), cs)
        idx.foreach { i => out(i) = newVal }
      }
      out.toVector
    }
  
    updateClusters(updateAt(0,t))
  }

}

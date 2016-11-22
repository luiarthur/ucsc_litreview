package ass1

import ass1.util.{logit,invLogit}

package object mcmc {

  def metropolis(curr:Double, loglike_plus_prior:Double=>Double, 
                 candSig:Double) = {
    val cand = ass1.util.Rand.nextGaussian(curr,candSig)
    val u = math.log(ass1.util.Rand.nextUniform(0,1))
    val p = loglike_plus_prior(cand) - loglike_plus_prior(curr)
    if (p > u) cand else curr
  }

  def gibbs(init: State, priors: Priors, data: ass1.data.Data,
            B: Int, burn: Int, printEvery: Int = 10) = {

    def loop(S: List[State], i: Int): List[State] = {
      if (i % printEvery == 0) 
        print("\rProgress: " + i +"/"+ (B+burn) + "\t" + 
          java.util.Calendar.getInstance.getTime() + "\t")

      if (i < B + burn) {
        val newState = if (i <= B) 
          List( S.head.update(priors,data) )
        else 
          S.head.update(priors,data) :: S
        
        loop(newState, i+1)
      } else S
    }

    lazy val out = loop(List(init),0)
    println()
    out
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
        val mapUT = tMinus.groupBy(identity).mapValues(_.length).toVector
        val aux = rg0()
        val probExisting = mapUT.map(ut => ut._2 * f(ut._1,i) / (alpha + n -1))
        val pAux = alpha * f(aux, i) / (alpha + n - 1)
        val (uT,uN) = mapUT.unzip
        val newTi = ass1.util.wsample(uT :+ aux, probExisting :+ pAux)
        updateAt(i+1, t.updated(i,newTi))
      }
    }

    def updateClusters(t: Vector[Double]): Vector[Double] = {
      val out = Array.ofDim[Double](n)

      t.view.zipWithIndex.groupBy(_._1).mapValues(i => i.map(_._2)).foreach{ kv => 
        val (curr,idx) = kv

        def logLikePlusLogPriorLogitV(logitV: Double) = {
          val v = invLogit(logitV)
          val logJ = -logitV + 2 * math.log(v)
          val logPriorLogitV = logJ // + logg0(v)
          val ll = idx.map(i => logf(v,i)).sum
          ll + logPriorLogitV
        }

        val newVal = 
          invLogit(metropolis(logit(curr), logLikePlusLogPriorLogitV, cs))

        idx.foreach { i => out(i) = newVal }
      }
      out.toVector
    }
  
    updateClusters(updateAt(0,t))
  }

}

package tumor

import tumor.util._
import tumor.data.Obs

package object mcmc {

  // metropolis step with normal random walk
  def metropolis(curr:Double,ll:Double=>Double,lp:Double=>Double,candSig:Double) = {
    def logLikePlusLogPrior(x:Double) = ll(x) + lp(x)
    val cand = Rand.nextGaussian(curr,candSig)
    val u = math.log(Rand.nextUniform(0,1))
    val p = logLikePlusLogPrior(cand) - logLikePlusLogPrior(curr)
    if (p > u) cand else curr
  }

  // metropolis step on logit-transformed var with normal random walk
  def metLogit(curr:Double,ll:Double=>Double,lp:Double=>Double,candSig:Double) = {
    // curr should be between 0 and 1
    
    def logit(p:Double) = math.log(p / (1-p))
    def invLogit(x:Double) = 1.0 / (1.0 + math.exp(-x))

    def logLogitPrior(logitP: Double) = {
      val p = invLogit(logitP)
      val logJ = -logitP + 2*math.log(p)
      lp(p) + logJ 
    }

    def llLogit(logitP:Double) = ll(invLogit(logitP))

    invLogit(metropolis(logit(curr), llLogit, logLogitPrior, candSig))
  }


  def gibbs(init: State, prior: Prior, obs: Obs,
            B: Int, burn: Int, printEvery: Int = 10) = {

    def loop(S: List[State], i: Int): List[State] = {
      if (i % printEvery == 0) 
        print("\rProgress: " + i +"/"+ (B+burn) + "\t" + 
          java.util.Calendar.getInstance.getTime() + "\t")

      if (i < B + burn) {
        val newState = if (i <= burn) 
          List( S.head.update(prior,obs) )
        else 
          S.head.update(prior,obs) :: S
        
        loop(newState, i+1)
      } else S
    }

    lazy val out = loop(List(init),0)
    println()
    out
  }

  def algo8(alpha: Double, t: Vector[Double],
    logf: (Double,Int)=>Double, 
    logg0: Double=>Double, rg0: ()=>Double,
    mh:(Double,Double=>Double,Double=>Double,Double)=>Double=metropolis, 
    cs: Double, clusterUpdates:Int=1) = { // assumes m = 1

    def f(x:Double,i:Int) = math.exp(logf(x,i))
    val n = t.length

    val mapUT = collection.mutable.Map[Double,Int]()
    t foreach { ti => if (mapUT.contains(ti)) mapUT(ti) += 1 else mapUT(ti) = 1 }

    def updateAt(i: Int, t: Vector[Double]): Vector[Double] = {
      if (i == n) t else {
        mapUT(t(i)) -= 1
        val aux = if (mapUT( t(i) ) > 0) rg0() else {
          mapUT.remove( t(i) )
          t(i)
        }
        //val probExisting = mapUT.map(ut => ut._2 * f(ut._1,i)).toVector
        val probExisting = mapUT.map(ut => ut._2 * f(ut._1,i)).toVector
        val pAux = alpha * f(aux, i)
        val uT = mapUT.keys.toVector
        val newTi = wsample(uT :+ aux, probExisting :+ pAux)
        updateAt(i+1, t.updated(i,newTi))
      }
    }


    def updateClusters(t:Vector[Double]): Vector[Double] = {
      val out = Array.ofDim[Double](n)
      val tWithIndex = t.zipWithIndex

      t.distinct.foreach { curr =>
        val idx = tWithIndex.filter(_._1 == curr).map(_._2)

        def ll(v:Double) = idx.map( logf(v,_) ).sum

        def loop(v:Double,it:Int):Double = 
          if (it==0) v else mh(v,ll,logg0,cs)

        val newVal = loop(curr,clusterUpdates)

        idx.foreach { i => out(i) = newVal }
      }

      out.toVector 
    }
  
    updateClusters(updateAt(0,t))
  }

  
}

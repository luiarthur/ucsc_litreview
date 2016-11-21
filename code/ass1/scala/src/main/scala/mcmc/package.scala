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

  //def neal8Update(alpha: Double, t: Vector[Double],
  //  f: (Double,Int)=>Double, logf: (Double,Int)=>Double, 
  //  logg0: Double=>Double, rg0: ()=>Double,
  //  cs: Double) = { // assumes m = 1

  //  val n = t.length
  //  val idx = Vector.range(0,n)

  //  def removeAt(i: Int, x: Vector[Double]) = {
  //    val sa = x.splitAt(i)
  //    sa._1 ++ sa._2.tail
  //  }

  //  def newTat(i: Int, t: Vector[Double]) = {
  //    val tMinus = removeAt(i,t)
  //    val uniqueT = tMinus.toSet.toVector
  //    val uniqueN = uniqueT.map(ut => t.count(ti => ti == ut))
  //    val newTi = rg0()

        // FIXME: Check?
  //    def probTiEquals(j: Int) = {
  //      if (j == i) {
  //        alpha * f(newTi, i)
  //      } else uniqueN(j) * f(uniqueT(j), i)
  //    }

  //    val probs = Vector.range(0,uniqueN.length).map{probTiEquals}

  //    ass1.util.wsample(uniqueT :+ newTi, probs)
  //  }

  //  def update(i: Int, t: Vector[Double]): Vector[Double] = 
  //    if (i==0) t else update(i-1, t.updated(i,newTat(i,t)))

  //  def updateAll(t: Vector[Double]) = {
  //    // FIXME. Check?
  //    val ut = t.toSet.toVector
  //    val utIdx = ut.map{ u => idx.filter(i => t(i) == u) }
  //    val newUT = for (k <- 0 until ut.length) yield 
  //      metropolis(ut(k), u => utIdx(k).map(s => logf(u,s)).sum + logg0(u), cs)
  //    val out = Array.ofDim[Double](n)
  //    for (i <- 0 until newUT.length; j <- utIdx(i)) out(j) = newUT(i)
  //    out.toVector
  //  }

  //  updateAll(update(n, t))
  //}

  
  def neal8Update(alpha: Double, t: Vector[Double],
    f: (Double,Int)=>Double, logf: (Double,Int)=>Double, 
    logg0: Double=>Double, rg0: ()=>Double,
    cs: Double) = { // assumes m = 1

    val n = t.length
    def removeAt(i: Int, x: Vector[Double]) = {
      val sa = x.splitAt(i)
      sa._1 ++ sa._2.tail
    }

    def updateAt(i: Int, t: Vector[Double]): Vector[Double] = {
      val tMinus = removeAt(i,t)
      val (uT,uN) = tMinus.groupBy(identity).
                           map{z => (z._1,z._2.length)}.toVector.unzip
      if (i == n) t else {
        val aux = rg0()
        val probExisting = uT.zip(uN).map(z => z._2 * f(z._1,i))
        val pAux = alpha * f(aux, i)
        val newTi = ass1.util.wsample(uT :+ aux, probExisting :+ pAux)
        updateAt(i+1, t.updated(i,newTi))
      }
    }

    def updateClusters(t: Vector[Double]): Vector[Double] = {
      val out = Array.ofDim[Double](n)
      t.zipWithIndex.groupBy(_._1).mapValues(i => i.map(_._2))
      ???
    }
  
    updateClusters(updateAt(0,t))
  }

}

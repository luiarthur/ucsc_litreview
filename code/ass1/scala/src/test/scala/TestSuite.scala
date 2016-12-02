import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  test("speed of sum") {
    import tumor.util._
    val n = 100000
    // in general for n = 100000, array is 10 times faster than vector
    val v1 = Vector.fill(n)(scala.util.Random.nextGaussian)
    val v2 = Vector.fill(n)(scala.util.Random.nextGaussian)
    val v3 = Vector.fill(n)(scala.util.Random.nextGaussian)

    println()
    // in general, for these operations, for loop is fastest!
    print("Create idx:\t")
    val idx = timer {Vector.range(0,n)}
    print("zipped:\t\t")  // Vector:0.01s // Array: 0.015
    val v4 = timer { (v1,v2,v3).zipped.toVector.map(z => z._1 * z._2 * z._3).sum }
    print("zipped2:\t")  // Vector:0.005s // Array: 0.015 // winner for Vectors
    val v123 = (v1,v2,v3).zipped.toVector
    val v42 = timer { v123.map(z => z._1 * z._2 * z._3).sum }
    print("idx:\t\t") // Vector: 0.03s // Array: 0.007
    val v5 = timer {idx.map(i => v1(i) * v2(i) * v3(i)).sum }
    print("for:\t\t") // Vector: 0.008s // Array: 0.002 // winner for Arrays
    var sum = 0.0
    timer { for (i <- 0 until n) { sum += v1(i) * v2(i) * v3(i) } }
    val v6 = sum
    print("while:\t\t") // Vector: 0.01s // Array: 0.004
    sum = 0.0; var i = 0
    timer {while (i < n) {sum += v1(i) * v2(i) * v3(i); i+=1} }
    val v7 = sum
    def loop(sum: Double, i: Int): Double = {
      if (i == n) sum else loop(sum + v1(i) * v2(i) * v3(i), i+1)
    }
    print("recursive:\t") // Vector: 0.014s // Array: 0.0025s
    val v8 = timer {loop(0.0, 0) }

    def loop2(sum:Double,v1:Vector[Double],v2:Vector[Double],v3:Vector[Double]): Double ={
      if (v1 == Nil) sum else loop2(sum+v1.head*v2.head*v3.head,v1.tail,v2.tail,v3.tail)
    }
    print("recursive2:\t") // Vector: 0.014s // Array: 0.0025s
    val v9 = timer {loop2(0.0,v1,v2,v3) }

    println()

    /* julia
       n = 100000; v1 = randn(n); v2 = randn(n); v3 = randn(n);
       sum( v1.* v2 .* v3) # 0.0019 seconds
     */
    assert(round(v4,5) == round(v5,5) && round(v5,5) == round(v6,5) && round(v6,5) == round(v7,5) && round(v7,5) == round(v8,5) && round(v8,5) == round(v9,5))
  }

  test("speed of Array sum") {
    import tumor.util._
    val n = 100000
    // in general for n = 100000, array is 10 times faster than vector
    val a1 = Array.fill(n)(scala.util.Random.nextGaussian)
    val a2 = Array.fill(n)(scala.util.Random.nextGaussian)
    val a3 = Array.fill(n)(scala.util.Random.nextGaussian)

    println()
    // in general, for these operations, for loop is fastest!
    print("Create idx:\t")
    val idx = timer {Array.range(0,n)}
    print("zipped:\t\t")  // Vector:0.01s // Array: 0.015
    val v4 = timer { (a1,a2,a3).zipped.toVector.map(z => z._1 * z._2 * z._3).sum }
    print("zipped2:\t")  // Vector:0.005s // Array: 0.015 // winner for Vectors
    val a123 = (a1,a2,a3).zipped.toVector
    val v42 = timer { a123.map(z => z._1 * z._2 * z._3).sum }
    print("idx:\t\t") // Vector: 0.03s // Array: 0.007
    val v5 = timer {idx.map(i => a1(i) * a2(i) * a3(i)).sum }

    print("for:\t\t") // Vector: 0.008s // Array: 0.002 // winner for Arrays
    var sum = 0.0
    timer { for (i <- 0 until n) { sum += a1(i) * a2(i) * a3(i) } }
    val v6 = sum
    //val v6 = timer {for (i <- 0 until n) yield a1(i)*a2(i)*a3(i)}.sum

    print("while:\t\t") // Vector: 0.01s // Array: 0.004
    sum = 0.0; var i = 0
    timer {while (i < n) {sum += a1(i) * a2(i) * a3(i); i+=1} }
    val v7 = sum
    def loop(sum: Double, i: Int): Double = {
      if (i == n) sum else loop(sum + a1(i) * a2(i) * a3(i), i+1)
    }
    print("recursive:\t") // Vector: 0.014s // Array: 0.0025s
    val v8 = timer {loop(0.0, 0) }


    println()

    /* julia
       n = 100000; v1 = randn(n); v2 = randn(n); v3 = randn(n);
       sum( v1.* v2 .* v3) # 0.0019 seconds
     */
    assert(round(v4,5) == round(v5,5) && round(v5,5) == round(v6,5) && round(v6,5) == round(v7,5) && round(v7,5) == round(v8,5))
  }



  test("wsample") {
    import tumor.util._
    val x = Vector(1.0,2.0,3.0,4.0,5.0)
    val p1 = Vector(.2, .4, .1, .2, .1)
    val p2 = Vector(2.0, 4.0, 1.0, 2.0, 1.0)
    val n = 100000
    val out1 = timer { Vector.fill(n)(wsample(x,p1)) }
    val out2 = timer { Vector.fill(n)(wsample(x,p2)) }
    val trueMean = x.zip(p1).map(z => z._1*z._2).sum 

    //println(out1.sum / n, trueMean)
    //println(out2.sum / n, trueMean)
    assert(math.abs(out1.sum/n - trueMean) < .1)
    assert(math.abs(out2.sum/n - trueMean) < .1)
    println()
  }

  test("sim data") {
    import tumor.util._
    import tumor.data.GenerateData.genData
    val (obs,param) = genData(phiMean=0.0, phiVar=1.0, mu=0.3, 
                              sig2=1,
                              meanN0=30.0, minM=0, maxM=5, wM=.5, 
                              setV=Set(.3,.2,.6), numLoci=10)
    println(obs)
    println(param)
  }

  test("test dp") {
    import tumor.util._
    import tumor.data.GenerateData.genData
    import tumor.data._
    import tumor.mcmc._

    //Rand.reSeed(1)
    val R = org.ddahl.rscala.callback.RClient()

    // it appears that when mu < .5, the clusters cant be found.
    val (obs,param) = genData(phiMean=0, phiVar=1, mu=.6, 
                              sig2=.15, meanN0=30, 
                              minM=0, maxM=4, wM=.9, 
                              setV=Set(.1,.5,.9), numLoci=100)

    val nLoci = obs.numLoci
    val sig2MLE = {
      val logN1OverN0 = Vector.tabulate(obs.numLoci){s=> 
        math.log(obs.N1(s).toDouble / obs.N0(s).toDouble)
      }
      std(logN1OverN0)
    }
    println(sig2MLE)

    lazy val init = State(phi=Vector.fill(nLoci)(0),
                          sig2=sig2MLE, mu=.5,
                          v=Vector.fill(nLoci)(.5))
    val prior = new Prior(aSig=2,bSig=sig2MLE,
                          s2Phi=1E6,csV=0.1,
                          csMu=.5,alpha=0.05)

    val out = timer { gibbs(init,prior,obs,B=2000,burn=30000,printEvery=100) }

    R.mu = out.map(_.mu).toArray
    R.muTrue = param.mu

    R.sig2 = out.map(_.sig2).toArray
    R.sig2True = param.sig2

    R.phi = out.map(_.phi).map(_.toArray).toArray
    R.truePhi = param.phi.toArray

    val v = out.map(_.v).map(_.toArray).toArray
    R.v = v
    R.truev = param.v.toArray

    R.numClus = v.map( vt => vt.distinct.length )

    R eval """
    require('devtools')
    if ( !("rcommon" %in% installed.packages()) ) {
      devtools::install_github('luiarthur/rcommon')
    }
    library(rcommon)

    pdf("src/test/scala/output/plots.pdf")
    par(mfrow=c(2,3))

    plotPost(sig2,main=paste0('sig2(truth=',sig2True,')'),float=TRUE)
    muAcc <- round(length(unique(mu)) / length(mu),2)
    plotPost(mu,main=paste0('mu',' (truth=',muTrue,')'),
             float=TRUE,xlab=paste0('accRate: ', muAcc))
    plot(numClus,main='Number of Clusters',pch=20,col=rgb(0,0,1,.5),cex=2,fg='grey')

    plot(truePhi,apply(phi,2,mean),xlim=c(-3,3),ylim=c(-3,3),fg='grey',
         xlab='truth',ylab='prediction',main='phi',col='grey30')
    abline(0,1,col='grey30')

    add.errbar(t(apply(phi,2,quantile,c(.025,.975))),x=truePhi,col=rgb(0,0,1,.2))

    ord <- order(truev)
    plot(truev[ord],pch=20,ylim=c(0,1),main='v',col='grey30',fg='grey',ylab='')
    points(apply(v,2,mean)[ord],lwd=2,col='blue',cex=1.3)
    add.errbar(t(apply(v,2,quantile,c(.025,.975)))[ord,],co=rgb(0,0,1,.2))

    plot(v[,ord[ncol(v)]],col=rgb(.5,.5,.5,.3),type='l',ylim=c(0,1),fg='grey',main='trace plot for v_100')

    #library(corrplot)
    #corrplot(cor(v))

    par(mfrow=c(1,1))
    dev.off()
    """
    //scala.io.StdIn.readLine()

  }

}

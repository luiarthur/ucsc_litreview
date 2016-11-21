import org.scalatest.FunSuite
class TestSuite extends FunSuite {
  test("speed of sum") {
    import ass1.util._
    val n = 100000
    // in general for n = 100000, array is 10 times faster than vector
    val v1 = Vector.fill(n)(scala.util.Random.nextGaussian)
    val v2 = Vector.fill(n)(scala.util.Random.nextGaussian)
    val v3 = Vector.fill(n)(scala.util.Random.nextGaussian)

    println()
    // in general, for these operations, for loop is fastest!
    print("Create idx:\t")
    val idx = timer {Vector.range(0,n).par}
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

  test("wsample") {
    import ass1.util._
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
    import ass1.util._
    import ass1.data.GenerateData.simOneObs
    val trueData = simOneObs(phiMean=0.0, phiVar=1.0, mu=0.3, 
                             c=30.0, minM=0, maxM=5, wM=.5, 
                             setV=Set(.3,.2,.6), S=10)
    println(trueData)
  }
}

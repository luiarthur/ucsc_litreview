import scala.collection.mutable.{ Map => MutableMap, HashMap => MutableHashMap }
import java.util.concurrent.ThreadLocalRandom

/*
// memoize. For explaination, see: 
// https://github.com/luiarthur/scala_practice/blob/master/memoize/memoize.md
def memoize[I,O](f: I=>O): I=>O = new MutableHashMap[I,O] {
  override def apply(key: I): O = getOrElseUpdate(key, f(key))
}


case class Nodes {
  val rvs: MutableMap[String, Distribution] = 
}

def f(arg:Any*) = arg
*/

abstract class Distribution(params: Any*) {
  type RvType 
  def sample: RvType
  def pdf(x:RvType): Double
  def cdf(x:RvType): Double
  def ccdf(x:RvType): Double = 1 - cdf(x)
  def lpdf(x:RvType): Double = math.log(pdf(x))
  def lcdf(x:RvType): Double = math.log(cdf(x))
  def lccdf(x:RvType): Double = math.log(ccdf(x))

  def samples(n:Int):Vector[RvType] = Vector.tabulate(n){ i => sample }
}

case class Normal(params: (Double, Double)) extends Distribution(params) {
  type RvType = Double
  val (mean, sd) = params
  def sample = ThreadLocalRandom.current.nextGaussian
  def cdf(x:RvType) = 0
  override def lpdf(x:RvType) = -0.5 * math.log(2 * math.Pi) - math.pow((x-mean)/sd, 2)
  def pdf(x:RvType) = math.exp(lpdf(x))

  def this(mean:Double, sd:Double) {
    this((mean, sd))
  }

  override def toString = {
    s"Normal(mean:$mean, sd:$sd)"
  }
}

val x = new Normal(mean=2, sd=3)

x match {
  case Normal((m,sd)) => (Normal(m, sd)).toString
  case _ => "idk"
}

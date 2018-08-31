package parRandom

trait RandomFactory {
  def nextDouble(): Double
  def nextGaussian(): Double = {
    // box-mueller
    math.sqrt(-2 * math.log(nextDouble)) * math.cos(2 * math.Pi * nextDouble)
  }
  def nextInt(numDistinct:Int): Int
  def setSeed(seed:Long): Unit
}

class _ScalaUtilRandom extends RandomFactory {
  val Rand = scala.util.Random
  //override def nextGaussian = Rand.nextGaussian
  def nextDouble = Rand.nextDouble
  def setSeed(seed:Long) = Rand.setSeed(seed)
  def nextInt(numDistinct:Int) = Rand.nextInt(numDistinct)
}

class _ThreadLocalRandom extends RandomFactory {
  import java.util.concurrent.{ ThreadLocalRandom => Rand }
  //override def nextGaussian = Rand.current().nextGaussian
  def nextDouble = Rand.current.nextDouble
  def nextInt(numDistinct:Int) = Rand.current.nextInt(numDistinct)
  def setSeed(seed:Long) = Rand.current.setSeed(seed)
}



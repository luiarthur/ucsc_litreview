package Rng
object Timer{
  def msg(s: String) = print(Console.GREEN + s + Console.RESET)
  def timer[R](block: => R): R = {  
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    msg( (t1 - t0) / 1E9 + "s\n" )
    result
  }
}

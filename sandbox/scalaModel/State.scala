def arrayToString[T](a:Array[T]): String = s"Array(${a.mkString(",")})"
arrayToString(Array(2,3,4))


trait StateGeneric {
  def deepcopy: StateGeneric
}

case class State(var x:Int, var y:Double, a:Array[Int], aad:Array[Array[Double]]) extends StateGeneric{
  def deepcopy = this.copy(a=a.clone, aad=aad.map(_.clone))
  override def toString = s"State(${x},${y},${arrayToString(a)},${aad})"
}

def getAllFields[T](s:T):List[String] = {
  val fields = s.getClass.getDeclaredFields
  "\\.\\w+".r.findAllIn(fields.mkString(",")).toList.map(_.tail)
}


def matchField(f:java.lang.reflect.Field, s:String):Boolean = {
  val fExpanded = f.toString.mkString("-")
  val dollarPos = fExpanded.reverse.indexOf("$")
  val x = fExpanded.takeRight(dollarPos).replace("-", "")
  val periodIdx = x.indexOf(".")
  s == x.drop(periodIdx+1)
}

def getField[T<:StateGeneric](s:T, field:String):Any = {
  val fields = s.getClass.getDeclaredFields
  val rgx = s".${field}[^\\w]".r
  val f = fields.filter( f => matchField(f, field)).head
  f.setAccessible(true)
  f.get(s)
}

/*
 * @param state: 
 * @param update: 
 * @param monitor: use getAllFields(state) as a default
 */

type Monitor = List[Map[String, Any]]
def gibbs[T<:StateGeneric](state:T, update: T=>Unit, 
             monitors:Vector[List[String]]=Vector(),
             thins:Vector[Int]=Vector(),
             nmcmc:Int=1000, nburn:Int=0, printProgress:Boolean=true) = {

  require(monitors.size == thins.size)

  // TODO:
  // require that all thins are positive
  // require that all monitors contain valid fields
  //val allFields = getAllFields(state)
  //require(monitors.flatten.map()

  val numMoniors = if (monitors.size == 0) 1 else monitors.size

  println(s"Number of monitors: ${numMoniors}")
  val _monitor0 = if (monitors.size == 0) getAllFields(state) else monitors.head
  val _thin0 = if (monitors.size == 0) 1 else thins.head

  val _monitors = Vector.tabulate(numMoniors){_ match {
    case 0 => _monitor0
    case i:Int => monitors(i)
  }}
  val _thins = Vector.tabulate(numMoniors){ _ match {
    case 0 => _thin0
    case i:Int => thins(i)
  }}

  def engine(_nmcmc:Int, _nburn:Int, 
             _out:Vector[Monitor]): Vector[Monitor] = {

    // Update the current state.
    update(state)

    if (_nburn > 0) {
      engine(_nmcmc, _nburn - 1, _out)
    } else if (_nmcmc > 0) { // TODO: add condition to implement comment below
      val stateCopy = state.deepcopy // Try to not do this if don't have store
      val newOut = Vector.tabulate(numMoniors){ i =>
        if ((nmcmc - _nmcmc) % _thins(i) == 0) {
          val newDict = _monitors(i).map{
            field => field -> getField(stateCopy, field)
          }.toMap
          newDict :: _out(i)
        } else _out(i)
      }
      engine(_nmcmc - 1, 0, newOut)
    } else _out
  }

  engine(nmcmc, nburn, Vector.tabulate(numMoniors){_ => List()})
}

def update(s:State) = {
  s.x += 1
  s.a(0) -= 1
  s.y *= 2
}

val sa = State(0, 2.0, Array(0), Array.ofDim[Double](2,3))
val outA = gibbs(sa, nmcmc=5, update=update)

val sb = State(0, 2.0, Array(0), Array.ofDim[Double](2,3))
val outB = gibbs(sb, nmcmc=5, update=update, 
                 monitors=Vector(List("x", "a")), thins=Vector(1))

val sc = State(0, 1.0, Array(0), Array.ofDim[Double](0,0))
val outC = gibbs(sc.deepcopy, nmcmc=10, update=update, 
                 monitors=Vector(List("x", "a"), List("y")), thins=Vector(1,1))
println
outC(1).foreach(println)


/* Tests
val s = State(1, 2.0, Array(0), Array.ofDim[Double](2,3))
val s2 = s.deepcopy
s.x += 1
s.a(0) += 3
s
s2

getField(s, "x")
getField(s, "a")
getField(s, "aad").asInstanceOf[Array[Array[Double]]]
*/

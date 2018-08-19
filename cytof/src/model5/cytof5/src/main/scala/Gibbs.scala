package cytof5

object Gibbs {
  trait State {
    def deepcopy: State
  }


  type Monitor = List[Map[String, Any]]

  def fieldnames[T](s:T):List[String] = {
    val fields = s.getClass.getDeclaredFields
    val rgx = "\\.\\w+".r
    fields.map{f => rgx.findFirstIn(f.toString)}.toList.flatten.map(_.tail)
  }

  def matchField(f:java.lang.reflect.Field, s:String):Boolean = {
    val fExpanded = f.toString.mkString("-")
    val dollarPos = fExpanded.reverse.indexOf("$")
    val x = fExpanded.takeRight(dollarPos).replace("-", "")
    val periodIdx = x.indexOf(".")
    s == x.drop(periodIdx+1)
  }

  def getField[T](s:T, field:String):Any = {
    val fields = s.getClass.getDeclaredFields
    val rgx = s".${field}[^\\w]".r
    val f = fields.filter{f => matchField(f, field)}.head
    f.setAccessible(true)
    f.get(s)
  }

  def getFieldType[T](s:T, field:String):String = {
    val fields = s.getClass.getDeclaredFields
    val rgx = s".${field}[^\\w]".r
    val f = fields.filter{f => matchField(f, field)}.head
    f.toString.split(" ").dropRight(1).mkString(" ").replace("private", "").trim
  }

  /*
   * @param state: 
   * @param update: 
   * @param monitor: use fieldnames(state) as a default
   */
  def gibbs[T<:State](state:T, update: T=>Unit, 
               monitors:Vector[List[String]]=Vector(),
               thins:Vector[Int]=Vector(),
               nmcmc:Int=1000, nburn:Int=0, printProgress:Boolean=true,
               printDebug:Boolean=false) = {

    require(monitors.size == thins.size)

    // TODO:
    // require that all thins are positive
    // require that all monitors contain valid fields
    //val allFields = fieldnames(state)
    //require(monitors.flatten.map()

    val numMoniors = if (monitors.size == 0) 1 else monitors.size

    if (printDebug) {
      println(s"Number of monitors: ${numMoniors}")
    }
    val _monitor0 = if (monitors.size == 0) fieldnames(state) else monitors.head
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
      } else if (_nmcmc > 0) {
        val newOut = Vector.tabulate(numMoniors){ i =>
          if ((nmcmc - _nmcmc) % _thins(i) == 0) {
            val newDict = _monitors(i).map{
              field => field -> CloneXdArray.smartClone(getField(state, field))
            }.toMap
            newDict :: _out(i)
          } else _out(i)
        }
        engine(_nmcmc - 1, 0, newOut)
      } else _out
    }

    engine(nmcmc, nburn, Vector.tabulate(numMoniors){_ => List()})
  }
}

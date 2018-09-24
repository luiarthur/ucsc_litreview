package cytof5.experimental

trait Gibbs {
  def timer[R](block: => R) = {
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1E9 + "s")
    result
  }


  trait State {
    def deepcopy: State
  }


  type Monitor = List[Map[String, Any]]

  def fieldnames[T](x:T) = {
    lazy val fnames = x.getClass.getDeclaredFields.toList.map{ _.getName }
    // Remove artifact fieldnames containing "$"
    fnames.filterNot{ _.contains("$") }
  }


  def getField[T](x: T, fieldname: String): Any = {
    val field = x.getClass.getDeclaredField(fieldname)
    field.setAccessible(true)
    field.get(x)
  }
  /* FIXME: Not sure why this doesn't work.
  */

  /*
   * @param state: 
   * @param update: 
   * @param monitor: use fieldnames(state) as a default
   * @param doNotUpdate: list (String) of parameters to not update. An argument in function update
   */
  def gibbs[T<:State](state:T,
                      updateFunctions: List[(String, T=>Unit)],
                      monitors:Vector[List[String]]=Vector(),
                      thins:Vector[Int]=Vector(),
                      doNotUpdate:List[String]=List(),
                      nmcmc:Int=1000, nburn:Int=0, printProgress:Boolean=true,
                      printDebug:Boolean=false,
                      showTimings:Boolean=false) = {

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
      //update(state, doNotUpdate)
      updateFunctions.foreach{ case (paramName,f) =>
        if (!doNotUpdate.contains(paramName)) {
          if (showTimings) {
            print(s"${paramName}: ")
            timer{ f(state) }
          } else f(state)
        }
      }

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

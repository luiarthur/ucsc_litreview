package ass1.data

case class TrueData(data: Data, param: Param) {
  override def toString = {
    data.toString + "\n" + param.toString
  }
}

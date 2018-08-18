package cytof5

object CloneXdArray {
  def clone2dDouble(x:Array[Array[Double]]):Array[Array[Double]] = x.map(_.clone)
  def clone2dInt(x:Array[Array[Int]]) = x.map(_.clone)

  // clone 3d Array
  def clone3dDouble(x:Array[Array[Array[Double]]]) = x.map(clone2dDouble)
  def clone3dInt(x:Array[Array[Array[Int]]]) = x.map(clone2dInt)

  // clone 4d Array
  def clone4dDouble(x:Array[Array[Array[Array[Double]]]]) = x.map(clone3dDouble)
  def clone4dInt(x:Array[Array[Array[Array[Int]]]]) = x.map(clone3dInt)

  // clone 5d Array
  def clone5dDouble(x:Array[Array[Array[Array[Array[Double]]]]]) = x.map(clone4dDouble)
  def clone5dInt(x:Array[Array[Array[Array[Array[Int]]]]]) = x.map(clone4dInt)
}

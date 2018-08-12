// clone 2d Array
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


// Tests
{
  val x2d = Array.ofDim[Int](2,3)
  val x3d = Array.ofDim[Int](2,3,4)
  val x4d = Array.ofDim[Int](2,3,4,5)
  val x5d = Array.ofDim[Int](2,3,4,5,6)

  val y2d = clone2dInt(x2d)
  y2d(0)(0) += 1
  assert(y2d.head.head != x2d.head.head)

  val y3d = clone3dInt(x3d)
  y3d(0)(0)(0) += 1
  assert(y3d.head.head.head != x3d.head.head.head)

  val y4d = clone4dInt(x4d)
  y4d(0)(0)(0)(0) += 1
  assert(y4d.head.head.head.head != x4d.head.head.head.head)

  val y5d = clone5dInt(x5d)
  y5d(0)(0)(0)(0)(0) += 1
  assert(y5d.head.head.head.head.head != x5d.head.head.head.head.head)
}

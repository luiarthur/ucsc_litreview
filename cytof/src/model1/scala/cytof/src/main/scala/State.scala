package cytof 

case class State(
  var mus: Array[Array[Double]],    // J x K
  var psi: Array[Double],           // J
  var tau2: Array[Double],          // J
  var pi: Array[Array[Double]],     // I x J
  var c: Array[Double],             // J
  var d: Double, 
  var sig2: Array[Double],          // I
  var v: Array[Double],             // K
  var h: Array[Array[Double]],      // J x K
  var lam: Array[Array[Int]],       // I x N_i
  var w: Array[Array[Double]],      // I x K
  var z: Array[Array[Int]],         // J x K
  var e: Array[Array[Array[Int]]],  // I x N_i x J
  var K: Int) {
}

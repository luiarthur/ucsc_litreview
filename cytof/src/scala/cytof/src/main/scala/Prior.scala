package cytof

case class Prior (
  musThresh: Double = math.log(2), csMu: Double =1,
  mPsi: Double=0, s2Psi: Double=10, csPsi: Double=1,
  aTau2: Double=2, bTau2: Double=1, csTau2: Double=1,
  s2C: Double=10, csC: Double =1,
  mD: Double=0, s2D:Double=10, csD: Double=1,
  a_sig2:Double=2, b_sig2:Double=1, csSig2:Double=1,
  alpha: Double =1, csV: Double =1,
  G: Array[Array[Double]], csH: Double=1,
  w: Array[Double],
  kMin:Int=1, kMax:Int=15, aK:Int // 2 * a_K <= K_max - K_min
)


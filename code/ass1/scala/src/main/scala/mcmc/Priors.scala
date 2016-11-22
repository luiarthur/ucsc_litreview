package ass1.mcmc

case class Priors(aSig: Double=2.0, bSig: Double=1.0,
                  mPhi: Double=0.0, s2Phi: Double=10.0,
                  aMu: Double = 1.0, bMu: Double=1.0, csMu: Double=1.0,
                  alpha: Double=1.0, lg0: Double=>Double = (v:Double)=>0.0, 
                  csV: Double=1.0)

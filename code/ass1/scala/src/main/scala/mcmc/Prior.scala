package tumor.mcmc

class Prior(val aSig: Double=2.0, val bSig: Double=1.0,
            val mPhi: Double=0.0, val s2Phi: Double=10.0,
            val aMu: Double = 1.0, val bMu: Double=1.0, val csMu: Double=1.0,
            val alpha: Double=1.0, val lg0: Double=>Double = (v:Double)=>0.0, 
            val csV: Double=1.0, val clusterUpdates:Int=1)

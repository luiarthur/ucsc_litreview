import scala.util.matching.Regex

val constChunk = """
  Constants {
    N: Int
    J: Int
    m: Double
    s2:Double
    alpha: Array.ofDim[Double](J)
  }
"""

val dataChunk = """
  Data { //extends Constants
    y: Array.ofDim[Double](N)
  }
"""

val modelChunk = """
  Model { //extends Data
    sig2 ~ IG(a, b)
    w ~ Dirichlet(alpha)

    for (i <- 0 until N) {
      y[i] ~ Normal( mu[c[i]], sig2 )
      c[i] ~ Categorical(J, w)
    }

    for (j <- 0 until J) {
      mu[j] ~ Normal(m, s2)
    }
  }
"""

val bugsCode = s"""
BUGS Cytof {
  ${constChunk}
  ${dataChunk}
  ${modelChunk}
}
"""

def preprocess(s:String) = {
  val multipleSemiColon = """;;+""".r
  lazy val semiColonAdded = s.split("\n").map(_.trim + ";")
  var z = semiColonAdded.map(_.replace("{;","{")).filterNot(_ == ";").mkString
  "{}():~,.<+-*/".toList.foreach { c =>
    val rgx = s"\\s*\\${c}\\s*"
    z = rgx.r.replaceAllIn(z, s"${c}")
  }
  lazy val strippedComments = """\/\/[^;]*;""".r.replaceAllIn(z, "")
  multipleSemiColon.replaceAllIn(strippedComments, ";")
}

val ppBugsCode = preprocess(bugsCode)

print(ppBugsCode)

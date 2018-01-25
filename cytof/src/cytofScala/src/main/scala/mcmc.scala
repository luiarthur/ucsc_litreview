package cytof

object Mcmc {
  import math.{log, exp, pow, sqrt}

  def gibbs[T](init:T, update:T=>T, B:Int, burn:Int, printFreq:Int=0):List[T] = {
    ???
  }

  def logit(p:Double):Double = log(p) - log(1-p)
  def logistic(x:Double):Double = 1 / (1 + exp(-x))

  def metropolis(curr:Double, ll:Double=>Double, lp:Double=>Double, cs:Double) = {
    ???
  }

  def metLogit(curr:Double, ll:Double=>Double, lp:Double=>Double, cs:Double) = {
    ???
  }

  def metropolisMV = ???
}


#sim_M <- function(m, w2) {
#  exp(rnorm(1, log(m), sqrt(w2)))
#}

#sim_m <- function(mn, mx, c) {
#  discrete <- (c > runif(1))
#  if (discrete) {
#    out <- sample(floor(mn):floor(mx), 1)
#    ifelse(out==0, sim_m(mn,mx,c), out)
#  } else runif(1, mn, mx)
#}

sim_logN1OverN0 <- function(phi, mu, m, s2, n) {
  avg <- log((2*(1-mu) + mu*m)/2) + phi
  rnorm(n, avg, sqrt(s2))
}

genData <- function(phi_mean, phi_var, mu, sig2,
                    meanN0=30, minM=0, maxM=5, c=.5,
                    w2=1, set_v, numLoci) {
  vec <- 1:numLoci
  phi <- rnorm(numLoci, phi_mean, sqrt(phi_var))
  N0 <- 1 + rpois(numLoci, meanN0)
  m <- runif(numLoci, minM, maxM)
  M <- exp( rnorm(numLoci, log(m), sqrt(w2)) )
  logN1OverN0 <- sim_logN1OverN0(phi, mu, m, sig2, numLoci)
  N1 <- floor(exp(logN1OverN0 + log(N0))) + 1
  v <- sample(unique(set_v), numLoci, replace=TRUE)

  p <- mu * v * m / (2*(1-mu) + mu*m)
  #n1 <- sapply(rbinom(numLoci, N1, p), function(ps) max(1,ps))
  n1 <- rbinom(numLoci, N1, p)

  obs <- list("n1"=n1, "N1"=N1, "N0"=N0, "M"=M)
  param <- list("mu"=mu,"phi"=phi,"m"=m,"w2"=w2,"v"=v,"sig2"=sig2)

  list("obs"=obs, "param"=param)
}


sim_p <- function(mu, v, m) {
  mu * v * m / (2*(1-mu) + mu*m)
}

sim_M <- function(m, w2) {
  exp(rnorm(1, log(m), sqrt(w2)))
}

sim_phi <- function(m, phi_var) {
  rnorm(1, m, sqrt(phi_var) )
}

sim_m <- function(mn, mx, c) {
  discrete <- (c > runif(1))
  if (discrete) {
    out <- sample(floor(mn):floor(mx), 1)
    ifelse(out==0, sim_m(mn,mx,c), out)
  } else runif(1, mn, mx)
}

sim_logN1OverN0 <- function(phi, mu, m, s2) {
  avg <- log((2*(1-mu) + mu*m)/2) + phi
  rnorm(1, avg, sqrt(s2))
}

sim_N0 <- function(meanN0) {
  out <- rpois(1,meanN0)
  ifelse(out>0, out, simN0(meanN0))
}

sim_N1 <- function(N0, logN1OverN0) {
  out <- floor(exp(logN1OverN0) * N0)
  ifelse(out>0, out, 1)
}

sim_n1 <- function(N1, p) { 
  rbinom(length(N1),N1,p) 
}

sim_v <- function(set_v, n) {
  sample(unique(set_v), n, replace=TRUE)
}

genData <- function(phi_mean, phi_var, mu, sig2,
                    meanN0=30, minM=0, maxM=5, c=.5,
                    w2=1, set_v, numLoci) {
  vec <- 1:numLoci
  phi <- sapply(vec, function(i) sim_phi(phi_mean, phi_var))
  N0 <- sapply(vec, function(i) sim_N0(meanN0))
  m <- sapply(vec, function(i) sim_m(minM,maxM,c))
  M <- sapply(m, function(ms) sim_M(ms, w2))
  x <- sapply(vec, function(s) 
              sim_logN1OverN0(phi[s], mu, m[s], sig2))
  N1 <- sapply(vec, function(s) sim_N1(N0[s],x[s]))
  v <- sim_v(set_v,numLoci)
  p <- sim_p(mu,v,m)
  n1 <- sim_n1(N1, p)

  obs <- list("n1"=n1, "N1"=N1, "N0"=N0, "M"=M)
  param <- list("mu"=mu,"phi"=phi,"m"=m,"w2"=w2,"v"=v,"sig2"=sig2)

  list("obs"=obs, "param"=param)
}

#dat <- genData(phi_mean=0, phi_var=1, mu=.6, sig2=.1,
#               meanN0=30, minM=0, maxM=5, c=.5,
#               w2=1, set_v=c(.1,.5,.9), numLoci=10)


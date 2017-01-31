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

gen_m <- function(n, mn, mx, mu, sd) {
  out <- double(n)
  sapply(out, function(dummy) {
         x <- rnorm(1,mu,sd)
         while (x < mn || x > mx) { x <- rnorm(1,mu,sd) }
         x
  })
}

genData <- function(phi_mean=0, phi_var=.1, mu, sig2,
                    meanN0=30, minM=0, maxM=5,
                    m_mean=2, m_sd=.5,
                    w2=1, set_v, v_sd=0, numLoci) {
  vec <- 1:numLoci
  phi <- rnorm(numLoci, phi_mean, sqrt(phi_var))
  N0 <- 1 + rpois(numLoci, meanN0)
  m <- gen_m(numLoci, minM, maxM, m_mean, m_sd)
  M <- exp( rnorm(numLoci, log(m), sqrt(w2)) )
  logN1OverN0 <- sim_logN1OverN0(phi, mu, m, sig2, numLoci)
  N1 <- floor(exp(logN1OverN0 + log(N0))) + 1
  v <- sample(unique(set_v), numLoci, replace=TRUE) + 
       ifelse(rep(v_sd>0,numLoci), rnorm(numLoci,0,v_sd), 0)

  p <- mu * v * m / (2*(1-mu) + mu*m)
  #n1 <- sapply(rbinom(numLoci, N1, p), function(ps) max(1,ps))
  n1 <- rbinom(numLoci, N1, p)

  obs <- list("n1"=n1, "N1"=N1, "N0"=N0, "M"=M)
  param <- list("mu"=mu,"phi"=phi,"m"=m,"w2"=w2,"v"=v,"sig2"=sig2)

  list("obs"=obs, "param"=param)
}


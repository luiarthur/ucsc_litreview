require(truncnorm)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
system.time(sourceCpp("cpp/cytof_fix_K.cpp"))

cytof_fixed_K <- function(y,
                  mus_thresh=log(2), cs_mu=1,
                  m_psi=2, s2_psi=1, cs_psi=1,
                  a_tau=2, b_tau=1, cs_tau2=1,
                  s2_c=10, cs_c=1,
                  m_d=0, s2_d=10, cs_d=1,
                  a_sig=2, b_sig=1, cs_sig2=1,
                  alpha=1, cs_v=1,
                  G=diag(ncol(y[[1]])), cs_h=1,
                  a_w=1, K,
                  window=100, target=.25, tt=max(1.1, window/50),
                  B=2000, burn=5000, print_freq=10) {

  J <- ncol(y[[1]])
  I <- length(y)
  if (length(cs_mu) == 1) cs_mu <- rep(cs_mu, J)
  if (length(cs_psi) == 1) cs_psi <- rep(cs_psi, J)
  if (length(cs_tau2) == 1) cs_tau2 <- rep(cs_tau2, J)
  if (length(cs_sig2) == 1) cs_sig2 <- rep(cs_sig2, I)
  cytof_fix_K_fit(y,
                  mus_thresh, cs_mu,
                  m_psi, s2_psi, cs_psi,
                  a_tau, b_tau, cs_tau2,
                  s2_c, cs_c,
                  m_d, s2_d, cs_d,
                  a_sig, b_sig, cs_sig2,
                  alpha, cs_v,
                  G, cs_h, 
                  a_w,
                  K,
                  window, target, tt,
                  B, burn, print_freq)

}


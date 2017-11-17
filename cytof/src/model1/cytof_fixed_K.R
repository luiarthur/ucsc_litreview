require(truncnorm)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
compile_time <- system.time(sourceCpp("cpp/cytof_fix_K.cpp"))
print(paste("Compilation time: ", compile_time[3]))

cytof_fixed_K <- function(y,
                  mus_thresh=log(2), cs_mu=1,
                  m_psi=2, s2_psi=4, cs_psi=1,
                  a_tau=3, b_tau=2, cs_tau2=1,
                  a_sig=3, b_sig=2, cs_sig2=1,
                  s2_c=10, cs_c=1,
                  m_d=0, s2_d=10, cs_d=1,
                  alpha=1, cs_v=1,
                  G=diag(ncol(y[[1]])), cs_h=1, cs_hj=cs_h/10,
                  a_w=1, K,
                  ### For debugging
                  true_mus=NULL, true_psi=NULL,
                  true_tau2=NULL,true_sig2=NULL,
                  true_Z=NULL, true_lam=NULL,
                  true_W=NULL, true_pi=NULL,
                  ###
                  window=100, target=.25, tt=max(1.1, window/50),
                  B=2000, burn=5000, thin=1, 
                  compute_loglike_every=100, print_freq=10) {

  J <- ncol(y[[1]])
  I <- length(y)
  if (length(cs_mu) == 1) cs_mu <- matrix(cs_mu, J, K)
  if (length(cs_psi) == 1) cs_psi <- rep(cs_psi, J)
  if (length(cs_tau2) == 1) cs_tau2 <- rep(cs_tau2, J)
  if (length(cs_sig2) == 1) cs_sig2 <- rep(cs_sig2, I)

  ### Require that computation of loglike be between 0 and B
  stopifnot(compute_loglike_every >=0 && compute_loglike_every <=B)

  cytof_fix_K_fit(y,
                  mus_thresh, cs_mu,
                  m_psi, s2_psi, cs_psi,
                  a_tau, b_tau, cs_tau2,
                  s2_c, cs_c,
                  m_d, s2_d, cs_d,
                  a_sig, b_sig, cs_sig2,
                  alpha, cs_v,
                  G, cs_h, cs_hj,
                  a_w,
                  K,
                  ### For debugging
                  true_mus, true_psi,
                  true_tau2,true_sig2,
                  true_Z, true_lam,
                  true_W, true_pi,
                  ###
                  window, target, tt,
                  B, burn, thin, compute_loglike_every, print_freq)

}


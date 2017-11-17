require(truncnorm)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
system.time(sourceCpp("cpp/cytof.cpp"))

cytof <- function(y_TE, y_TR,
                  mus_thresh=log(2), cs_mu=1,
                  m_psi=0, s2_psi=10, cs_psi=1,
                  a_tau=2, b_tau=1, cs_tau2=1,
                  s2_c=10, cs_c=1,
                  m_d=0, s2_d=10, cs_d=1,
                  a_sig=2, b_sig=1, cs_sig2=1,
                  alpha=1, cs_v=1,
                  G=diag(ncol(y_TE[[1]])), cs_h=1,
                  a_w=1,
                  K_min=1, K_max=15, a_K=1,
                  burn_small=3000,
                  B=2000, burn=5000, print_freq=10) {

  stopifnot(2*a_K <= K_max - K_min + 1) # require step size small enough
  stopifnot(length(y_TE) == length(y_TR)) # require the same "I" for both
  I <- length(y_TE)
  J <- ncol(y_TE[[1]])
  if (length(cs_mu) == 1) cs_mu <- rep(cs_mu, J)
  if (length(cs_psi) == 1) cs_psi <- rep(cs_psi, J)
  if (length(cs_tau2) == 1) cs_tau2 <- rep(cs_tau2, J)
  if (length(cs_sig2) == 1) cs_sig2 <- rep(cs_sig2, I)

  cytof_fit(y_TE, y_TR, 
            mus_thresh, cs_mu,
            m_psi, s2_psi, cs_psi,
            a_tau, b_tau, cs_tau2,
            s2_c, cs_c,
            m_d, s2_d, cs_d,
            a_sig, b_sig, cs_sig2,
            alpha, cs_v,
            G, cs_h, 
            a_w,
            K_min, K_max, a_K,
            burn_small,
            B, burn, print_freq)

}

extend_mat <- function(X, final_cols) {
  ncol_X <- NCOL(X)
  nrow_X <- NROW(X)
  stopifnot(NCOL(X) <= final_cols)
  cbind(X, matrix(0, nrow_X, final_cols - ncol_X))
}

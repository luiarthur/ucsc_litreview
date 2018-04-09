gen_default_prior = function(J, K=10, L0=10, L1=10) {
  #' Generate default prior
  #' @examples prior = gen_default_prior(J=32, K=10, L0=10, L1=10)
  #' @export
  #' @note
  #' TODO:\cr
  #' - CHECK: a_sig, a_s, b_s. \cr
  #' - Think of good priors for: alpha (a_alpha, b_alpha) \cr
  list(
    c0 = -2, #double
    c1 = 6.7, #double
    m_beta0 = 4.6, #double
    s2_beta0 = .01, #double
    cs_beta0 = 1, #double
    a_beta1 = 288, #double
    b_beta1 = 170, #double
    cs_beta1 = 1, #double
    cs_y = 1, #double
    psi_0 = -2, #double
    psi_1 = 2, #double
    tau2_0 = .1, #double
    tau2_1 = 1, #double
    a_sig = 3, #double
    a_s = 3, #double
    b_s = 3, #double
    a_eta0 = 1 / L0, #double
    a_eta1 = 1 / L1, #double
    cs_v = 1, #double
    a_alpha = 3, #double
    b_alpha = 2, #double
    cs_h = 1, #double
    G = diag(J), #arma::mat
    d_W = 1/K, #double
    K = K #int
  )
}

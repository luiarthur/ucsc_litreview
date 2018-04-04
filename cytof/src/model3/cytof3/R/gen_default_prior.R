#' Generate default prior
#' @example 
#' prior = gen_default_prior(J=32, K=10, L0=10, L1=10)
#' @export
gen_default_prior = function(J, K=10, L0=10, L1=10) {
  list(
    K=K,
    c0 = -2, c = 6.7,
    m_beta0 = 4.6, s2_beta0=.01, cs_beta0 = 1,
    a_beta1 = 288, b_beta1 = 170, cs_beta1 = 1,
    psi_0 = -2,  psi_1 = 2,
    tau2_0 = .1, tau2_1 = 1,
    a_sig = 3, # TODO: Check this
    a_s = 3, b_s = 3, # TODO: Check this
    a_eta0 = 1 / L0,
    a_eta1 = 1 / L1,
    a_alpha = 3, # TODO: Think of good  priors
    b_alpha = 2, # TODO: Think of good priors
    cs_h = 1,
    G = diag(J),
    d_W = 1/K
  ) 
}
gen_default_init = function(prior) {
  #' Generate default init
  #' @examples init = gen_default_init(y, prior, K=10, L0=10, L1=10)
  #' @param prior   List of priors (from gen_default_prior(y))
  #' @export

  J = prior$J
  N = prior$N
  L0 = prior$L0
  L1 = prior$L1
  K = prior$K
  I = prior$I

  y_init = lapply(y, function(yi) {
    idx = which(is.na(yi), arr=TRUE)
    yi[idx] = 0
    yi
  })

  list(
    beta_0    = rep(prior$m_beta0),
    beta_1    = rep(prior$a_beta1 / prior$b_beta1),
    missing_y = y_init,
    mus_0     = rep(prior$psi_0, L0),
    mus_1     = rep(prior$psi_1, L1),
    sig2_0    = matrix(1, I, L0),
    sig2_1    = matrix(1, I, L1),
    s         = rep(prior$a_s / prior$b_s, I),
    gam       = lapply(N, function(Ni) matrix(0, nrow=Ni, ncol=J)),
    eta_0     = array(1 / L0, c(I,J,L0)),
    eta_1     = array(1 / L1, c(I,J,L1)),
    v         = rep(1/K, K),
    alpha     = 1.0,
    H         = matrix(0, J, K),
    Z         = matrix(sample(0:1, J*K, replace=TRUE), J, K),
    lam       = lapply(N, function(Ni) double(Ni)),
    W         = matrix(1/K, I, K)
  ) 
}

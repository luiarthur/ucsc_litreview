gen_default_prior = function(y, K=10, L0=10, L1=10) {
  #' Generate default prior
  #' @param y   List of matrices with same number of columns
  #' @param K   Maximum number of cell-types
  #' @param L0  number of mixture components for unexpressed markers
  #' @param L1  number of mixture components for expressed markers
  #' @examples prior = gen_default_prior(J=32, K=10, L0=10, L1=10)
  #' @export
  #' @note
  #' TODO:\cr
  #' - CHECK: a_sig, a_s, b_s. \cr
  #' - Think of good priors for: alpha (a_alpha, b_alpha) \cr

  ### Make sure that all y[[i]] have same number of columns
  stopifnot(length(unique(sapply(y, NCOL))) == 1)


  J = NCOL(y[[1]])
  N = lapply(y, NROW)
  I = length(N)

  list(
    c0 = -2, #double
    c1 = 6.7, #double
    m_beta0 = 4.6, #double
    s2_beta0 = .01, #double
    cs_beta0 = 1, #double
    m_beta1 = .55, #double
    s2_beta1 = .01, #double
    cs_beta1 = 1, #double
    cs_y = 1, #double
    psi_0 = -2, #double
    psi_1 = 2, #double
    tau2_0 = .1, #double
    tau2_1 = 1, #double
    sig2_max = Inf, #double
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
    K = K, #int
    ### Not in struct Prior
    K         = K,
    L0        = L0,
    L1        = L1,
    J         = J,
    N         = N,
    I         = I
  )
}

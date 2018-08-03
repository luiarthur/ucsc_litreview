#' Generate Nimble model constants
#'
#' TODO: document
#' @export
model.consts = function(y, N, K=10, L=5, b_prior=NULL) {
  if (is.null(b_prior)) {
    b_prior = solve_miss_mech_params(y=c(min(y,na.rm=TRUE), -.1), p=c(.99,.0001))
  }
  J = NCOL(y)
  I = length(N)

  idxOffset = c(0, cumsum(N[-I]))
  get_i = double(sum(N))
  counter = 0

  for (i in 1:I) for (n in 1:N[i]) {
    counter = counter + 1
    get_i[counter] = i
  }


  list(N=N, J=J, I=I, K=K, N_sum=sum(N), 
       idxOffset=idxOffset, get_i=get_i,
       h_mean=rep(0,J), h_cov=diag(J),
       L=L,
       a_eta0=rep(1/L,L), a_eta1=rep(1/L,L),
       psi_0=mean(y[y<0], na.rm=TRUE), tau2_0=var(y[y<0], na.rm=TRUE), 
       psi_1=mean(y[y>0], na.rm=TRUE), tau2_1=var(y[y>0], na.rm=TRUE),
       a_alpha=1, b_alpha=1,
       a_sig=3, b_sig=2, d_W=rep(1/K,K),
       m_b1=b_prior[1], s2_b1=.1,
       m_b0=b_prior[2], s2_b0=.1)
}

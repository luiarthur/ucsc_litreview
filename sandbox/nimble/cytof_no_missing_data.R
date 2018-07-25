library(nimble)
library(cytof3)

### Simulate Data ###
dat = sim_dat(I=3, J=32, N=c(300,100,200), K=4, L0=3, L1=5)
y_complete = dat$y_complete
y = Reduce(rbind, y_complete)
N = sapply(y_complete, NROW)
I = length(y_complete)
J = NCOL(y)
idxOffset = c(0, cumsum(N[-I]))

### Nimble Code ###
model = nimbleCode({
  for (k in 1:K) {
    v[k] ~ dbeta(alpha/K, 1)
    h[1:J, k] ~ dmnorm(h_mean, h_cov)
    for (j in 1:J) {
      z[j,k] <- #TODO
    }
  }
  
  alpha ~ dgamma(a_alpha, b_alpha)

  for (l in 1:L0) {
    mus_0 ~ dnorm(psi_0, var=tau2_0)
  }
  for (l in 1:L1) {
    mus_1 ~ dnorm(psi_1, var=tau2_1)
  }

  for (i in 1:I) {
    W[i,1:K] ~ ddirch(d_W)
    sig2[i] ~ dinvgamma(a_sig, b_sig)
    for (j in 1:J) {
      eta_0[i, j, 1:L0] ~ ddirch(a_eta0)
      eta_1[i, j, 1:L1] ~ ddirch(a_eta1)

      # Likelihood
      for (n in 1:N[i]) {
        y[idxOffset[i] + n, j] ~ #TODO
        lam[idxOffset[i] + n] ~ dcat(W[i,1:K])  
      }
    }
  }
})


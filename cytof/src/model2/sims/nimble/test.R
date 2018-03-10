library(nimble)

### READ DATA ###
load("../dat/cytof_cb.RData")
y_orig = y
for (i in 1:length(y)) {
  for (j in 1:NCOL(y[[i]])) {
    miss_idx = which(is.na(y[[i]][,j]))

    neg_yj = which(y[[i]][,j] < 0)
    y[[i]][miss_idx,j] = sample(y[[i]][neg_yj,j], size=length(miss_idx), replace=TRUE)
  }
}

dlike = nimbleFunction(
  run = function(x=double(0), mus_0ij=double(0), mus_1ij=double(0), 
                 Z_j=integer(1), gams_0ij=double(0),
                 sig2_ij=double(0), K=integer(0), W_i=double(1),
                 log=integer(0, default=0)) {
    returnType(double(0))

    fm = 0
    for (k in 1:K) {
      g = gams_0ij * (1-Z_j[k])
      fm = fm + W_i[k] * dnorm(x,
                               mus_0ij * (1-Z_j[k]) + mus_1ij * Z_j[k],
                               sqrt(sig2_ij * (1 + g)));
    }
     
    if (log) return(log(fm)) else return(fm)
  }
)

registerDistributions(list(
  dlike = list(
    BUGSdist = "dlike(mus_0ij, mus_1ij, Z_j, gams_0ij, sig2_ij, K, W_i)",
    Rdist = "dlike(mus_0ij, mus_1ij, Z_j, gams_0ij, sig2_ij, K, W_i)",
    range=c(-Inf,Inf)
  )
))

### Define the model ###
cytof = nimbleCode({
  psi0 ~ T(dnorm(-1.5, .1), -10, 0)
  psi1 ~ T(dnorm(1.5, .1), 0, 10)
  tau2_0 ~ dinvgamma(3, rate=2)
  tau2_1 ~ dinvgamma(3, rate=2)

  for (i in 1:I) {
    for (j in 1:J) {
      gam2_0[i,j] ~ dinvgamma(3,rate=2)
      sig2[i,j] ~ dinvgamma(3, rate=2)
      mus_0[i,j] ~ T(dnorm(psi0, sqrt(tau2_0)), -10, 0)
      mus_1[i,j] ~ T(dnorm(psi1, sqrt(tau2_1)), 0, 10)
    }
  }

  for (k in 1:K) {
    v[k] ~ dbeta(1, 1)
    for (j in 1:J) {
      #H[j,k] ~ dnorm(0, 1)
      #Z[j,k] = ifelse(prod(v[1:k]) > pnorm(H[j,k]), 1, 0)

      ### FIXME
      #Z[j,k] ~ dbern(cumprod(v)[k])
      Z[j,k] ~ dbern(v[k])
    }
  }

  for (i in 1:I) {
    W[i, 1:K] ~ ddirch(d[1:K])
    #for (n in 1:N[i]) {
    for (n in N_lower[i]:N_upper[i]) {
      #lam[n] ~ dcat(W[i, 1:K])
      #lin <- lam[n]

      for (j in 1:J) {
        #s2 <- (gam2_0[i,j] * (1 - Z[j,lin]) + 1) * sig2[i,j]
        #YY[n,j] ~ dnorm(mus_1[i,j] * Z[j,lin] + mus_0[i,j] * (1-Z[j,lin]), sqrt(s2))
        YY[n,j] ~ dlike(mus_0[i,j], mus_1[i,j], Z[j,1:K], gams_0[i,j], sig2[i,j], 
                        K, W[i,1:k])
      }
    }
  }
})

### Define the data ###
Y = cytof2::resample(y, prop=.01)
YY = do.call(rbind, Y)
data = list(YY=YY)

### Define the constants ###
N = sapply(Y,NROW)
N_pad = c(0, cumsum(N)[-length(N)])
N_lower = N_pad + 1
N_upper = cumsum(N)
constants = list(K=10, N=N, N_lower=N_lower, N_upper=N_upper,
                 I=length(Y), J=NCOL(Y[[1]]), d=rep(1/10, 10))

### Define Dimensions ###
#dimensions = list(Z=c(32,10), W=c(3,10), lam=NROW(YY))
dimensions = list(Z=c(32,10), W=c(3,10))

mod = nimbleModel(code=cytof, check=FALSE,
                  data=data, constants=constants, dimensions=dimensions)

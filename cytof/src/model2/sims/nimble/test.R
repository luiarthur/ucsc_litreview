library(nimble)

### READ DATA ###
load("../dat/cytof_cb.RData")
y_orig = y
y = cytof2::preimpute(y, 0)

dlike = nimbleFunction(
  run = function(x=double(0),
                 mus_0ij=double(0), mus_1ij=double(0), 
                 Z_j=integer(1), gams_0ij=double(0),
                 sig2_ij=double(0), W_i=double(1),
                 log=integer(0, default=0)) {
    returnType(double(0))

    g <- gams_0ij * (1-Z_j)
    fm <- W_i * dnorm(x,
                      mus_0ij * (1-Z_j) + mus_1ij * Z_j,
                      sqrt(sig2_ij * (1 + g)))
    sum_fm <- sum(fm)
     
    if (log) return(log(sum_fm)) else return(sum_fm)
  }
)

registerDistributions(list(
  dlike = list(
    BUGSdist = "dlike(mus_0ij, mus_1ij, Z_j, gams_0ij, sig2_ij, W_i)",
    range=c(-Inf,Inf),
    types=c('Z_j=integer(1)', 'W_i=double(1)')
  )
))

### Define the model ###
cytof = nimbleCode({
  #psi0 ~ T(dnorm(-1.5, .1), -10, 0)
  #psi1 ~ T(dnorm(1.5, .1), 0, 10)
  #tau2_0 ~ dinvgamma(3, rate=2)
  #tau2_1 ~ dinvgamma(3, rate=2)

  for (i in 1:I) {
    for (j in 1:J) {
      gams_0[i,j] ~ dinvgamma(3,rate=2)
      sig2[i,j] ~ dinvgamma(3, rate=2)
      mus_0[i,j] ~ dunif(-5, -1)#T(dnorm(psi0, sqrt(tau2_0)), -10, 0)
      mus_1[i,j] ~ dunif(1, 5)#T(dnorm(psi1, sqrt(tau2_1)), 0, 10)
    }
  }

  for (k in 1:K) {
    v[k] ~ dbeta(1, 1)
    p[k] <- prod(v[1:k])
    for (j in 1:J) {
      #H[j,k] ~ dnorm(0, 1)
      #Z[j,k] = ifelse(prod(v[1:k]) > pnorm(H[j,k]), 1, 0)

      ### FIXME
      #Z[j,k] ~ dbern(cumprod(v)[k])
      #Z[j,k] ~ dbern(v[k])
      #Z[j,k] ~ dbern(prod(v[1:k]))

      Z[j,k] ~ dbern(p[k])
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
        #YY[n,j] ~ dlike(mus_0[i,j], mus_1[i,j], Z[j,1:K], gams_0[i,j], sig2[i,j], 
        #                W[i,1:K])
        YY[n,j] ~ dnorm(mus_0[i,j], sig2[i,j])
      }
    }
  }
})

### Define the data ###
Y = cytof2::resample(y, prop=.01)
YY = do.call(rbind, Y)
markers = colnames(YY)
data = list(YY=YY)
#K = 10
K = 4
J = NCOL(Y[[1]])
I = length(Y)

### Define the constants ###
N = sapply(Y,NROW)
N_pad = c(0, cumsum(N)[-length(N)])
N_lower = N_pad + 1
N_upper = cumsum(N)
constants = list(K=K, N=N, N_lower=N_lower, N_upper=N_upper,
                 I=I, J=J, d=rep(1/K, K))

### Define Dimensions ###
#dimensions = list(Z=c(32,10), W=c(3,10), lam=NROW(YY))
dimensions = list(Z=c(J,K), W=c(I,K), v=K,
                  mus_0=c(I,J), mus_1=c(I,J),
                  gams_0=c(I,J), sig2=c(I,J))
inits = list(v=rep(1/K, K), Z=matrix(0,J,K),
             mus_0=matrix(-2, I, J), mus_1=matrix(2, I, J),
             gams_0=matrix(1, I, J),  sig2=matrix(1, I, J),
             W=matrix(1/K, I, K))

mod = nimbleModel(code=cytof, check=TRUE, #inits=inits,
                  data=data, constants=constants, dimensions=dimensions)

simulate(mod)
cmod = compileNimble(mod, showCompilerOutput=TRUE)

#mcmc.out <- nimbleMCMC(code = mod, nchains = 1, niter = 100,
#                       summary = TRUE, WAIC = TRUE)
#names(mcmc.out)

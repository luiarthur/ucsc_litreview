library(cytof3)
library(rcommon)
library(nimble)
set.seed(1)

pad_zeros = function(y_list) {
  K = NCOL(y_list[[1]])
  row_max = max(sapply(y_list, NROW))
  new_y_list = lapply(y_list, function(y) {
    if (NROW(y) < row_max) {
      rbind(y, matrix(0, row_max-NROW(y), K))
    } else y
  })
  simplify2array(new_y_list)
}

#y_ls = list(matrix(1,2,5), matrix(2,3,5), matrix(3,1,5))
#pad_zeros(y_ls)

### Nimble Code ###
model.code = nimbleCode({
  for (k in 1:K) {
    v[k] ~ dbeta(alpha/K, 1)
    H[1:J, k] ~ dmnorm(h_mean[1:J], h_cov[1:J,1:J])
    Z[1:J, k] <- 1 + (pnorm(H[1:J, k]) < v[k])
  }

  alpha ~ dgamma(a_alpha, b_alpha)

  for (l in 1:L) {
    # TODO: order, use truncated normal
    # mus_0
    mus[1,l] ~ dunif(-20,0) #T(dnorm(psi_0, var=tau2_0), -100, 0)
    # mus_1
    mus[2,l] ~ dunif(0,20) #T(dnorm(psi_1, var=tau2_1), 0, 100)
  }

  for (i in 1:I) {
    W[i,1:K] ~ ddirch(d_W[1:K])
    sig2[i] ~ dinvgamma(a_sig, b_sig)
    for (j in 1:J) {
      eta[1, i, j, 1:L] ~ ddirch(a_eta0[1:L]) # eta_0
      eta[2, i, j, 1:L] ~ ddirch(a_eta1[1:L]) # eta_1
    }
  }

  # Likelihood
  for (n in 1:N_sum) {
    lam[n] ~ dcat(W[get_i[n], 1:K])  
    for (j in 1:J) {
      gam[n, j] ~ dcat(eta[Z[j, lam[n]], get_i[n], j, 1:L])
      y[n, j] ~ dnorm(mus[Z[j, lam[n]], gam[n, j]], var=sig2[get_i[n]])
    }
  }
})

### Simulate Data ###
dat = sim_dat(I=3, J=8, N=c(3,1,2)*1000, K=4, L0=3, L1=5)
y_complete = dat$y_complete
y = Reduce(rbind, y_complete)
N = sapply(y_complete, NROW)
N_sum = sum(N)
I = length(y_complete)
J = NCOL(y)
idxOffset = c(0, cumsum(N[-I]))
get_i = double(N_sum); counter = 0
for (i in 1:I) for (n in 1:N[i]) {
  counter = counter + 1
  get_i[counter] = i
}

K = 10
L = 5
model.consts = list(N=N, J=J, I=I, K=K, N_sum=N_sum, 
                    idxOffset=idxOffset, get_i=get_i,
                    h_mean=rep(0,J), h_cov=diag(J),
                    L=L,
                    a_eta0=rep(1/L,L), a_eta1=rep(1/L,L),
                    psi_0=0, psi_1=0, tau2_0=1, tau2_1=1,
                    a_alpha=1, b_alpha=1,
                    a_sig=3, b_sig=2, d_W=rep(1/K,K))
model.data = list(y=y)
model.inits = list(gam=matrix(1, sum(N), J),
                   lam=rep(1,sum(N)),
                   #z=matrix(0,J,K),
                   H=matrix(rnorm(J*K),J,K),
                   W=matrix(1/K, I, K),
                   v=rep(1/K,K),
                   alpha=1,
                   sig2=rep(1,I),
                   eta=array(1/L, dim=c(2,I,J,L)),
                   mus=rbind(rep(-3,L), rep(3,L)))

model = nimbleModel(model.code, data=model.data, 
                    constants=model.consts, inits=model.inits)
model$simulate()
#model$initializeInfo()
cmodel = compileNimble(model)

B=200
nsamps2=1

model.conf = configureMCMC(model, print=TRUE)
model.conf$addMonitors(c('Z'))
model.conf$addMonitors2(c('lam'))
model.conf$thin2 = B / nsamps2

model.mcmc = buildMCMC(model.conf)
cmodel = compileNimble(model.mcmc, project=model)
burn=2000
time_100_iters = system.time(runMCMC(cmodel, summary=TRUE, niter=100, nburnin=0))
seconds_one_iter = time_100_iters[3] / 100
estimated_time = seconds_one_iter * (B+burn)
print("Estimated time:")
print(estimated_time)
time_model = system.time(
  out <- runMCMC(cmodel, summary=TRUE, niter=B+burn, nburnin=burn, setSeed=1)
)
print(time_model)


### Summary ###
#plotPosts(out$samples)
get_param = function(name, out_samples) {
  which(sapply(colnames(out_samples), function(cn) grepl(name, cn)))
}

lam.cols = get_param('lam', out$samples2)
lam_last = out$samples2[,lam.cols]
ari(lam_last, c(unlist(dat$lam)))
table(lam_last, c(unlist(dat$lam)))

W.cols = get_param('W', out$samples)
my.image(matrix(out$summary[W.cols,1], I, K), col=greys(10), zlim=c(0,.1),
         addL=T, color.bar.dig=2)

Z.cols= get_param('Z', out$samples)
Z.mean = matrix(out$summary[Z.cols,1], J, K) - 1
my.image(matrix(out$summary[Z.cols,1], J, K))

H.cols = get_param('H', out$samples)
my.image(matrix(out$summary[H.cols,1], J, K), col=blueToRed(11), addL=T, zlim=c(-3,3))

sig2.cols = get_param('sig2', out$samples)
sig2_post = out$samples[, sig2.cols]
plotPosts(sig2_post)

#out$samples2[, lam.cols]
            

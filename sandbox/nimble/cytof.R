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

# p.78 of nimble manual: llFun
# p.83 of nimble manual: MCMC suite
# p.166 of nimble manual: targetLL

### Nimble Code ###
model.code = nimbleCode({
  for (k in 1:K) {
    v[k] ~ dbeta(alpha/K, 1)
    for (j in 1:J) {
      Z0[j, k] ~ dbern(v[k])
      Z[j, k] <- Z0[j, k] + 1
    }
  }

  alpha ~ dgamma(a_alpha, b_alpha)

  for (l in 1:L) {
    # mus_0
    mus[1,l] ~ T(dnorm(psi_0, var=tau2_0), -30, 0)
    # mus_1
    mus[2,l] ~ T(dnorm(psi_1, var=tau2_1), 0, 30)
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
      m[n, j] ~ dbern(p[n, j])
      logit(p[n, j]) <- b0 + b1 * y[n, j]
    }
  }

  b0 ~ dnorm(m_b0, var=s2_b0)
  b1 ~ dnorm(m_b1, var=s2_b1)
            
  # Constrains mu to be in ascending order
  # TODO: These make sampling a little harder
  #       Can I remove them at the expense of less identifiability?
  constraints_mus0 ~ dconstraint( prod(mus[1, 1:(L-1)] <= mus[1, 2:L]) )
  constraints_mus1 ~ dconstraint( prod(mus[2, 1:(L-1)] <= mus[2, 2:L]) )
})

### util functions ###
logit = function(p) log(p) - log(1-p)
sigmoid = function(x) 1 / (1 + exp(-x))
solve_b = function(y, p) {
  stopifnot(length(y) == 2 && length(p) == 2)
  b1 = diff(logit(p)) / diff(y)
  b0 = logit(p[1]) - b1 * y[1]
  c(b0, b1)
}

### Simulate Data ###
dat = sim_dat(I=3, J=8, N=c(3,1,2)*100, K=4, L0=3, L1=5)

### TODO: Try these data###
#dat = sim_dat(I=3, J=8, N=c(3,1,2)*100, K=4, L0=3, L1=5, Z=genZ(J=8,K=4))
#dat = sim_dat(I=3, J=8, N=c(3,1,2)*1000, K=4, L0=3, L1=5)
#dat = sim_dat(I=3, J=8, N=c(3,1,2)*1000, K=4, L0=3, L1=5, Z=genZ(J=8,K=4))
#dat = sim_dat(I=3, J=8, N=c(3,1,2)*10000, K=4, L0=3, L1=5)
#dat = sim_dat(I=3, J=8, N=c(3,1,2)*10000, K=4, L0=3, L1=5, Z=genZ(J=8,K=4))
# TODO: try block sampling mus. How do you block sample a matrix of params?
# TODO: try removing  ordering constraints for mus

y_complete = dat$y_complete
#y = Reduce(rbind, y_complete)
y = Reduce(rbind, dat$y)
m = is.na(y) * 1
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

b_prior = solve_b(y=c(min(y,na.rm=TRUE), -.1), p=c(.99, .0001))
model.consts = list(N=N, J=J, I=I, K=K, N_sum=N_sum, 
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
model.data = list(y=y, m=m, constraints_mus0=1, constraints_mus1=1)

y.init = y
y.init[which(is.na(y))] <- mean(y[y<0], na.rm=TRUE)
y.init[-which(is.na(y))] <- NA
model.inits = list(gam=matrix(1, sum(N), J),
                   lam=rep(1,sum(N)),
                   Z0=matrix(rbinom(J*K,1,.5),J,K),
                   W=matrix(1/K, I, K),
                   v=rep(1/K,K),
                   y=y.init,
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
model.conf$addMonitors2(c('lam', 'y'))
model.conf$thin2 = B / nsamps2

model.mcmc = buildMCMC(model.conf)
cmodel = compileNimble(model.mcmc, project=model)
burn=4000
time_100_iters = system.time(runMCMC(cmodel, summary=TRUE, niter=100, nburnin=0))
seconds_one_iter = time_100_iters[3] / 100
estimated_time = seconds_one_iter * (B+burn)
print("Estimated time (in seconds):")
print(estimated_time)
time_model = system.time(
  out <- runMCMC(cmodel, summary=TRUE, niter=B+burn, nburnin=burn, setSeed=1)
)
print(time_model)


### Summary ###
get_param = function(name, out_samples) {
  which(sapply(colnames(out_samples), function(cn) grepl(name, cn)))
}

pdf('out/bla.pdf')
lam.cols = get_param('lam', out$samples2)
lam_last = out$samples2[,lam.cols]
print(table(lam_last, c(unlist(dat$lam))))
ari_lam = ari(lam_last, c(unlist(dat$lam)))
cat("ARI of cell-type labesl (lambda): ", ari_lam, '\n')

W.cols = get_param('W', out$samples)
my.image(matrix(out$summary[W.cols,1], I, K), col=greys(10), zlim=c(0,max(dat$W)),
         addL=T, color.bar.dig=2)

Z.cols= get_param('Z', out$samples)
Z.mean = matrix(out$summary[Z.cols,1], J, K) - 1
my.image(matrix(out$summary[Z.cols,1], J, K))
my.image(dat$Z, main='True Z')

sig2.cols = get_param('sig2', out$samples)
sig2_post = out$samples[, sig2.cols]
plotPosts(sig2_post)

b0_post = out$samples[, 'b0']
b1_post = out$samples[, 'b1']
plotPosts(cbind(b0_post, b1_post))

dev.off()


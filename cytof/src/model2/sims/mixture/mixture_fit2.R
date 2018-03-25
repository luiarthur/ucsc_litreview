source("mcmc.R")
library(truncnorm)

println = function(x) cat(x, '\n')

generate_default_prior = function(K) {
  list(mu_mean=0, mu_var=10,
       sig2_a=3, sig2_b=3,
       d_w=rep(1/K, K))
}

mixture_fit2 = function(y, K=10, B=2000, burn=2000, print_every=0,
                       prior=generate_default_prior(K)) {
  N = length(y)

  compute_loglike = function(state) {
    compute_group_k = function(k) {
      sum(state$w[k] * dnorm(y, state$mu[k], sqrt(state$sig2)))
    }
    sum(sapply(1:K, compute_group_k))
  }


  update_w = function(state) {
    a_new = sapply(1:K, function(k) sum(state$group == k)) + prior$d_w
    rdir(a_new)
  }

  update_mu = function(state) {
    update_muk = function(k) {
      y_k = y[which(state$group == k)]
      n_k = length(y_k)
      s2 = state$sig2
      new_var =  1 / (1 / prior$mu_var + n_k / s2)
      new_mean = (prior$mu_mean / prior$mu_var + sum(y_k) / s2) * new_var
      rnorm(1, new_mean, sqrt(new_var))
    }

    sapply(1:K, update_muk)
  }
  update_sig2 = function(state) { 
    new_a = N/2 + prior$sig2_a
    new_b = prior$sig2_b 
    new_b = new_b + sapply(1:K, function(k) {
      sum((y[which(state$group==k)] - state$mu[k])^2) / 2
    })
    1 / rgamma(1, new_a, new_b)
  }

  update_group = function(state) {
    p = sapply(1:K, function(k) {
      state$w[k] * dnorm(y, state$mu[k], sqrt(state$sig2))
    })
    apply(p, 1, function(p_vec) sample(1:K, 1, prob=p_vec))
  }


  update = function(state) {
    #println('updating mu')
    state$mu = update_mu(state)
    #println('updating sig2')
    state$sig2 = update_sig2(state)
    #println('updating w')
    state$w = update_w(state)
    #println('updating group')
    state$group = update_group(state)
    state$ll = compute_loglike(state)
    state
  }

  
  init = list(group=sample(1:K, N, replace=TRUE),
              w=rep(1/K,K),
              mu=rnorm(K, prior$mu_mean, sqrt(prior$mu_var)),
              sig2=1/rgamma(1, prior$sig2_a, prior$sig2_b))
  gibbs(init, update, B, burn, print_every=print_every) 
}


postpred2 = function(out) {
  K = length(out[[1]]$mu)
  one_pred = function(state) {
    k = sample(1:K, 1, prob=state$w)
    rnorm(1, state$mu[k], sqrt(state$sig2))
  }
  sapply(out, one_pred)
}

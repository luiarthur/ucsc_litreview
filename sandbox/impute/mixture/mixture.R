source("../mcmc/mcmc.R")

println = function(x, ...) cat(x, ..., '\n')

gen.prior= function(K) {
  list(cs_b=c(1,1), 
       b_mean=c(0,0), b_var=c(1,1),
       mu_mean=0, mu_var=10,
       sig2_a=2, sig2_b=1,
       d_w=rep(1/K, K),
       cs_y=1)
}

gen.init = function(K, y) {
  N = length(y)

  list(b=c(0,-2),
       mu=rep(0,K),
       sig2=rep(1,K),
       y=ifelse(is.na(y), 0, y),
       w=rdir(rep(1/K, K)),
       group=sample(1:K, N, replace=TRUE))
}

fit = function(y, K, prior=gen.prior(K),
               init=gen.init(K,y),
               B=2000, burn=2000, print_every=100) {

  N = length(y)
  missing = is.na(y)

  compute_loglike = function(state) {
    compute_group_k = function(k) {
      sum(state$w[k] * dnorm(state$y, state$mu[k], sqrt(state$sig2[k])))
    }
    sum(sapply(1:K, compute_group_k))
  }

  update_mu = function(state) {
    update_muk = function(k) {
      y_k = state$y[which(state$group == k)]
      n_k = length(y_k)
      sig2_k = state$sig2[k]
      new_var =  1 / (1 / prior$mu_var + n_k / sig2_k)
      new_mean = (prior$mu_mean / prior$mu_var + sum(y_k) / sig2_k) * new_var
      rnorm(1, new_mean, sqrt(new_var))
    }

    sapply(1:K, update_muk)
  }

  update_sig2 = function(state) { 
    update_sig2k = function(k) {
      y_k = state$y[which(state$group == k)]
      n_k = length(y_k)
      new_a = n_k/2 + prior$sig2_a
      new_b = prior$sig2_b + sum((y_k - state$mu[k])^2) / 2
      1 / rgamma(1, new_a, new_b)
    }
    sapply(1:K, update_sig2k)
  }

  update_group = function(state) {
    p = sapply(1:K, function(k) {
      state$w[k] * dnorm(state$y, state$mu[k], sqrt(state$sig2[k]))
    })
    apply(p, 1, function(p_vec) sample(1:K, 1, prob=p_vec))
  }


  update_w = function(state) {
    a_new = sapply(1:K, function(k) sum(state$group == k)) + prior$d_w
    rdir(a_new)
  }

  update_b = function(state) {
    lp = function(b) {
      sum(dnorm(b, prior$b_mean, sqrt(prior$b_var),log=TRUE))
    }
    ll = function(b) {
      p = sigmoid(b[1] + b[2] * state$y)
      sum(dbinom(is.na(y), 1, p, log=TRUE))
    }
    mh_mv(state$b, ll, lp, prior$cs_b)
  }

  update_y = function(state) {
    update_yi = function(i) {
      ll = function(yi) {
        log(sum(state$w * dnorm(yi, state$mu, sqrt(state$sig2))))
      }

      lp = function(yi) {
        p = sigmoid(state$b[1] + state$b[2] * yi)
        dbinom(1*is.na(y[i]), 1, p, log=TRUE)
      }

      ifelse(is.na(y[i]), mh(state$y[i], ll, lp, prior$cs_y), y[i])
    }

    sapply(1:N, update_yi)
  }

  update = function(state) {
    #println('b')
    state$b = update_b(state)
    #println('y')
    state$y = update_y(state)
    #println('mu')
    state$mu = update_mu(state)
    #println('sig2')
    state$sig2 = update_sig2(state)
    #println('w')
    state$w = update_w(state)
    #println('group')
    state$group = update_group(state)
    state
  }

  gibbs(init, update, B, burn, print_every)
}

postpred = function(out) {
  K = length(out[[1]]$mu)
  one_pred = function(state) {
    k = sample(1:K, 1, prob=state$w)
    rnorm(1, state$mu[k], sqrt(state$sig2[k]))
  }
  sapply(out, one_pred)
}

compute_b = function(y, prob) {
  b1 = (-log(1/prob[2] - 1) + log(1/prob[1] - 1)) / (y[2] - y[1])
  b0 = -(log(1/prob[1] - 1) + b1 * y[1])
  c(b0, b1)
}

# Test
#compute_b(c(-3, -2), c(.9, .1))

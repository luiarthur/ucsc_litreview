data{
  int N;
  int K;
  real y[N];
}

parameters {
  ordered[K] mu; 
  real<lower=0> sig2[K];
  simplex[K] theta;
}

model {
  real loglike[K];
  
  // Priors:
  mu ~ normal(0, 10);
  sig2 ~ inv_gamma(2,1);
  theta ~ dirichlet(rep_vector(1.0/K, K));

  // Likelihood:
  for (i in 1:N) {
    for (k in 1:K) {
      loglike[k] = log(theta[k]) + normal_lpdf(y[i] | mu[k], sqrt(sig2[k]));
    }
    target += log_sum_exp(loglike);
  }
}


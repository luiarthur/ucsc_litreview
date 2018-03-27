data{
  int N;
  int K;
  int J;
  real y[N,J];
  matrix[J,J] R;
}

parameters {
  vector[J] mu[K]; 
  real<lower=0> sig2[K];
  simplex[K] w;
}

model {
  real loglike[K];
  
  // Priors:
  for (k in 1:K) {
    mu[k] ~ multi_normal(rep_vector(0.0, J), sig2[k] * R);
    sig2[k] ~ inv_gamma(2,1);
  }
  w ~ dirichlet(rep_vector(1.0/K, K));

  // Likelihood:
  for (i in 1:N) {
    for (k in 1:K) {
      for (j in 1:J) {
        loglike[k] = log(w[k]) + normal_lpdf(y[i,j] | mu[k][j], sqrt(sig2[k]));
      }
    }
    target += log_sum_exp(loglike);
  }
}


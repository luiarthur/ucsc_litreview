// In order to use STAN, need to address two issues:
// 1. Doesn't have truncated Normal
//      - good thing stan has cdf of normal
//      - actually it does:
//        see: http://www.uvm.edu/~bbeckage/Teaching/DataAnalysis/Manuals/stan-reference-2.8.0.pdf
//        Section 8.1
// 2. Ragged Arrays
//      - handled by simply using regularly-shaped arrays and setting the
//        ragged dimension to be the max dimension
// 3. integer parameters not allowed
//      - Stan isn't able to sample discrete parameters... wtf

data {
  int I;     // number of samples
  int J;     // number of markers
  int K;     // number of latent features
  int N[I];  // number of cells in sample i
  int maxN;  // max(N_1, N_2, ... , N_I)
  matrix[J,J] G; // Covariance matrix for markers. Should default to I_j
  real thresh; // should be log(2)
  real<lower=0> alpha;
  vector[K] a;
  vector[J] h_mean;

  real<lower=0> y[I, maxN, J]; // Data
}


parameters {
  real mus[J,K];
  real psi[J];
  real<lower=0> tau2[J];
  real<lower=0, upper=1> Pi[I,J];
  real<lower=0> sig2[I];
  real<lower=0, upper=1> v[K];
  vector[J] h[K];
  vector[K] W[I];
  real<lower=0, upper=1> c[J];
  real<lower=0> d;

  simplex[K] lam[I, maxN];
}

transformed parameters {
  vector[K] b;
  matrix[J,K] Z;
  vector[J] tau; 
  vector[J] sig; 
  vector[J] Pi_a; 
  vector[J] Pi_b; 
  real logit_c[J]; 
  real log_d; 

  for (k in 1:K)
    b[k] = (k == 1 ? v[k] : b[k-1] * v[k]);

  for (j in 1:J) for (k in 1:K)
    Z[j,k] = (normal_cdf(h[k][j], 0, G[j,j]) < b[k] ?  1 : 0);

  for (j in 1:J) tau[j] = sqrt(tau2[j]);
  for (i in 1:I) sig[i] = sqrt(sig2[i]);

  for (j in 1:J) Pi_a[j] = c[j] * d;
  for (j in 1:J) Pi_b[j] = (1-c[j]) * d;

  for (j in 1:J) logit_c[j] = log(c[j] / (1-c[j]));
  log_d = log(d);
}

model {
  // Priors
  for (j in 1:J) for (k in 1:K) {
    if (Z[j,k] == 1) {
      mus[j,k] ~ normal(psi[j], tau2[j]) T[thresh,];
    } else {
      mus[j,k] ~ normal(psi[j], tau2[j]) T[,thresh];
    }
  }

  psi ~ normal(thresh, 2);
  tau ~ inv_gamma(3, 2);
  sig ~ inv_gamma(3, 2);

  for (j in 1:J) Pi[j] ~ beta(Pi_a[j], Pi_b[j]);
  for (j in 1:J) logit_c ~ normal(0, 3);
  log_d ~ normal(0, 3);

  for (k in 1:K) v[k] ~ beta(alpha, 1);
  for (k in 1:K) h[K] ~ multi_normal(h_mean, G);
  for (i in 1:I) W[i] ~ dirichlet(a);

  // Likelihood
  for (i in 1:I) for (n in 1:N[I]) for (j in 1:J) {
    y[i,n,j] ~ normal(mus[j, lam[i][n]], sig[i]) T[0,];
  }
}

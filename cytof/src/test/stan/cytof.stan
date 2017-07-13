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
//      - you can, however, marginalize out discrete

// Currently too slow... So, I removed Pi
// Next Stage: Add Pi back into the model

data {
  int I;               // number of samples
  int J;               // number of markers
  int K;               // number of latent features
  int N[I];            // number of cells in sample i
  int maxN;            // max(N_1, N_2, ... , N_I)
  matrix[J,J] G;       // Covariance matrix for markers. Should default to I_j
  real thresh;         // should be log(2)
  real<lower=0> alpha; // should be 1
  vector[K] a;         // should be (1/K, ..., 1/K)
  vector[J] h_mean;    // should be the zero vector (0_J)

  real<lower=0> y[I, maxN, J]; // Data
}


parameters {
  real mus[J,K];
  real psi[J];
  real<lower=0> tau2[J];
  //real<lower=0, upper=1> Pi[I,J];
  real<lower=0> sig2[I];
  real<lower=0, upper=1> v[K];
  vector[J] h[K];    // K-array of J-dimensional vectors
  simplex[K] W[I];   // I-array of K-dimensional simplexes
  //real log_d;
  //real logit_c[J];
}

transformed parameters {
  vector[K] b;
  matrix[J,K] Z;
  //real Pi_a[J];
  //real Pi_b[J]; 
  //real cj;
  //real d;

  for (k in 1:K)
    b[k] = (k == 1 ? v[k] : b[k-1] * v[k]);

  for (j in 1:J) for (k in 1:K)
    Z[j,k] = (normal_lcdf(h[k][j] | 0, G[j,j]) < log(b[k]) ?  1 : 0);

  //for (j in 1:J) {
  //  cj = 1 / (1 + exp(-logit_c[j]));
  //  d = exp(log_d);
  //  Pi_a[j] = cj * d;
  //  Pi_b[j] = (1-cj) * d;
  //}
}

model {
  real loglike[K];


  // Priors
  for (j in 1:J) for (k in 1:K) {
    if (Z[j,k] == 1) {
      mus[j,k] ~ normal(psi[j], sqrt(tau2[j])) T[thresh,];
      //mus[j,k] ~ normal(thresh + psi[j], sqrt(tau2[j]));
    } else {
      mus[j,k] ~ normal(psi[j], sqrt(tau2[j])) T[,thresh];
      //mus[j,k] ~ normal(thresh - psi[j], sqrt(tau2[j]));
    }
  }

  psi ~ normal(thresh, 2);
  tau2 ~ inv_gamma(3, 2);
  sig2 ~ inv_gamma(3, 2);

  //for (i in 1:I) for (j in 1:J) Pi[i][j] ~ beta(Pi_a[j], Pi_b[j]);
  //for (j in 1:J) logit_c ~ normal(0, 3);
  //log_d ~ normal(0, 3);

  for (k in 1:K) v[k] ~ beta(alpha, 1);
  for (k in 1:K) h[K] ~ multi_normal(h_mean, G);
  for (i in 1:I) W[i] ~ dirichlet(a);

  // Likelihood
  for (i in 1:I) for (n in 1:N[I]) for (j in 1:J) {
    for (k in 1:K) {
      if (y[i,n,j] < 0) {
        loglike[k] = -1E10;
      } else {
        loglike[k] = log(W[i][k]) + normal_lpdf(y[i,n,j] | mus[j, k], sqrt(sig2[i])) - normal_lccdf(0 | mus[j, k], sqrt(sig2[i]));
      }
    }
    target += log_sum_exp(loglike);
  }
}



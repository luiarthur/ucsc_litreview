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

functions {
  real tnorm_lpdf(real x, real mu, real sig, real a, real b) {
    return normal_lpdf(x | mu, sig) - log( normal_cdf(b, mu, sig) - normal_cdf(a, mu, sig) );
  }

  real tnorm_pdf(real x, real mu, real sig, real a, real b) {
    return exp(tnorm_lpdf(x | mu, sig, a, b));
  }
}

data {
  int I;               // number of samples
  int J;               // number of markers
  int K;               // number of latent features
  int N[I];            // number of cells in sample i
  int maxN;            // max(N_1, N_2, ... , N_I)
  real thresh;         // should be log(2)
  vector[K] a;         // should be (1/K, ..., 1/K)

  real<lower=0> y[I, maxN, J]; // Data
}


parameters {
  real mus[J,K];
  real<lower=0, upper=1> Pi[I,J];
  real<lower=0> sig2[I];
  simplex[K] W[I];   // I-array of K-dimensional simplexes
  real<lower=0, upper=1> gam[K];
  real<lower=0> alpha;
}

model {
  real loglike[K];
  real piece[2];

  // Priors
  for (i in 1:I) for (j in 1:J) Pi[i][j] ~ beta(1, 1);
  sig2 ~ inv_gamma(3, 2);
  for (i in 1:I) W[i] ~ dirichlet(a);
  gam ~ beta(alpha/K,1);
  alpha ~ gamma(.1, .1);

  // Likelihood
  for (i in 1:I) for (n in 1:N[I]) for (j in 1:J) {
    for (k in 1:K) {
      //loglike[k] = log(W[i][k]) + normal_lpdf(y[i,n,j] | mus[j, k], sqrt(sig2[i])) - normal_lccdf(0 | mus[j, k], sqrt(sig2[i]));
      loglike[k] = log(W[i][k]) + tnorm_lpdf(y[i,n,j] | mus[j,k], sqrt(sig2[i]), 0, 1E10);
    }
    //target += log_sum_exp(loglike);
    piece[1] = log(Pi[i][j]) + normal_lpdf(y[i,n,j] | 0, 1E-10);
    piece[2] = log(1-Pi[i][j]) + log_sum_exp(loglike);
    target += log_sum_exp(piece);
  }

  for (j in 1:J) for (k in 1:K) {
    target += log(gam[k]*tnorm_pdf(mus[j,k], thresh, 2, thresh, 1000) + (1-gam[k])*tnorm_pdf(mus[j,k], thresh, 2, -1000, thresh));
  }
}


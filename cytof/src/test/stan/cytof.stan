// In order to use STAN, need to address two issues:
// 1. Doesn't have truncated Normal
//      - good thing stan has cdf of normal
//      - actually it does:
//        see: http://www.uvm.edu/~bbeckage/Teaching/DataAnalysis/Manuals/stan-reference-2.8.0.pdf
//        Section 8.1
// 2. Ragged Arrays
//      - handled by simply using regularly-shaped arrays and setting the
//        ragged dimension to be the max dimension

data {
  int I;     // number of samples
  int J;     // number of markers
  int K;     // number of latent features
  int N[I];  // number of cells in sample i
  int maxN;  // max(N_1, N_2, ... , N_I)

  real<lower=0> y[I, maxN, J]; //
}

parameters {
  real mus[J,K];
  real psi[J];
  real<lower=0> tau2[J];
  real<lower=0, upper=1> Pi[I,J];
  real<lower=0> sig2[I];
  real<lower=0, upper=1> v[K];
  real H[J,K];
  real<lower=0, upper=1> lam[I,N];
  real<lower=0, upper=1> W[I,K];
}

transformed parameters {
}

model {

  // Likelihood
  for (i in 1:I) for (n in 1:N[I]) for (j in 1:J) {
    if (e[i,n,j] > 0) {
      y[i,n,j] ~ normal(mus[j, lam[i,n]], sqrt(sig2_i)) T[0,];
    } // else if (e[i,n,j] == 1) ???
  }

}

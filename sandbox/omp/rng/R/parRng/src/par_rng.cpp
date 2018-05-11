#include <RcppGSL.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include <omp.h>

#include "my_timer.h"


void big_function(gsl_rng* rng) {
  const double x=396124121;
  double y;
  for (int i=0; i<10000; i++) {
    //y = gsl_rng_uniform(rng);
    y = gsl_ran_gaussian(rng, 3) + 2;
    //if (i==0) std::cout << y << std::endl;
  }
}

void par_same_rng(gsl_rng* rng, int N, int NUM_THREADS) {
  #pragma omp parallel for num_threads(NUM_THREADS)
  for (int i=0; i<N; i++) {
    big_function(rng);
  }
}

void par_separate_rng(gsl_rng* rngs[], int N, int NUM_THREADS) {
  #pragma omp parallel for num_threads(NUM_THREADS)
  for (int i=0; i<N; i++) {
    big_function(rngs[omp_get_thread_num()]);
  }
}

void serial_rng(gsl_rng* rng, int N) {
  for (int i=0; i<N; i++) {
    big_function(rng);
  }
}


//' parRngTest
//' @export
// [[Rcpp::export]]
void parRngTest(int N=10000, int NUM_THREADS=8) {

  // Create an array equal to the number of threads for rng
  gsl_rng* rngs[NUM_THREADS];
  for (int n=0; n<NUM_THREADS; n++) {
    rngs[n] = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set(rngs[n], n);
  }

  TIME_CODE("Parallel RNG with one RNG for each thread: ",
      par_separate_rng(rngs, N, NUM_THREADS);
  )

  TIME_CODE("Parallel RNG with one RNG for all threads: ",
      par_same_rng(rngs[0], N, NUM_THREADS);
  )

  TIME_CODE("Serial RNG: ",
      serial_rng(rngs[0], N);
  )
}

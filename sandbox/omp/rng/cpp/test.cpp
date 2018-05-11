/** Run this script with

cling -std=c++11 -lgsl

**/

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <map>
#include <iostream>
#include <iomanip>
#include <string>
// For graphics, see: http://en.cppreference.com/w/cpp/numeric/random
// https://www.gnu.org/software/gsl/doc/html/randist.html

gsl_rng* r = gsl_rng_alloc(gsl_rng_mt19937);

const int K = 5;
double p[K];
for (int k=0; k<K; k++) {
  p[k] = k+1;
}

auto dpp = gsl_ran_discrete_preproc(K, p);
gsl_ran_discrete(r, dpp);

std::map<int,int> hist;
int draw;
const int N = 10000000;
for (int n=0; n<N; n++) {
  draw = gsl_ran_discrete(r, dpp);
  hist[draw]++;
}

double stars;
for (auto h : hist) {
  stars = h.second*1.0/N * 100;
  std::cout << std::fixed << std::setprecision(1) << std::setw(2)
            << h.first << ' ' << std::string(stars, '*')
            << ' ' << std::setprecision(4) << stars << '%' << std::endl;
}

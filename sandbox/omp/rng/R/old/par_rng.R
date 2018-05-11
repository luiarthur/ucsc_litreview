library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
system.time(sourceCpp("par_rng.cpp"))


test(N=50000, NUM_THREADS=4)

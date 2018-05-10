library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
system.time(sourceCpp("sumPar.cpp"))

x <- rnorm(10000)

system.time(out <- sumPar(x))
system.time(out <- sum(x))

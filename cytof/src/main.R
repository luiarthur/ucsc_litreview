library(rcommon)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
system.time(sourceCpp("cpp/cytof.cpp"))


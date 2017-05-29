library(rcommon)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")

sourceCpp("test_snippet.cpp") 
test( list(1:5, 2,3) )

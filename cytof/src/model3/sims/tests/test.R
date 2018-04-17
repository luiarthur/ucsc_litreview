library(Rcpp)

set.seed(1)
library(Rcpp)
sourceCpp('test.cpp')

y <- rnorm(1000)


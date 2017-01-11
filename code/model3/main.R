# load rcommon
require('devtools')
if ( !("rcommon" %in% installed.packages()) ) {
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)

library(Rcpp)
sourceCpp("purity3.cpp")



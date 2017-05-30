library(rcommon)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")

sourceCpp("test_snippet.cpp") 
y <- list(matrix(2,2,3), matrix(3,3,4))
test(y)

test2(2,3)

test3(3,4)

sourceCpp("test_snippet.cpp") 
state <- new(State)
state$x <- 1
state$y <- 2



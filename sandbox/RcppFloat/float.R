library(float)
library(Rcpp)

### Source float.cpp ###
sourceCpp("float.cpp")

### Variable / function defs ###
N = 50
M = 1000
genX_db = function(n) matrix(rnorm(n*n), n, n)
genX_fl = function(n) dbl(fl(matrix(rnorm(n*n), n, n)))

### Generate list of Matrices
X_db = lapply(1:M, function(i) genX_db(N))
X_fl = lapply(1:M, function(i) genX_fl(N))
### Save ###
saveRDS(X_db, 'out/X_db.rds')
saveRDS(X_fl, 'out/X_fl.rds')


### Generate list of Matrices
X_plusOne_db = lapply(X_db, addOne)
X_plusOne_fl = lapply(X_fl, function(x) addOne(dbl(x)))
### Save ###
saveRDS(X_plusOne_db, 'out/X_plusOne_db.rds')
saveRDS(X_plusOne_fl, 'out/X_plusOne_fl.rds')


library(rcommon)
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
sourceCpp("test_mcmc.cpp") 

sig2 <- 1.5
k <- 10
n <- 500
X <- matrix(rnorm(n*k),n,k)
b <- 1:k

y <- X %*% b + rnorm(n, 0, sqrt(sig2))

system.time(
out <- fit(y=y, X=X, init_beta=rep(0,k), cs_beta=1, 
           a_sig=2, b_sig=1, init_sig2=1, cs_sig2=.2,
           B=2000, burn=3000, pr=100)
)
colnames(out) <- c(paste0('b',1:k), 'sig2')

plotPost(out[,11])
plotPosts(out[,1:5])
plotPosts(out[,6:10])

nrow(unique(out[,-11])) / nrow(out)
length(unique(out[,11])) / nrow(out)

post.summary(out)

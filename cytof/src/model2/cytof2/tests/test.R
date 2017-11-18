library(cytof2)
system.time(x <- sapply(1:100000, function(i) rtnorm(0,1,8,Inf)))
mean(x)

system.time(x <- sapply(1:100000, function(i) dtnorm(10, 0,1,8,Inf)))
system.time(print(dtnorm(10, 0,1,8,Inf)))


x <- seq(6, 10, len=10000)
system.time(plot(x, y<-log(sapply(x, function(xi)dtnorm(xi, 0,1,8,Inf)), type='l'))


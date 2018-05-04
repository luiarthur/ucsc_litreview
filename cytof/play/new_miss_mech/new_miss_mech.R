sigmoid = function(x) 1 / (1 + exp(-x))

prob_miss = function(y, b0, b1, b2) {
  sigmoid(b1 * (y - b0)^2 + b2)
}

y = seq(-10,0,l=50)
b0 = -3 # center (negative)
b1 = -3 # width  (negative)
b2 =  8 # height (real)
p = prob_miss(y, b0=b0, b1=b1, b2=b2)
plot(y, p, ylim=0:1, type='l'); abline(v=c(b0, b0+b1, b0-b1), lty=2)

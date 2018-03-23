sigmoid = function(z) 1 / (1 + exp(-z))

sigmoid_approx = function(z,x) {
  lam = function(w) .5 / w * (sigmoid(w) - .5)
  sigmoid(x) * exp((z-x)/2 - lam(x) * (z^2 - x^2))
}

x <- seq(-7, 7, l=10)
plot(x, sigmoid(x), type='l')
lines(x, sigmoid_approx(x,4), col='blue')

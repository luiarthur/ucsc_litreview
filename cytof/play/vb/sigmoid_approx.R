sigmoid = function(z) 1 / (1 + exp(-z))

sigmoid_approx = function(z,x) {
  lam = function(w) .5 / w * (sigmoid(w) - .5)
  sigmoid(x) * exp((z-x)/2 - lam(x) * (z^2 - x^2))
}

x <- seq(-10, 10, l=1000)

# Lower bound of sigmoid in blue
par(mfrow=c(2,1))
plot(x, sigmoid(x), type='l')
lines(x, sigmoid_approx(x,1), col='green')
lines(x, sigmoid_approx(x,4), col='blue')
lines(x, sigmoid_approx(x,8), col='red')

plot(x, sigmoid(-x), type='l')
lines(x, sigmoid_approx(-x,1), col='green')
lines(x, sigmoid_approx(-x,4), col='blue')
lines(x, sigmoid_approx(-x,8), col='red')
par(mfrow=c(1,1))

plot(x, sigmoid(x), type='l', lwd=3)
abline(v=0, h=.5)
N = 1000
u = runif(N, min=0, max=30)
d = double(N)
for (i in 1:N) {
  ui = u[i]
  s = sigmoid_approx(x, ui)
  d[i] = sum((sigmoid(x) - s)^2)
  lines(x, s, col=rgb(0,0,0,.1))
}

i = which.min(d)
plot(x, sigmoid(x), type='l', lwd=3)
abline(h=.5, v=0)
lines(x, sigmoid_approx(x, u[i]))

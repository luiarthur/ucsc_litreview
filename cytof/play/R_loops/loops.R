B = 20000

t1 = system.time(
  for (i in 1:B) {
    x <- rgamma(100, 3, 2)
  }
)

t2 = system.time(
  x <- rgamma(100 * B, 3, 2)
)

(t1 - t2) / B

t3 = system.time(
  for (i in 1:B) {
    x <- rgamma(100, 3, 2)
    y <- rgamma(100, 3, 2)
    z <- rgamma(100, 3, 2)
  }
)



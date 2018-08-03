context("demo")
test_that("demo is working", {
  expect_equal(1+1, 2)
})


context("simple cytof model declaration")
test_that("simple cytof", {
  library(cytof4)
  library(nimble)
  I = 3
  J = 8
  K_true = 4
  L0 = 3
  L1 = 5
  N = c(3,1,2) * 100

  dat = sim_dat(I=I, J=J, N=N, K=K_true, L0=L0, L1=L1)
  
  K = 10
  L = 5
  y = Reduce(rbind, dat$y)
  model = nimbleModel(model.code(),
                      data=model.data(y),
                      constants=model.consts(y=y, N=N, K=K, L=L),
                      inits=model.inits(y=y, N=N))
})

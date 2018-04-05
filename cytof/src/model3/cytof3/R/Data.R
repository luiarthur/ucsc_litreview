gen_data_obj = function(y) {
  N = sapply(y, NROW)

  list(
    y=y,
    N=N,
    N_sum=sum(N),
    J=NCOL(y[[1]]),
    I=NROW(y[[1]]),
    M=lapply(y, function(yi) is.na(yi) | !is.finite(yi)))
}

#y = list(matrix(1:15, 3), matrix(1:24, 3))
#y[[1]][3,3] = 1/0
#y[[2]][1,3] = NA
#gen_data_obj(y)

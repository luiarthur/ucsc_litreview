resample = function(y, prop=1) {
  stopifnot(prop >= 0)

  if (0 < prop && prop < 1) {
    REPLACE = FALSE
  } else if (prop >= 1) {
    REPLACE = TRUE
  } else {
    return(y)
  }

  out = lapply(y, function(yi) {
    Ni = NROW(yi)
    new_Ni = max(round(Ni * prop), 1)
    idx = sample(1:Ni, new_Ni, replace=REPLACE)
    yi[idx,]
  })

  return(out)
}

#x = matrix(rnorm(15), 5, 3)
#y = matrix(rnorm(12), 3, 4)
#z = resample(list(x,y), 10)
#z = resample(list(x,y), 0)
#z = resample(list(x,y), .5)

preimpute = function(y, subsample_prop=0) {
  for (i in 1:length(y)) {
    for (j in 1:NCOL(y[[i]])) {
      miss_idx = which(is.na(y[[i]][,j]))

      neg_yj = which(y[[i]][,j] < 0)
      y[[i]][miss_idx,j] = sample(y[[i]][neg_yj,j],
                                  size=length(miss_idx), replace=TRUE)

      #y[[i]][miss_idx,j] = sample(y[[i]][-miss_idx,j], size=length(miss_idx), replace=TRUE)
    }
  }

  resample(y, subsample_prop)
}

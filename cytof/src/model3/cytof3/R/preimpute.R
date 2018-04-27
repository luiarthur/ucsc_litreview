#' Preimpute values in list of matrices y if they are missing.
#' @param y  List of matrices of same number of columns.
#' @param subsample_prop  Proportion of original data to use (between 0 and 1). See `resample`
#' @export
preimpute = function(y, subsample_prop=0) {
  for (i in 1:length(y)) {
    for (j in 1:NCOL(y[[i]])) {
      miss_idx = which(is.na(y[[i]][,j]))
      if (length(miss_idx) > 0) {
        neg_yj = which(y[[i]][,j] < 0)
        y[[i]][miss_idx,j] = sample(y[[i]][neg_yj,j],
                                    size=length(miss_idx), replace=TRUE)

        #y[[i]][miss_idx,j] = sample(y[[i]][-miss_idx,j], size=length(miss_idx), replace=TRUE)
      } else { 
        println("No missing values to preimpute in (", i,",", j, ")", "\n")
      }
    }
  }

  resample(y, subsample_prop)
}

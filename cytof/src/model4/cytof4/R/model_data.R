#' Nimble model data object generator
#' 
#' y: concatenated matrix of transformed marker expression. missing values should be recorded as NA
#' @export
model.data = function(y=NA) {
  list(y=y, m=is.na(y) * 1, constraints_mus0=1, constraints_mus1=1)
}

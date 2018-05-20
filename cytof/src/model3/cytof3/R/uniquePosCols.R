uniquePosCols = function(Z) {
  #' Find the unique non-zero columns in Z
  #' @export 

  col0 = which(colSums(Z) == 0)
  if (length(col0) > 0) {
    Z = Z[,-col0]
  }

  NCOL(unique(Z, MARGIN=2))
}

uniqueCols = function(Z) {
  #' Find the unique columns in Z
  #' @export 

  NCOL(unique(Z, MARGIN=2))
}

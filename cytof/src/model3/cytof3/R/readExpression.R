#' @export
get_missing_count <- function(y) {
  sapply(y, function(yi)
    apply(yi, 2, function(col) sum(col == -Inf | is.na(col)))
  )
}

#' @export
get_missing_prop <- function(y) {
  sapply(y, function(yi)
    apply(yi, 2, function(col) mean(col == -Inf | is.na(col)))
  )
}
 

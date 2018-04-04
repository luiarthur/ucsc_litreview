#' Compare list of matrices
#' @export
compareListMatrix = function(a, b) {
  N = length(a)
  stopifnot(length(a) == length(b))

  sapply(as.list(1:N), function(i) all(a[[i]] == b[[i]]))
}

#' Cytof3 R function unit tests 
#' @export
cytof3_unit_tests_R = function(){
  
  ### Put Unit Tests HERE
  
  ### Test gen_data_obj
  J = 3
  y = list(
    matrix(1:12, ncol=J),
    matrix(1:24, ncol=J),
    matrix(1:15, ncol=J),
    matrix(1:6, ncol=J)
  )
  
  data = test_gen_data_obj(y)

  stopifnot(compareListMatrix(data$y,y))
  stopifnot(data$N == sapply(y, NROW))
  stopifnot(data$N_sum == sum(sapply(y, NROW)))
  stopifnot(data$J == J)
  stopifnot(data$I == length(y))
  stopifnot(compareListMatrix(data$M, lapply(y, function(yi) 1 * is.na(yi))))

  print("All tests passed")
}

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
  
  stopifnot(data$Y == do.call('rbind', y))
  stopifnot(data$N == sapply(y, NROW))
  stopifnot(data$N_sum == sum(sapply(y, NROW)))
  stopifnot(data$I == length(y))
  stopifnot(data$J == J)
  #stopifnot(data$idx)

  print("All tests passed")
}

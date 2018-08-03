#' Pad zeros to list of ragged matrices
#'
#' Pads each element of a list of (ragged) matrices with zeros so that they all
#' have the same dimensions. Ragged matrices are matrices with the same number
#' of columns but different number of rows.
#' @return a (non-ragged) 3D array 
#' @examples
#' y_ls = list(matrix(1,2,5), matrix(2,3,5), matrix(3,1,5))
#' pad_zeros(y_ls)
#' @export
pad_zeros = function(y_list) {

  K = NCOL(y_list[[1]])
  row_max = max(sapply(y_list, NROW))
  new_y_list = lapply(y_list, function(y) {
    if (NROW(y) < row_max) {
      rbind(y, matrix(0, row_max-NROW(y), K))
    } else y
  })
  simplify2array(new_y_list)
}



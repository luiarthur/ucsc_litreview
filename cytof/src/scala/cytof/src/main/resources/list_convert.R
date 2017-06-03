getListArray <- function(s, scala_lname) {
  n <- s %~% paste0(scala_lname, ".size")
  out <- as.list(1:n)
  for (i in 1:n) {
     out[[i]] <- s$.val(scala_lname)$apply(i-1L)
  }
  out
}

putListArray <- function(s, r_list, scala_lname, elem_type) {
  n <- length(r_list)
  
  s %@% "val @{scala_lname} = Array.ofDim[Array[ @{elem_type} ]]( @{n} )"

  for (i in 1:n) {
    s %@% "@{scala_lname}(@{i}-1) = Array( @{r_list[[i]]} )"
  }
}

### Example
#library(rscala)
#s <- scala()
#
##l <- list(matrix(1:6,2,3), 2:10)
#l <- list(1:3, 2:10, 3:5)
#
#putListArray(s, l, "a", "Double")
#getListArray(s, "a")

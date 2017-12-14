extendZ <- function(Z,K) {
  #' Extend (or shrink) the columns of Z to have exactly K columns
  #' @export

  if (NCOL(Z) > K) {
    Z[,1:K]
  } else if (NCOL(Z) < K) {
    extendZ(cbind(Z,0), K)
  } else {
    Z
  }
}

### Provides a point estimate for a list of binary matrices
### with same number of rows and different number of columns
### This function requires: gtools::permutations
est_Z <- function(Z_list) {
  #' @export

  ### Get maximum number of columns in matrices in Z_list
  max_cols_Z <- max(sapply(Z_list, NCOL))

  ### Create new list of Z matrices (with equal dims)
  new_Z_list <- lapply(Z_list, extendZ, max_cols_Z)

  ### Assert that all matrices have equal dims
  stopifnot(all( sapply(new_Z_list, NCOL) == max_cols_Z ))

  ### All possible permutation of columns:
  ### (rows, cols) = (num_of_permnutations, max_cols_Z)
  perm_col_orders <- gtools::permutations(max_cols_Z, max_cols_Z)

  ### Fn. to compare two matrices in a particular column order. Returns a number.
  compare_by_col_order <- function(Z1, Z2, col_ord) {
    sum(abs(Z1 - Z2[,col_ord]))
  }

  ### Fn. to compare two matrices (based on their indices). 
  ### Returns min distance
  compare <- function(idx_of_Z_pairs) {
    Z1 <- new_Z_list[[ idx_of_Z_pairs[1] ]]
    Z2 <- new_Z_list[[ idx_of_Z_pairs[2] ]]

    all_comps <- apply(perm_col_orders, 1, function(col_ord) {
                       compare_by_col_order(Z1, Z2, col_ord) })
    min(all_comps)
  }

  ### Length of (new) Z_list
  N <- length(new_Z_list)

  ### Get index All Pairs of (Z1, Z2) from Z_list
  idx_of_all_pairs <- combn(N, 2)

  ### Get distance btwn all pairs of (Z1, Z2) from Z_list
  dist_btwn_all_pairs <- apply(idx_of_all_pairs, 2, function(idx_of_pair) {
    list(idx=idx_of_pair, dist=compare(idx_of_pair))
  })

  ### Distance matrix
  D <- matrix(0, N, N)

  for (x in dist_btwn_all_pairs) {
    D[x$idx[1], x$idx[2]] <- x$dist
    D[x$idx[2], x$idx[1]] <- x$dist
  }

  Z_list[[which.min(rowSums(D))]]
}

#### Example
##rand <- function(n,k) {
##  matrix(sample(0:1, n*k, replace=TRUE), n, k)
##}
###Zl <- list(rand(2,2), rand(2,2), rand(2,2))
##Zl <- lapply(as.list(1:100), function(i) rand(32,4))
##print(est <- est_Z(Zl))

#' @useDynLib cytof3
#' @import rcommon
#' @import foreach
#' @import doMC
#' @importFrom Rcpp evalCpp
#' @exportPattern "^[[:alpha:]]+"
#### ORIGINAL NAMESPACE FILE #######
# useDynLib(cytof3)
# importFrom(Rcpp, evalCpp)
# exportPattern("^[[:alpha:]]+")
####################################
#NULL
Rcpp::loadModule("Cytof_Module", TRUE)

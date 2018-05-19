library(rscala)
scala()

sourceScala = function(f) {
  s %@% paste0(readLines(f), collapse='\n')
}

##################################

### Source scala functions ###
sourceScala("scala-util.scala")

rListMat2Scala = function(x, n=NULL) {
  n = as.integer(sapply(x, NROW))
  x = Reduce(rbind, x)

  s %!% '
    sepBigMat(x, n)
  '
}

#x_ls = list(matrix(1,3,5), matrix(2,3,5))
#s$m = rListMat2Scala(x_ls)
#s %~% 'm(0)'

#' Adjusted Rand Index
#' For comparing two clusterings or partitions
#' Higher scores are better. Best score is 1.
#' See: https://en.wikipedia.org/wiki/Rand_index
#' @export
ari = function(x,y) {
  x = as.vector(x)
  y = as.vector(y)
  n = length(x)
  stopifnot(n == length(y))

  tab = table(x,y)
  index = sum(choose(tab, 2))

  rowSumsChoose2.sum = sum(choose(rowSums(tab), 2))
  colSumsChoose2.sum = sum(choose(colSums(tab), 2))

  expected.index = rowSumsChoose2.sum * colSumsChoose2.sum / choose(n, 2)
  max.index = mean(c(rowSumsChoose2.sum, colSumsChoose2.sum))

  (index - expected.index) / (max.index - expected.index)
}

# Tests:
#x <- rep(c(rep(1,10), 2, rep(2,10)), 10000)
#y <- rep(c(rep(1,10), 2, rep(3,10)), 10000)
#st = system.time({
#  print(ari(x,y))
#  print(ari(y,x))
#  print(mclust::adjustedRandIndex(x,y))
#})
#print(st)

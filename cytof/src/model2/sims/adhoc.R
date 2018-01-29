library(cytof2)
library(doMC)
registerDoMC(as.numeric(system("nproc",intern=TRUE)))

adhoc = function(Y, K_min=1, K_max=10, reps=5, lam=1, ...) {
  grid = expand.grid(K_min:K_max, 1:reps)
  N = nrow(grid)

  out = foreach(i=1:N) %dopar% {
    k = grid[i,1]
    #km = kmeans((Y>0)*lam, k, ...)
    #Z = t((km$centers>lam/2) * 1)
    km = kmeans(Y*lam, k, ...)
    Z = t((km$centers>0) * 1)
    Z.unique = unique(Z,MARGIN=2)
    list(km=km, Z=Z.unique)
  }


  bad_idx = which(sapply(out, function(o) is.na(sum(o$Z))))
  if (length(bad_idx)) out[-bad_idx] else out
}

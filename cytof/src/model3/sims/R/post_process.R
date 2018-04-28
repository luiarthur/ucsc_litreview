load('checkpoint.rda')
B = length(out)

library(cytof3)

### Probability of non-expression for missing y
pz0_missy = matrix(NA, I, J)

f = function(i,j,b) {
  lami = out[[b]]$lam[[i]] + 1
  lami = lami[which(is.na(y[[i]][,j]))]
  mean(out[[b]]$Z[j,lami])
}


for (i in 1:I) for (j in 1:J) {
  pz0_missy_ij = sapply(1:B, function(b) f(i,j,b))
  pz0_missy_ij_mean = mean(pz0_missy_ij)
  pz0_missy[i,j] = pz0_missy_ij_mean
}

print(round(t(pz0_missy),2))
my.image(pz0_missy, addL=TRUE)

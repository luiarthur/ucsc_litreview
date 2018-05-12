### For sim ###
load('checkpoint.rda')
### For cb ###
#out = readRDS('out.rds')
#I=3; J=32
#y = readRDS('../../data/cytof_cb.rds')

B = length(out)

library(cytof3)

### Probability of non-expression for missing y
pz0_missy = matrix(NA, I, J)

f = function(i,j,b) {
  lami = out[[b]]$lam[[i]] + 1
  lami = lami[which(is.na(y[[i]][,j]))]
  mean(out[[b]]$Z[j,lami] == 0)
}


for (i in 1:I) for (j in 1:J) {
  pz0_missy_ij = sapply(1:B, function(b) f(i,j,b))
  pz0_missy_ij_mean = mean(pz0_missy_ij)
  pz0_missy[i,j] = pz0_missy_ij_mean
}

sink('pz0_missing_y.txt')
print(round(t(pz0_missy),2))
sink()

### Principal Components to visualize clusters ###
lamToChar = function(x) strsplit(rawToChar(as.raw(x + 65)), '')[[1]]

py = lapply(last(out)$missing_y, prcomp)
idx_best = sapply(1:I, function(i) estimate_ZWi_index(out, i))
i = 1
Wi = out[[idx_best[i]]]$W[i,]
bigK = which(Wi > .05)
lami = out[[idx_best[i]]]$lam[[i]]
plot(py[[i]]$x[which(lami %in% bigK),1:2], 
     col=lami[which(lami %in% bigK)],
     pch=lamToChar(lami[which(lami %in% bigK)]), cex=.7)
#plot(py[[i]]$x[,1:2], col=rgb(0,0,1,.3), pch=lamToChar(lam[[i]]), cex=.7)
#table(lamToChar(lam[[i]])) / sum(table(lamToChar(lam[[i]])))
#round(out[[idx_best[i]]]$W[i,], 4)


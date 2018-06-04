library(xtable)

y = readRDS('../data/cytof_cb.rds')

xtab=xtable(y[[1]][1:3,1:7])
print(xtab, floating=FALSE, NA.string="NA")

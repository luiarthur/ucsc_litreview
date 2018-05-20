library(cytof3)
library(FlowSOM)

load('../../out/sim_locked_beta1_K20_N500_sensK5/checkpoint.rda')
best_idx.K5 = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam.K5 = sapply(1:I, function(i) out[[ best_idx[i] ]]$lam[[i]])

load('../../out/sim_locked_beta1_K20_N500_sensK10/checkpoint.rda')
best_idx.K10 = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam.K10 = sapply(1:I, function(i) out[[ best_idx[i] ]]$lam[[i]])

load('../../out/sim_locked_beta1_K20_N500_sensK20/checkpoint.rda')
best_idx.K20 = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam.K20 = sapply(1:I, function(i) out[[ best_idx[i] ]]$lam[[i]])

true_lam = dat$lam

FMeasure(unlist(true_lam), unlist(best_lam.K5))
FMeasure(unlist(true_lam), unlist(best_lam.K10))
FMeasure(unlist(true_lam), unlist(best_lam.K20))

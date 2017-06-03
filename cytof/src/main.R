library(rcommon)
source("cytof.R")
source("../dat/readExpression.R")
source("../dat/myimage.R")

### PATH to DATA ###
PATH <- "../dat/cytof_data_lili/cytof_data_lili/"

### PATIENT 5 DATA ###
pat5_d54 <- read.expression.file(paste0(PATH,"patients/005_D54_CLEAN.csv"))
pat5_d70 <- read.expression.file(paste0(PATH,"patients/005_D70_CLEAN.csv"))
pat5_d93 <- read.expression.file(paste0(PATH,"patients/005_D93_CLEAN.csv"))

### Read Cutoff Files ###
pat5_d54_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D54_CLEAN_cutoff.csv"))
pat5_d70_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D70_CLEAN_cutoff.csv"))
pat5_d93_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D93_CLEAN_cutoff.csv"))

### PATIENT 5
pat5 <- list(pat5_d54=pat5_d54, pat5_d70=pat5_d70, pat5_d93=pat5_d93)
pat5_cutoff <- list(pat5_d54=pat5_d54_cutoff, 
                    pat5_d70=pat5_d70_cutoff, 
                    pat5_d93=pat5_d93_cutoff)
stopifnot(all.equal(names(pat5), names(pat5_cutoff)))

I <- length(pat5)
y <- lapply(as.list(1:I), function(i)
            as.matrix(log( pat5[[i]]/pat5_cutoff[[i]] + 1)))

p <- .05
N_i <- sapply(y, nrow)
train_idx <- sapply(N_i, function(N) sample(1:N, round(N*p)))
y_TE <- lapply(as.list(1:I), function(i) y[[i]][-train_idx[[i]],])
y_TR <- lapply(as.list(1:I), function(i) y[[i]][ train_idx[[i]],])

set.seed(1)
library(rcommon)
source("cytof.R")
out <- cytof(y_TE, y_TR, burn_small=100, K_min=2, K_max=3, burn=100, B=200, pr=1)

psi <- t(sapply(out, function(o) o$psi))
plotPost(psi[,32])
plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
     ylim=0:1, main="Acceptance rate for psi")
abline(h=c(.25, .4), col='grey')

Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
my.image(Z_mean >= .4)

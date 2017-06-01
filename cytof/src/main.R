library(rcommon)
source("cytof.R")
source("../dat/readExpression.R")

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
source("cytof.R")
out <- cytof(y_TE, y_TR, burn_small=200, K_max=10, burn=30, B=30, pr=1)

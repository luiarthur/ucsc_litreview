#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(xtable) # print_bmat
library(cytof2)

### Declaring global vars ###
if (length(args) < 1) {
  stop('usage: Rscript post_process.R OUTDIR')
}

OUTDIR = args[1]
fileDest = function(name) paste0(OUTDIR, name)
### Finished declaring global vars ###

print_bmat = function(X, file, ...) {
  # Prints a matrix to tex file
  # requires xtable
  sink(file)
  xtab = xtable(X, align=rep("", ncol(X)+1), ...)
  print(xtab, floating=FALSE, tabular.environment="bmatrix", 
        hline.after=NULL, include.rownames=FALSE, include.colnames=FALSE)
  sink()
}


load(fileDest('sim_result.RData'))
print_bmat(dat$W, fileDest("W_truth.tex"), digits=3)
print_bmat(matApply(lapply(out, function(o) o$W), mean),
           fileDest("W_mean.tex"), digits=3)


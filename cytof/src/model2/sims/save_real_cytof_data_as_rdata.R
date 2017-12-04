library(cytof2)

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop('usage: Rscript  save_cytof_data.R  <path-to-cytof-data> <where-to-save-rdata>')
}

#PATH = "../../../dat/cytof_data_lili/cytof_data_lili/cb/"
PATH = args[1]
#OUT_RDATA = "dat/cytof_cb.RData"
OUT_RDATA = args[2]

transform_data <- function(dat, co) {
  y <- as.matrix(t(log(t(dat) / co)))
  ifelse(y == -Inf, NA, y)
}

dat <- read.expression.in.dir(PATH)
cutoff <- read.cutoff.in.dir(PATH)

I <- length(dat)
J <- NCOL(dat[[1]])

y <- lapply(as.list(1:I), function(i) transform_data(dat[[i]], cutoff[[i]]))
save(y, OUT_RDATA)

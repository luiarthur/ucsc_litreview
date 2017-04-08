library(rcommon)
source("myimage.R")

parse_marker <- function(x) {
  x <- toupper(gsub("[-|.]","",x))
  x <- toupper(gsub("^KIR","",x))
  x <- toupper(gsub("^X","",x))
  x
}

order_col <- function(x, trans=identity) {
  colnames(x) <- trans(colnames(x))
  x[,order(colnames(x))] 
}

# Analyze patients/005_D93_CLEAN_cutoff.csv (preped by me)
path <- "cytof_data_lili/cytof_data_lili/patients/005_D93_CLEAN"
tmp <- read.csv(paste0(path,"_cutoff.csv"),header=FALSE);
markers <- parse_marker(levels(tmp[,1]))
cutoff <- tmp[,2]; names(cutoff) <- markers
cutoff <- cutoff[order(markers)]
markers <- names(cutoff)
rm(tmp)
patient <- order_col(read.csv(paste0(path,".csv")),parse_marker)

# Should be TRUE
all(colnames(patient) == names(cutoff)) && 
all(colnames(patient) == markers)

rbind(cutoff,apply(patient,2,quantile))

### CB ###
cb34 <- order_col(read.csv("cytof_data_lili/cytof_data_lili/cb/CB34_CLEAN.csv"),
                  parse_marker)
cb22 <- order_col(read.csv("cytof_data_lili/cytof_data_lili/cb/CBC22_CLEAN.csv"),
                  parse_marker)
cb23 <- order_col(read.csv("cytof_data_lili/cytof_data_lili/cb/CBC23_CLEAN.csv"),
                  parse_marker)

# SHOULD BE TRUE
all(colnames(cb34) == markers) && 
all(colnames(cb22) == markers) &&
all(colnames(cb23) == markers)

# Quantiles
apply(cb34,2,quantile)
apply(cb22,2,quantile)
apply(cb23,2,quantile)


### PB ###
pb19 <- order_col(read.csv("cytof_data_lili/cytof_data_lili/pb/PB19_CMV+_CLEAN.csv"),parse_marker)
dim(pb19)

all(colnames(pb19) == markers)

apply(pb19,2,quantile)

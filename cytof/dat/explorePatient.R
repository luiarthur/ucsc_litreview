library(rcommon)
source("myimage.R")

parse_marker <- function(x) {
  x <- toupper(gsub("[-|.]","",x))
  x <- toupper(gsub("^KIR","",x))
  x <- toupper(gsub("^X","",x))
  x
}

# Analyze patients/005_D93_CLEAN_cutoff.csv (preped by me)
path <- "cytof_data_lili/cytof_data_lili/patients/005_D93_CLEAN"
tmp <- read.csv(paste0(path,"_cutoff.csv"),header=FALSE);
markers <- parse_marker(levels(tmp[,1]))
cutoff <- tmp[,2]; names(cutoff) <- markers
cutoff <- cutoff[order(markers)]
markers <- names(cutoff)
rm(tmp)

patient <- read.csv(paste0(path,".csv"))
colnames(patient) <- parse_marker(colnames(patient))
patient <- patient[,order(colnames(patient))]

setdiff(markers,colnames(patient))
setdiff(colnames(patient),markers)

all(colnames(patient) == names(cutoff))
all(colnames(patient) == markers)

rbind(cutoff,apply(patient,2,quantile))


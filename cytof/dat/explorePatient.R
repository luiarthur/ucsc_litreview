library(rcommon)
source("myimage.R")

parse_marker <- function(x) {
  toupper(gsub("[-|.]","",x))
}

# Analyze patients/005_D93_CLEAN_cutoff.csv (preped by me)
path <- "cytof_data_lili/cytof_data_lili/patients/005_D93_CLEAN"
tmp <- read.csv(paste0(path,"_cutoff.csv"),header=FALSE);
markers <- toupper(levels(tmp[,1]))
cutoff <- tmp[,2]; names(cutoff) <- markers
cutoff <- cutoff[order(markers)]
rm(tmp)

patient <- read.csv(paste0(path,".csv"))
colnames(patient) <- toupper(colnames(patient))
patient <- patient[,order(colnames(patient))]

setdiff(markers,colnames(patient))
setdiff(colnames(patient),markers)

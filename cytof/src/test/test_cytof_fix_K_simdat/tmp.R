args <- commandArgs(trailingOnly=TRUE)

stopifnot(length(args) == 1)

OUT_DIR <- paste0("out", args, "/")

pdf(paste0(OUT_DIR, "out.pdf"))
plot(rnorm(100))
dev.off()

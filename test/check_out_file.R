args <- commandArgs(trailingOnly=TRUE)
x <- readRDS(args[1])
head(x)
nrow(x)
lapply(x, summary)

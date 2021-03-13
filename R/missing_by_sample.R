library(argparser)

# read arguments
argp <- arg_parser("Missing by sample")
argp <- add_argument(argp, "--gds_file", help="GDS file")
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argp <- add_argument(argp, "--variant_id", help="File with vector of variant IDs")
argp <- add_argument(argp, "--num_cores", help="Number of cores to utilize for parallel processing", default=1)
argv <- parse_args(argp)

# load libraries
library(SeqArray)
#library(ggplot2)

# log versions and arguments for reproducibility
sessionInfo()
print(argv)

# open GDS file
gds <- seqOpen(argv$gds_file)

# select variants
if (!is.na(argv$variant_id)) {
    variant.id <- readRDS(argv$variant_id)
    seqSetFilter(gds, variant.id=variant.id)
}

# missing call rate
# the SeqVarTools missingGenotypeRate is merely a wrapper around seqMissing
missing.rate <- seqMissing(gds, per.variant=FALSE, parallel=argv$num_cores)
sample.id <- seqGetData(gds, "sample.id")

miss.df <- data.frame(sample.id, missing.rate, stringsAsFactors=FALSE)

outfile <- "missing_by_sample.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(miss.df, file=outfile)

# plot
## p <- ggplot(miss.df, aes(missing.rate)) +
##     geom_histogram(binwidth=0.01, boundary=0)
## ggsave(paste0(argv$out_prefix, "missing_by_sample.pdf"), plot=p)

seqClose(gds)

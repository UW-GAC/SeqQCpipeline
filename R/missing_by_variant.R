library(argparser)

# read arguments
argp <- arg_parser("Missing by variant")
argp <- add_argument(argp, "--gds_file", help="GDS file")
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argp <- add_argument(argp, "--sample_id", help="File with vector of sample IDs")
argp <- add_argument(argp, "--variant_id", help="File with vector of variant IDs")
argp <- add_argument(argp, "--cpu", help="Number of CPUs to utilize for parallel processing", default=1)
argv <- parse_args(argp)

# load libraries
library(SeqArray)
library(ggplot2)

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

# select samples
if (!is.na(argv$sample_id)) {
    sample.id <- readRDS(argv$sample_id)
    seqSetFilter(gds, sample.id=sample.id)
}

# missing call rate
# the SeqVarTools missingGenotypeRate is merely a wrapper around seqMissing
missing.rate <- seqMissing(gds, per.variant=TRUE, parallel=argv$cpu)
variant.id <- seqGetData(gds, "variant.id")

miss.df <- data.frame(variant.id, missing.rate, stringsAsFactors=FALSE)

outfile <- "missing_by_variant.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(miss.df, file=outfile)

seqClose(gds)


# plot
p <- ggplot(miss.df, aes(missing.rate)) +
    geom_histogram(binwidth=0.01, boundary=0)

outfile <- "missing_by_variant.pdf"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
ggsave(outfile, plot=p)

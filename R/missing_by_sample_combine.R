library(argparser)

# read arguments
argp <- arg_parser("Combine missing rate by chromosome")
argp <- add_argument(argp, "--in_file", help="files with missing by chrom", nargs=Inf)
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argv <- parse_args(argp)

# load libraries
library(dplyr)
library(ggplot2)
sessionInfo()

# log versions and arguments for reproducibility
sessionInfo()
print(argv)

miss.df <- lapply(argv$in_file, readRDS) %>%
    bind_rows() %>%
    group_by(sample.id) %>%
    summarise(missing.rate=sum(missing.rate*n)/sum(n))


outfile <- "missing_by_sample.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(miss.df, file=outfile)


# plot
p <- ggplot(miss.df, aes(missing.rate)) +
    geom_histogram(binwidth=0.01, boundary=0)

outfile <- "missing_by_sample.pdf"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
ggsave(outfile, plot=p)

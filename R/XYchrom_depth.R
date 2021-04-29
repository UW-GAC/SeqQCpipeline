library(argparser)

# read arguments
argp <- arg_parser("Coverage by chromosome")
argp <- add_argument(argp, "--coverage_file", help="output file from samtools coverage", nargs=Inf)
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argv <- parse_args(argp)

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
sessionInfo()

# log versions and arguments for reproducibility
sessionInfo()
print(argv)

infile <- argv$coverage_file

# process all input files
dat <- lapply(infile, function(f) {
    sample <- basename(sub("_coverage.txt", "", f))

    cov <- read.table(f, as.is=T, header=T, comment.char="")
    names(cov)[1] <- "rname"

    # calcuate mean autosomal depth
    auto <- cov %>%
        filter(rname %in% paste0("chr", 1:22)) %>%
        summarise(meandepth=sum(endpos*meandepth)/sum(endpos)) %>%
        mutate(sample=sample, rname="auto")

    # keep, X, Y, and autosomal
    cov %>%
        filter(rname %in% c("chrX", "chrY")) %>%
        mutate(sample=sample) %>%
        select(sample, rname, meandepth) %>%
        bind_rows(auto)
}) %>%
    bind_rows() %>%
    pivot_wider(names_from=rname, values_from=meandepth) %>%
    rename(X_depth=chrX, Y_depth=chrY, auto_depth=auto) %>%
    mutate(X_norm_depth=X_depth/auto_depth, Y_norm_depth=Y_depth/auto_depth)

outfile <- "norm_depth.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(dat, file=outfile)

p <- ggplot(dat, aes(X_norm_depth, Y_norm_depth)) +
    geom_point() +
    xlab("normalized X chrom depth") +
    ylab("normalized Y chrom depth")

outfile <- "XYchr_norm_depth.pdf"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
ggsave(outfile, plot=p)

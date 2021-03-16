library(argparser)

# read arguments
argp <- arg_parser("Heterozygosity by sample")
argp <- add_argument(argp, "--gds_file", help="GDS file")
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argp <- add_argument(argp, "--maf_min", help="minimum MAF of variants to use", default=0)
argp <- add_argument(argp, "--maf_max", help="maximum MAF of variants to use", default=0.5)
argp <- add_argument(argp, "--no_pass_filter", help="use variants with a filter value other than PASS", flag=TRUE)
argp <- add_argument(argp, "--cpu", help="Number of CPUs to utilize for parallel processing", default=1)
argv <- parse_args(argp)

# load libraries
library(SeqVarTools)
sessionInfo()

# log versions and arguments for reproducibility
sessionInfo()
print(argv)

# open GDS file
gds <- seqOpen(argv$gds_file)

# filter by PASS
if (!argv$no_pass_filter) {
    filt <- seqGetData(gds, "annotation/filter")
    seqSetFilter(gds, variant.sel=(filt == "PASS"))
}

# filter by MAF
if (argv$maf_min > 0 | argv$maf_max < 0.5) {
    seqSetFilterCond(gds, maf=c(argv$maf_min, argv$maf_max), parallel=argv$cpu)
}

het <- heterozygosity(gds, margin="by.sample", use.names=FALSE)
sample.id <- seqGetData(gds, "sample.id")

het.df <- data.frame(sample.id, het, stringsAsFactors=FALSE)

outfile <- "het_by_sample.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(het.df, file=outfile)

seqClose(gds)

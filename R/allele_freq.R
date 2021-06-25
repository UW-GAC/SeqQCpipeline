library(argparser)

# read arguments
argp <- arg_parser("Allele frequency and count")
argp <- add_argument(argp, "--gds_file", help="GDS file")
argp <- add_argument(argp, "--out_prefix", help="Prefix for output files", default="")
argp <- add_argument(argp, "--sample_adf", help="AnnotatedDataFrame with sex of samples, for correctly computing count and frequency of alleles on sex chromosomes")
argp <- add_argument(argp, "--genome_build", help="genome build for identifying PAR regions on sex chromosomes", default="hg38")
argp <- add_argument(argp, "--sample_id", help="File with vector of sample IDs")
argp <- add_argument(argp, "--variant_id", help="File with vector of variant IDs")
argp <- add_argument(argp, "--cpu", help="Number of CPUs to utilize for parallel processing", default=1)
argv <- parse_args(argp)

# load libraries
library(SeqArray)
library(SeqVarTools)
library(ggplot2)

# log versions and arguments for reproducibility
sessionInfo()
print(argv)

# open GDS file
gds <- seqOpen(argv$gds_file)

# if AnnotatedDataFrame is provided, create a SeqVarData object
if (!is.na(argv$sample_adf)) {
    annot <- readRDS(argv$sample_adf)
    gds <- SeqVarData(gds, sampleData=annot)
    sex.adjust <- TRUE
} else {
    sex.adjust <- FALSE
}

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

# if we are adjusting for sex, do separate callsto each function
# otherwise, just divide by total number of alleles
if (sex.adjust) {
    count <- alleleCount(gds, genome.build=argv$genome_build, parallel=argv$cpu)
    freq <- alleleFrequency(gds, genome.build=argv$genome_build, parallel=argv$cpu)
    MAC <- minorAlleleCount(gds, genome.build=argv$genome_build, parallel=argv$cpu)
} else {
    count <- alleleCount(gds, parallel=argv$cpu)
    n <- SeqVarTools:::.nSamp(gds)
    freq <- count / (2*n)
    MAC <- pmin(count, 2*n - count)
}
MAF <- pmin(freq, 1 - freq)

variant.id <- seqGetData(gds, "variant.id")

freq.df <- data.frame(variant.id, count, MAC, freq, MAF, stringsAsFactors=FALSE)

outfile <- "allele_freq.rds"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
saveRDS(freq.df, file=outfile)

seqClose(gds)


# plot
p <- ggplot(freq.df, aes(MAF)) +
    geom_histogram(binwidth=0.01, boundary=0)

outfile <- "allele_freq.pdf"
if (nchar(argv$out_prefix) > 0) {
    outfile <- paste(argv$out_prefix, outfile, sep="_")
}
ggsave(outfile, plot=p)

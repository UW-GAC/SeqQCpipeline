#! /bin/bash

BASE_PATH=$1

# basic
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/gds/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  < $BASE_PATH/R/allele_freq.R

R -q --vanilla --args test_allele_freq.rds \
  < $BASE_PATH/test/check_out_file.R


# arguments
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/gds/1KG_phase3_subset_chrX.gds \
  --out_prefix test \
  --sample_adf $BASE_PATH/test/data/gds/1KG_phase3_subset_annot.rds \
  --genome_build hg19 \
  --variant_id $BASE_PATH/test/data/gds/variant_include.rds \
  --sample_id $BASE_PATH/test/data/gds/sample_include.rds \
  --cpu 2 \
  < $BASE_PATH/R/allele_freq.R

R -q --vanilla --args test_allele_freq.rds \
  < $BASE_PATH/test/check_out_file.R

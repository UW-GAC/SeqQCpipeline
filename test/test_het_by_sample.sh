#! /bin/bash

BASE_PATH=$1

# basic
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  < $BASE_PATH/R/het_by_sample.R

R -q --vanilla --args test_het_by_sample.rds \
  < $BASE_PATH/test/check_out_file.R


# MAF range, parallel
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  --maf_min 0.01 --maf_max 0.45 \
  --cpu 2 \
  < $BASE_PATH/R/het_by_sample.R

R -q --vanilla --args test_het_by_sample.rds \
  < $BASE_PATH/test/check_out_file.R


# no-pass variants
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  --maf_min 0.01 \
  --no_pass_filter \
  < $BASE_PATH/R/het_by_sample.R

R -q --vanilla --args test_het_by_sample.rds \
  < $BASE_PATH/test/check_out_file.R

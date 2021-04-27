#! /bin/bash

BASE_PATH=$1

R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/gds/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  < $BASE_PATH/R/missing_by_sample.R

R -q --vanilla --args test_missing_by_sample.rds \
  < $BASE_PATH/test/check_out_file.R

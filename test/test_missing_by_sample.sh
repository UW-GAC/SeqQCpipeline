#! /bin/bash

BASE_PATH=$1

R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/gds/1KG_phase3_subset_chr22.gds \
  --out_prefix test \
  < $BASE_PATH/R/missing_by_sample.R

R -q --vanilla --args test_missing_by_sample.rds \
  < $BASE_PATH/test/check_out_file.R

# combine
R -q --vanilla --args \
  --gds_file $BASE_PATH/test/data/gds/1KG_phase3_subset_chr21.gds \
  --out_prefix test_chr21 \
  < $BASE_PATH/R/missing_by_sample.R

R -q --vanilla --args \
  --in_file test_missing_by_sample.rds test_chr21_missing_by_sample.rds \
  --out_prefix test \
  < $BASE_PATH/R/missing_by_sample_combine.R

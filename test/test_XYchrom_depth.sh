#! /bin/bash

BASE_PATH=$1

# basic
R -q --vanilla --args \
  --coverage_file $BASE_PATH/test/data/coverage/*_coverage.txt \
  --out_prefix test \
  < $BASE_PATH/R/XYchrom_depth.R

R -q --vanilla --args test_norm_depth.rds \
  < $BASE_PATH/test/check_out_file.R

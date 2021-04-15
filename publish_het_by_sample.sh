#! /bin/bash

sbpull bdc smgogarten/qc-for-gwas-development/heterozygosity-by-sample heterozygosity-by-sample.cwl

# git commit
# git push

sbpack bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample heterozygosity-by-sample.cwl

sbpack bdc smgogarten/uw-gac-commit/heterozygosity-by-sample heterozygosity-by-sample.cwl

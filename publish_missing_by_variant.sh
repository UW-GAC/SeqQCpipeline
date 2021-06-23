#! /bin/bash

sbpull bdc smgogarten/qc-for-gwas-development/missing-rate-by-variant missing_rate_by_variant.cwl

# git commit
# git push

# push tool to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-variant missing_rate_by_variant.cwl

# push tool to commit
sbpack bdc smgogarten/uw-gac-commit/missing-rate-by-variant missing_rate_by_variant.cwl

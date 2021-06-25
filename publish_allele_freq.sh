#! /bin/bash

sbpull bdc smgogarten/qc-for-gwas-development/allele-frequency allele_frequency.cwl

# git commit
# git push

# push tool to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/allele-frequency allele_frequency.cwl

# push tool to commit
sbpack bdc smgogarten/uw-gac-commit/allele-frequency allele_frequency.cwl

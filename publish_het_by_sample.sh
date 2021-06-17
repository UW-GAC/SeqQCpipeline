#! /bin/bash

sbpull bdc smgogarten/qc-for-gwas-development/heterozygosity-by-sample-wf heterozygosity-by-sample-wf.cwl --unpack

# git commit
# git push

# push tools to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample.cwl
sbpack bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample-combine heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample_combine.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample.cwl
sbpull bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample-combine heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample_combine.cwl

# push workflow to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/heterozygosity-by-sample-wf heterozygosity-by-sample-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/heterozygosity-by-sample heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample.cwl
sbpack bdc smgogarten/uw-gac-commit/heterozygosity-by-sample-wf heterozygosity-by-sample-wf.cwl

#! /bin/bash

sbpull bdc smgogarten/qc-for-gwas-development/missing-rate-by-sample-wf missing-rate-by-sample-wf.cwl --unpack

# git commit
# git push

# push tools to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-sample missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample.cwl
sbpack bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-sample-combine missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample_combine.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-sample missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample.cwl
sbpull bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-sample-combine missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample_combine.cwl

# push workflow to pre-build
sbpack bdc smgogarten/qc-for-gwas-pre-build/missing-rate-by-sample-wf missing-rate-by-sample-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/missing-rate-by-sample missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample.cwl
sbpack bdc smgogarten/uw-gac-commit/missing-rate-by-sample-wf missing-rate-by-sample-wf.cwl

cwlVersion: v1.2
class: Workflow
label: Missing rate by sample
doc: |-
  This tool calculates missing rate by sample over multiple input files in parallel (e.g., per-chromosome files) and combines the results. A subset of variants may be specified.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -432.39886474609375
  sbg:y: -50.5
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -316.39886474609375
  sbg:y: -197.5
- id: variant_id
  label: Variant ID file
  doc: RDS file with vector of variant IDs.
  type: File?
  sbg:x: -476
  sbg:y: -193
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '1'

outputs:
- id: missing_by_sample
  label: missing rate by sample
  doc: RDS file with data.frame of sample.id and missing rate values
  type: File?
  outputSource:
  - missing_rate_by_sample_combine/missing_by_sample
  sbg:fileTypes: RDS
  sbg:x: 227.60113525390625
  sbg:y: 14.5
- id: plot
  label: Plot of missing rate by sample
  doc: PDF with histogram showing missing rate by sample
  type: File?
  outputSource:
  - missing_rate_by_sample_combine/plot
  sbg:fileTypes: PDF
  sbg:x: 196.60113525390625
  sbg:y: -122.5

steps:
- id: missing_rate_by_sample
  label: Missing rate by sample
  in:
  - id: gds_file
    source: gds_file
  - id: out_prefix
    valueFrom: ${inputs.gds_file.nameroot}
  - id: variant_id
    source: variant_id
  - id: cpu
    source: cpu
  scatter:
  - gds_file
  run: missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample.cwl
  out:
  - id: missing_by_sample
  - id: plot
  sbg:x: -272
  sbg:y: -44
- id: missing_rate_by_sample_combine
  label: Missing rate by sample - combine
  in:
  - id: in_file
    source:
    - missing_rate_by_sample/missing_by_sample
  - id: out_prefix
    source: out_prefix
  run: missing-rate-by-sample-wf.cwl.steps/missing_rate_by_sample_combine.cwl
  out:
  - id: missing_by_sample
  - id: plot
  sbg:x: -15
  sbg:y: -23
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Quality Control
sbg:content_hash: ac767099ec2b998d7579359a38e944b4acfc1fedb6eed7b525493a0bea2033eb2
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1623894386
sbg:id: smgogarten/qc-for-gwas-development/missing-rate-by-sample-wf/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623957506
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/missing-rate-by-sample-wf/4/raw/
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: add documentation
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623894386
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623894581
  sbg:revision: 1
  sbg:revisionNotes: missing rate workflow
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623895058
  sbg:revision: 2
  sbg:revisionNotes: expose cpu parameter
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954655
  sbg:revision: 3
  sbg:revisionNotes: use tagged commit
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623957506
  sbg:revision: 4
  sbg:revisionNotes: add documentation
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC QC for GWAS
sbg:validationErrors: []

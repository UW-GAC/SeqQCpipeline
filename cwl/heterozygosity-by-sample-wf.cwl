cwlVersion: v1.2
class: Workflow
label: Heterozygosity by sample
doc: |-
  This workflow calculates heterozygosity by sample over multiple input files in parallel (e.g., per-chromosome files) and combines the results. Variants to use in the calculation are restricted to FILTER=PASS by default. MAF thresholds may also be set.
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
  sbg:x: -450
  sbg:y: -59
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -389.39886474609375
  sbg:y: -181.5
- id: maf_min
  label: Minimum MAF
  doc: Minimum MAF of variants to use for calculating heterozygosity
  type: float?
  sbg:exposed: true
- id: maf_max
  label: Maximum MAF
  doc: Maximum MAF of variants to use for calculating heterozygosity
  type: float?
  sbg:exposed: true
- id: pass_only
  label: PASS only
  doc: Use only variants with a FILTER value of PASS for calculating heterozygosity
  type: boolean?
  sbg:exposed: true
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  sbg:exposed: true

outputs:
- id: het_by_sample
  label: heterozygosity by sample
  doc: RDS file with data.frame of sample.id and heterozygosity values
  type: File?
  outputSource:
  - heterozygosity_by_sample_combine/het_by_sample
  sbg:fileTypes: RDS
  sbg:x: 210.60113525390625
  sbg:y: 33.5
- id: plot
  label: Plot of heterozygosity by sample
  doc: PDF with histogram showing heterozygosity by sample
  type: File?
  outputSource:
  - heterozygosity_by_sample_combine/plot
  sbg:fileTypes: PDF
  sbg:x: 190.60113525390625
  sbg:y: -123.5

steps:
- id: heterozygosity_by_sample
  label: Heterozygosity by sample
  in:
  - id: gds_file
    source: gds_file
  - id: out_prefix
    valueFrom: ${inputs.gds_file.nameroot}
  - id: maf_min
    source: maf_min
  - id: maf_max
    source: maf_max
  - id: pass_only
    source: pass_only
  - id: cpu
    source: cpu
  scatter:
  - gds_file
  run: heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample.cwl
  out:
  - id: het_by_sample
  - id: plot
  sbg:x: -251
  sbg:y: -42
- id: heterozygosity_by_sample_combine
  label: ' Heterozygosity by sample - combine'
  in:
  - id: in_file
    source:
    - heterozygosity_by_sample/het_by_sample
  - id: out_prefix
    source: out_prefix
  run: heterozygosity-by-sample-wf.cwl.steps/heterozygosity_by_sample_combine.cwl
  out:
  - id: het_by_sample
  - id: plot
  sbg:x: -21
  sbg:y: -26
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Quality Control
sbg:content_hash: a0771561d2a46dd3f991e62b3575db82b3805e1da66a2fa296c21c998cf9fa1ab
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1623888117
sbg:id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample-wf/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623954716
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/heterozygosity-by-sample-wf/4/raw/
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: use tagged commit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623888117
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623888461
  sbg:revision: 1
  sbg:revisionNotes: workflow to combine het_by_sample results
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623892057
  sbg:revision: 2
  sbg:revisionNotes: use input file name to set output file prefix for per-chrom files
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623952587
  sbg:revision: 3
  sbg:revisionNotes: add documentation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954716
  sbg:revision: 4
  sbg:revisionNotes: use tagged commit
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC QC for GWAS
sbg:validationErrors: []

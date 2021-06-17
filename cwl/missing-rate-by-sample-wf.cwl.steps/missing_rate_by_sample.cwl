cwlVersion: v1.2
class: CommandLineTool
label: Missing rate by sample
doc: |-
  This tool calculates missing rate by sample. A subset of variants may be specified.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: ${ return inputs.cpu }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file.
  type: File
  inputBinding:
    prefix: --gds_file
    position: 0
    shellQuote: false
  sbg:category: Input files
  sbg:fileTypes: GDS
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  inputBinding:
    prefix: --out_prefix
    position: 1
    shellQuote: false
  sbg:category: Input Options
- id: variant_id
  label: Variant ID file
  doc: RDS file with vector of variant IDs.
  type: File?
  inputBinding:
    prefix: --variant_id
    position: 1
    shellQuote: false
  sbg:category: Input Options
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  inputBinding:
    prefix: --cpu
    position: 5
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'

outputs:
- id: missing_by_sample
  label: Missing rate by sample
  doc: RDS file with data.frame of sample.id and missing rate values
  type: File?
  outputBinding:
    glob: '*.rds'
  sbg:fileTypes: RDS
- id: plot
  label: Plot of missing rate by sample
  doc: PDF with histogram showing missing rate by sample
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- wget
- |-
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/b56e3763ea156f1e8a160b6889cb045a543082a3/R/missing_by_sample.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: missing_by_sample.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: smgogarten/qc-for-gwas-development/missing-rate-by-sample/2
sbg:appVersion:
- v1.2
sbg:content_hash: abc6cd09e75fd84e10ee28fcc5449ac97bf43f63fadcddb91fcd2e7e7c809ff94
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1623893007
sbg:id: smgogarten/qc-for-gwas-development/missing-rate-by-sample/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623954583
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: use tagged commit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623893007
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623893526
  sbg:revision: 1
  sbg:revisionNotes: tool for missing rate
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954583
  sbg:revision: 2
  sbg:revisionNotes: use tagged commit
sbg:sbgMaintained: false
sbg:validationErrors: []

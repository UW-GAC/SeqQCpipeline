cwlVersion: v1.2
class: CommandLineTool
label: Missing rate by variant
doc: |-
  This tool calculates missing rate by variant. A subset of samples and/or variants may be specified.
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
  sbg:category: Input Files
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
  sbg:category: Input Files
  sbg:fileTypes: RDS
- id: sample_id
  label: sample ID file
  doc: RDS file with vector of sample IDs.
  type: File?
  inputBinding:
    prefix: --sample_id
    position: 1
    shellQuote: false
  sbg:category: Input Files
  sbg:fileTypes: RDS
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  default: 4
  inputBinding:
    prefix: --cpu
    position: 5
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: '4'

outputs:
- id: missing_by_variant
  label: Missing rate by variant
  doc: RDS file with data.frame of variant.id and missing rate values
  type: File?
  outputBinding:
    glob: '*.rds'
  sbg:fileTypes: RDS
- id: plot
  label: Plot of missing rate by variant
  doc: PDF with histogram showing missing rate by variant
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- wget
- |-
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/by_variant/R/missing_by_variant.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: missing_by_variant.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/missing-rate-by-variant/2/raw/
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Quality Control
sbg:content_hash: abf13f6651303575b0e186b110d6ce3727a59d0f82d6ae417bada979cac63f53c
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1624405790
sbg:id: smgogarten/qc-for-gwas-development/missing-rate-by-variant/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1624408085
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: add input file types
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624405790
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624406327
  sbg:revision: 1
  sbg:revisionNotes: missing by variant tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624408085
  sbg:revision: 2
  sbg:revisionNotes: add input file types
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC QC for GWAS
sbg:validationErrors: []

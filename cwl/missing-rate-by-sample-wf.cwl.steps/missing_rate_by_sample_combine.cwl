cwlVersion: v1.2
class: CommandLineTool
label: Missing rate by sample - combine
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InlineJavascriptRequirement

inputs:
- id: in_file
  label: Missing rate results files
  doc: Input RDS files with results of missing rate by sample tool.
  type: File[]
  inputBinding:
    prefix: --in_file
    position: 0
    shellQuote: false
  sbg:category: Input files
  sbg:fileTypes: RDS
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  inputBinding:
    prefix: --out_prefix
    position: 1
    shellQuote: false
  sbg:category: Input Options

outputs:
- id: missing_by_sample
  label: missing rate by sample
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
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/b56e3763ea156f1e8a160b6889cb045a543082a3/R/missing_by_sample_combine.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: missing_by_sample_combine.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: smgogarten/qc-for-gwas-development/missing-rate-by-sample-combine/2
sbg:appVersion:
- v1.2
sbg:content_hash: a913c4e8502d5304847e9bd6160cbf5ede532ba3882f2abf3af98ab3fe0160b2a
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1623894188
sbg:id: smgogarten/qc-for-gwas-development/missing-rate-by-sample-combine/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623954631
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: use tagged commit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623894188
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623894331
  sbg:revision: 1
  sbg:revisionNotes: missing combine tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954631
  sbg:revision: 2
  sbg:revisionNotes: use tagged commit
sbg:sbgMaintained: false
sbg:validationErrors: []

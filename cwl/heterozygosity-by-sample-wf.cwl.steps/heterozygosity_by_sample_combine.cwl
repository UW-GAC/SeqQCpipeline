cwlVersion: v1.2
class: CommandLineTool
label: ' Heterozygosity by sample - combine'
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InlineJavascriptRequirement

inputs:
- id: in_file
  label: Heterozygosity results files
  doc: Input RDS files with results of heterozygosity by sample tool.
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
- id: het_by_sample
  label: heterozygosity by sample
  doc: RDS file with data.frame of sample.id and heterozygosity values
  type: File?
  outputBinding:
    glob: '*.rds'
  sbg:fileTypes: RDS
- id: plot
  label: Plot of heterozygosity by sample
  doc: PDF with histogram showing heterozygosity by sample
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- wget
- |-
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/b56e3763ea156f1e8a160b6889cb045a543082a3/R/het_by_sample_combine.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: het_by_sample_combine.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample-combine/4
sbg:appVersion:
- v1.2
sbg:content_hash: a78b1d977797a2b252b29edbb65075af40c4d51d9011fd6725efe035b2da7b376
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1623887859
sbg:id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample-combine/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623954695
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: use tagged commit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623887859
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623888071
  sbg:revision: 1
  sbg:revisionNotes: tool to combine het_by_sample results
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623888241
  sbg:revision: 2
  sbg:revisionNotes: fix name of input file and make an array
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623891733
  sbg:revision: 3
  sbg:revisionNotes: fix name of R script
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954695
  sbg:revision: 4
  sbg:revisionNotes: use tagged commit
sbg:sbgMaintained: false
sbg:validationErrors: []

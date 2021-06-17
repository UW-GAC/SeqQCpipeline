cwlVersion: v1.2
class: CommandLineTool
label: Heterozygosity by sample
doc: |-
  This tool calculates heterozygosity by sample. Variants to use in the calculation are restricted to FILTER=PASS by default. MAF thresholds may also be set.
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
- id: maf_min
  label: Minimum MAF
  doc: Minimum MAF of variants to use for calculating heterozygosity
  type: float?
  inputBinding:
    prefix: --maf_min
    position: 2
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: '0'
- id: maf_max
  label: Maximum MAF
  doc: Maximum MAF of variants to use for calculating heterozygosity
  type: float?
  inputBinding:
    prefix: --maf_max
    position: 3
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: '0.5'
- id: pass_only
  label: PASS only
  doc: Use only variants with a FILTER value of PASS for calculating heterozygosity
  type: boolean?
  default: true
  inputBinding:
    position: 4
    valueFrom: |-
      ${
          if (!inputs.pass_only) {
              return '--no_pass_filter'
          } else {
              return ''
          }
      }
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: 'true'
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
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/b56e3763ea156f1e8a160b6889cb045a543082a3/R/het_by_sample.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: het_by_sample.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample/10
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Quality Control
sbg:content_hash: a4348d5bfacf88c0d3b527fc038f86b8282c17cb4a453bbf2f4ee85d1ff13aa44
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1615616553
sbg:id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample/10
sbg:image_url:
sbg:latestRevision: 10
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623954310
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: revert to wget, use tagged commit of R script
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615616553
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615617681
  sbg:revision: 1
  sbg:revisionNotes: first draft of tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616534026
  sbg:revision: 2
  sbg:revisionNotes: use $include instead of wget to fetch R script
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616534246
  sbg:revision: 3
  sbg:revisionNotes: go back to wget since $include is not recognized
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616536449
  sbg:revision: 4
  sbg:revisionNotes: add descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616563625
  sbg:revision: 5
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616738043
  sbg:revision: 6
  sbg:revisionNotes: add default label for pass_only
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1616739236
  sbg:revision: 7
  sbg:revisionNotes: add plot output
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623887774
  sbg:revision: 8
  sbg:revisionNotes: combine_chroms branch
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623953715
  sbg:revision: 9
  sbg:revisionNotes: use $include instead of wget
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623954310
  sbg:revision: 10
  sbg:revisionNotes: revert to wget, use tagged commit of R script
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC QC for GWAS
sbg:validationErrors: []

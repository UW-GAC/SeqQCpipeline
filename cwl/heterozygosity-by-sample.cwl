cwlVersion: v1.1
class: CommandLineTool
label: Heterozygosity by sample
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
  type: File
  inputBinding:
    prefix: --gds_file
    position: 0
    shellQuote: false
- id: out_prefix
  type: string?
  inputBinding:
    prefix: --out_prefix
    position: 1
    shellQuote: false
- id: maf_min
  type: float?
  inputBinding:
    prefix: --maf_min
    position: 2
    shellQuote: false
- id: maf_max
  type: float?
  inputBinding:
    prefix: --maf_max
    position: 3
    shellQuote: false
- id: pass_only
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
- id: cpu
  type: int?
  inputBinding:
    prefix: --cpu
    position: 5
    shellQuote: false

outputs:
- id: het_by_sample
  type: File?
  outputBinding:
    glob: '*.rds'
stdout: job.out.log

baseCommand:
- |-
  wget https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/master/R/het_by_sample.R &&
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: het_by_sample.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/heterozygosity-by-sample/1/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: ac81aa548c037e9b3dd7ca8cf2327bfff53cc666193b66d1eb83f1825ea4ebace
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1615616553
sbg:id: smgogarten/qc-for-gwas-development/heterozygosity-by-sample/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615617681
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: first draft of tool
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615616553
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615617681
  sbg:revision: 1
  sbg:revisionNotes: first draft of tool
sbg:sbgMaintained: false
sbg:validationErrors: []

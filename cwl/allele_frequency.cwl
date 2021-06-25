cwlVersion: v1.2
class: CommandLineTool
label: Allele frequency
doc: |-
  This tool calculates allele frequency and counts. Values for both the alternate allele (count, freq) and the minor allele (MAC, MAF) are returned. A subset of samples and/or variants may be specified. 

  If a sample annotation file containing an AnnotatedDataFrame with sample sex is provided, X chromosome frequency (excluding the PAR) will be calculated assuming the dosage of the specified allele for males is half that for females. Y chromosome frequency will be calculated using males only. If the GDS file does not contain sex chromosome variants, it is recommended to omit the sample annotation file to reduce run time.
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
- id: sample_adf
  label: Sample annotation file
  doc: |-
    RDS file with AnnotatedDataFrame containing 'sample.id' and 'sex' columns. If this file is provided, allele frequency and counts will be adjusted for sex of samples.
  type: File?
  inputBinding:
    prefix: --sample_adf
    position: 2
    shellQuote: false
  sbg:category: Input Files
  sbg:fileTypes: RDS
- id: genome_build
  label: Genome build
  doc: Genome build, used to define pseudo-autosomal region (PAR) for sex chromosomes.
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg18
    - hg19
    - hg38
  inputBinding:
    prefix: --genome_build
    position: 3
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: hg38
- id: variant_id
  label: Variant ID file
  doc: RDS file with vector of variant IDs.
  type: File?
  inputBinding:
    prefix: --variant_id
    position: 4
    shellQuote: false
  sbg:category: Input Files
  sbg:fileTypes: RDS
- id: sample_id
  label: sample ID file
  doc: RDS file with vector of sample IDs.
  type: File?
  inputBinding:
    prefix: --sample_id
    position: 5
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
    position: 6
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: '4'

outputs:
- id: allele_freq
  label: Allele frequency and counts
  doc: |-
    RDS file with data.frame of variant.id, alternate allele count, MAC, alternate allele frequency, and MAF
  type: File?
  outputBinding:
    glob: '*.rds'
  sbg:fileTypes: RDS
- id: plot
  label: Plot of MAF
  doc: PDF with histogram showing minor allele frequency
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- wget
- |-
  https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/2d7a4620ab48b20be877756fbb45c8fbbd091554/R/allele_freq.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: allele_freq.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/allele-frequency/2/raw/
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Quality Control
sbg:content_hash: ab77ebafac060d392ea08228e50280e926e8dae804041c97095e067e8e76f78fa
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1624654928
sbg:id: smgogarten/qc-for-gwas-development/allele-frequency/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1624659625
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: update description
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624654928
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624656428
  sbg:revision: 1
  sbg:revisionNotes: allele frequency tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1624659625
  sbg:revision: 2
  sbg:revisionNotes: update description
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC QC for GWAS
sbg:validationErrors: []

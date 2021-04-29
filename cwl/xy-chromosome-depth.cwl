cwlVersion: v1.1
class: CommandLineTool
label: XY chromosome depth
doc: |-
  This tool uses the output of the [Samtools Coverage](https://platform.sb.biodatacatalyst.nhlbi.nih.gov/public/apps#admin/sbg-public-data/samtools-coverage-1-10-cwl1-0/) app to calculate read depth on the X and Y chromosomes normalized by autosomal read depth. Normalized X and Y chromosome read depth may be used to assign genetic sex to samples, as well as to identify anomalous sex chromosome karyotypes (e.g., XXX, XXY).

  The tool produces an RDS file containing a data.frame with the following columns:

  column | description
  --- | ---
  X_depth | mean depth on the X chromosome
  Y_depth | mean depth on the Y chromosome
  auto_depth | mean depth on the autosomes
  X_norm_depth | normalized X chromosome depth (X_depth / auto_depth)
  Y_norm_depth | normalized Y chromosome depth (Y_depth / auto_depth)

  The accompanying scatter plot of Y_norm_depth vs X_norm_depth can aid in visually identifying thresholds to use in defining genetic sex. Since there is considerable variation in read depth across datasets, the exact thresholds will depend on the input data, but clusters around X_norm_depth=1, Y_norm_depth=0 for females and X_norm_depth=0.5, Y_norm_depth=0.5 for males are expected. Somatic mosaicism (loss of X and Y chromosomes, especially with age) is common in sex chromosomes, so the tails of the male and female distributions may overlap in large datasets.

  When running [Samtools Coverage](https://platform.sb.biodatacatalyst.nhlbi.nih.gov/public/apps#admin/sbg-public-data/samtools-coverage-1-10-cwl1-0/), the recommended procedure is to run in Batch mode by sample and select a small instance (m4.large is sufficient for CRAM files with ~30X coverage). Providing an appropriate reference file is critical; [public reference files](https://sb-biodatacatalyst.readme.io/docs/file-repositories-on-the-platform) are available on the platform. If a reference file is not provided, each task will attempt to download the reference file from an external source, which results in very long run times and exorbitant costs.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0

inputs:
- id: coverage_file
  label: Coverage file(s)
  doc: File(s) produced by Samtools coverage.
  type: File[]
  inputBinding:
    prefix: --coverage_file
    position: 0
    shellQuote: false
  sbg:category: Input files
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
- id: depth
  label: Depth by sample
  doc: RDS file with data.frame of sample.id and depth by chromosome.
  type: File?
  outputBinding:
    glob: '*.rds'
  sbg:fileTypes: RDS
- id: plot
  label: Plot of X and Y chromosome read depth
  doc: PDF with scatter plot showing normalized X and Y read depth.
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- wget
- https://raw.githubusercontent.com/UW-GAC/SeqQCpipeline/master/R/XYchrom_depth.R
- '&&'
- R -q --vanilla --args
arguments:
- prefix: <
  position: 100
  valueFrom: XYchrom_depth.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: '*.log'
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/qc-for-gwas-development/xy-chromosome-depth/3/raw/
sbg:appVersion:
- v1.1
sbg:categories:
- Quality Control
sbg:content_hash: ad519dafaf698fc97412f33b62897f88c73f248ae3d0765045be8f38e8008c629
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1619554853
sbg:id: smgogarten/qc-for-gwas-development/xy-chromosome-depth/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1619728841
sbg:project: smgogarten/qc-for-gwas-development
sbg:projectName: QC for GWAS - development
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: update description with new column names and samtools instructions
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1619554853
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1619555664
  sbg:revision: 1
  sbg:revisionNotes: first draft of XY chrom depth tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1619561470
  sbg:revision: 2
  sbg:revisionNotes: add app description
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1619728841
  sbg:revision: 3
  sbg:revisionNotes: update description with new column names and samtools instructions
sbg:sbgMaintained: false
sbg:validationErrors: []

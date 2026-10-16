# ViraPipe



A Docker-based viral genome analysis pipeline developed using Bash and FastQC.



\## Overview



ViraPipe is a small bioinformatics project designed to automate quality control of FASTQ sequencing files. It runs FastQC inside a Docker-based environment and produces HTML and ZIP quality reports.



\## Tools



\- Bash

\- Docker

\- FastQC

\- Git and GitHub



## Usage



Run from the project directory in Windows PowerShell:



```powershell

docker run --rm -v "G:\\ViraPipe:/data" -w /data jhuaplbio/sandbox bash -c "source /opt/conda/etc/profile.d/conda.sh \&\& conda activate sandbox \&\& bash scripts/run\_pipeline.sh data/test\_sample.fastq"

```



Replace `data/test\_sample.fastq` with the path to your own FASTQ file inside the mounted project directory.



## Output



FastQC generates an HTML quality report and a ZIP archive in `results/`.



\## Current Status



Prototype: single-file FASTQ quality control is implemented and tested with a small synthetic dataset. Read trimming, alignment, variant calling, and consensus generation are planned future developments.



## Data



Sequencing data and analysis results are excluded from Git tracking using `.gitignore`.
## Paired-End Read Trimming with Trimmomatic

ViraPipe supports preprocessing of paired-end Illumina FASTQ reads using Trimmomatic v0.39.

The pipeline performs two analysis stages:

1. **FastQC:** Generates sequencing quality-control reports for forward and reverse reads.
2. **Trimmomatic:** Performs quality trimming and removes reads shorter than the specified minimum length.

### Trimming Parameters

- `PE` — Paired-end sequencing mode.
- `-phred33` — Phred+33 quality-score encoding.
- `SLIDINGWINDOW:4:20` — Trims reads when the average quality of a four-base window falls below Q20.
- `MINLEN:25` — Discards reads shorter than 25 bases.

### Example Results

The pipeline was tested using the JHUAPL workshop dataset containing 329,134 paired-end reads.

The standalone Trimmomatic test retained 328,053 read pairs (99.67%).

### Output

The pipeline produces FastQC reports in `results/fastqc/` and four trimmed FASTQ files in `results/trimmed/`.

### Current Limitations

Adapter removal and post-trimming quality control are not yet implemented. Reference alignment, variant calling, and consensus generation are planned future improvements.

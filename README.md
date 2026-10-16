\# ViraPipe



A Docker-based viral genome analysis pipeline developed using Bash and FastQC.



\## Overview



ViraPipe is a small bioinformatics project designed to automate quality control of FASTQ sequencing files. It runs FastQC inside a Docker-based environment and produces HTML and ZIP quality reports.



\## Tools



\- Bash

\- Docker

\- FastQC

\- Git and GitHub



\## Usage



Run from the project directory in Windows PowerShell:



```powershell

docker run --rm -v "G:\\ViraPipe:/data" -w /data jhuaplbio/sandbox bash -c "source /opt/conda/etc/profile.d/conda.sh \&\& conda activate sandbox \&\& bash scripts/run\_pipeline.sh data/test\_sample.fastq"

```



Replace `data/test\_sample.fastq` with the path to your own FASTQ file inside the mounted project directory.



\## Output



FastQC generates an HTML quality report and a ZIP archive in `results/`.



\## Current Status



Prototype: single-file FASTQ quality control is implemented and tested with a small synthetic dataset. Read trimming, alignment, variant calling, and consensus generation are planned future developments.



\## Data



Sequencing data and analysis results are excluded from Git tracking using `.gitignore`.


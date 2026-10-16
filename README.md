# ViraPipe

**A Docker-based bioinformatics workflow for paired-end viral sequencing analysis**

ViraPipe is an educational bioinformatics project developed using Bash, Docker, and commonly used genomics tools. It demonstrates sequencing quality assessment, read trimming, reference indexing, paired-end alignment, BAM processing, candidate variant calling, and preliminary depth-based filtering.

The workflow was developed and tested using publicly available Illumina metagenomic sequencing data.

## Workflow

```text
Paired-end FASTQ files
        |
        v
      FastQC
        |
        v
    Trimmomatic
        |
        v
   Trimmed FASTQ
        |
        v
Bowtie2 reference indexing
        |
        v
Bowtie2 paired-end alignment
        |
        v
       SAM
        |
        v
Samtools sorting and indexing
        |
        v
    Sorted BAM
        |
        v
Samtools coverage analysis
        |
        v
BCFtools haploid variant calling
        |
        v
  Candidate VCF
        |
        v
Preliminary depth filtering
        |
        v
Depth-screened VCF
```

## Tools

- FastQC v0.11.8 — Sequencing quality assessment
- Trimmomatic v0.39 — Quality-based trimming
- Bowtie2 — Reference indexing and read alignment
- Samtools — BAM processing and reference coverage analysis
- BCFtools v1.11 — Candidate variant calling and VCF filtering
- Bash — Workflow automation
- Docker — Containerized execution
- Git and GitHub — Version control

The workflow was tested using the `jhuaplbio/sandbox` Docker image with its `sandbox` Conda environment.

## Test Dataset

- ENA run accession: ERR6913101
- Study accession: PRJEB47870
- Sequencing platform: Illumina NovaSeq 6000
- Library layout: Paired-end
- Library source: Metagenomic

### Reference Genome

- Organism: SARS-CoV-2
- GenBank accession: MN908947.3
- Reference length: 29,903 nucleotides
- Local file: `reference/nCoV-2019.reference.fasta`

The reference FASTA is included in this repository. Generated Bowtie2 indexes are excluded from Git tracking.

## Running ViraPipe

### Requirements

Docker must be installed and running.

Obtain the required paired-end FASTQ files and place them in the local `data/` directory.

The example below uses `ERR6913101`.

From Windows PowerShell, run:

```powershell
docker run --rm `
  -v "${PWD}:/data" `
  -w /data `
  jhuaplbio/sandbox `
  bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate sandbox && bash scripts/run_pipeline.sh data/ERR6913101_1.fastq.gz data/ERR6913101_2.fastq.gz"
```

Run this command from the root of the cloned ViraPipe repository.

The main script executes quality assessment, read trimming, reference indexing, alignment, BAM processing, and variant calling.

The workflow currently uses fixed output filenames associated with ERR6913101 and is intended as a single-dataset demonstration.

## Output Files

| Directory | Contents |
|---|---|
| `results/fastqc/` | FastQC HTML and ZIP reports |
| `results/trimmed/` | Paired and unpaired trimmed FASTQ files |
| `results/bowtie2_index/` | Generated Bowtie2 indexes |
| `results/alignment/` | SAM, sorted BAM and BAM index |
| `results/variants/` | Coverage report, candidate VCF, depth-screened VCF and variant counts |

## Results

### Quality Trimming

The initial dataset contained 329,134 read pairs.

Trimmomatic retained 328,053 pairs with both mates surviving, corresponding to 99.67% of the input pairs.

Parameters:

- `SLIDINGWINDOW:4:20`
- `MINLEN:25`

### Reference-Based Alignment

Bowtie2 alignment against SARS-CoV-2 reference MN908947.3 produced an overall alignment rate of approximately 0.04%.

### Reference Coverage

| Metric | Value |
|---|---:|
| Reference length | 29,903 nt |
| Mapped alignment records | 250 |
| Reference bases covered | 13,952 |
| Coverage breadth | 46.6575% |
| Mean depth | 1.123× |
| Mean mapping quality | 40.6 |

### Variant Calling

BCFtools was used with a haploid genotype model.

| Metric | Result |
|---|---:|
| Candidate variant records | 8 |
| Candidate SNV records | 5 |
| Candidate insertion/deletion records | 3 |
| Records passing INFO/DP ≥ 10 | 0 |

**These results are exploratory.** All eight candidate records had reported depths of only one or two reads. They must not be interpreted as validated SARS-CoV-2 mutations.

The depth threshold is a preliminary screening step rather than a complete variant-validation strategy.

## Limitations

- The test dataset is metagenomic and has very low alignment to the selected SARS-CoV-2 reference.
- The reference coverage and sequencing depth are insufficient for reliable genome-wide SARS-CoV-2 variant interpretation.
- Adapter removal and post-trimming FastQC have not been implemented.
- The scripts currently use fixed output paths for the workshop dataset.
- The workflow does not yet generate a consensus genome.
- The variant-calling procedure requires further validation, additional quality filters, and testing with well-characterized positive-control datasets.
- This project is not a clinical diagnostic pipeline.

## Additional Analysis

Exploratory Kraken2 classification was performed separately using an influenza-focused reference database.

The analysis and its limitations are documented in [Workshop Sequencing Analysis](docs/workshop_analysis.md).

## Project Scope

ViraPipe was developed as a learning and research portfolio project, incorporating commands and practices adapted from bioinformatics workshop materials.

Its purpose is to demonstrate practical experience with sequencing data processing, containerized bioinformatics workflows, reproducibility, and critical interpretation of computational results.

## Reproducibility

The repository contains the workflow scripts, reference FASTA, and documentation.

Raw sequencing data, generated alignment files, variant outputs, and index files are excluded from Git tracking.

The external Docker image and Conda environment are currently referenced by name rather than pinned to an immutable image digest; this is a reproducibility limitation.

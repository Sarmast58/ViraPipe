
#!/bin/bash
set -euo pipefail

echo "================================"
echo "Welcome to ViraPipe"
echo "Viral Genome Analysis Pipeline"
echo "================================"

# Accept two paired-end FASTQ files
READ1="${1:-}"
READ2="${2:-}"

# Check input arguments
if [ -z "$READ1" ] || [ -z "$READ2" ]; then
    echo "Error: Provide R1 and R2 FASTQ files."
    echo "Usage: bash scripts/run_pipeline.sh R1.fastq.gz R2.fastq.gz"
    exit 1
fi

# Check input files exist
if [ ! -f "$READ1" ] || [ ! -f "$READ2" ]; then
    echo "Error: One or both input files do not exist."
    exit 1
fi

# Create output directories
mkdir -p results/fastqc
mkdir -p results/trimmed
# Create a directory for Bowtie2 reference indexes
mkdir -p results/bowtie2_index
mkdir -p results/alignment

echo "Step 1: Running FastQC"

fastqc "$READ1" "$READ2" -o results/fastqc

echo "Step 2: Running Trimmomatic"

trimmomatic PE -phred33 \
    "$READ1" \
    "$READ2" \
    results/trimmed/R1_paired.fastq.gz \
    results/trimmed/R1_unpaired.fastq.gz \
    results/trimmed/R2_paired.fastq.gz \
    results/trimmed/R2_unpaired.fastq.gz \
    SLIDINGWINDOW:4:20 \
    MINLEN:25
echo "Step 3: Building Bowtie2 reference index"

bowtie2-build \
    reference/nCoV-2019.reference.fasta \
    results/bowtie2_index/sarscov2_index
echo "Step 4: Aligning trimmed reads with Bowtie2"

bowtie2 \
    -x results/bowtie2_index/sarscov2_index \
    -1 results/trimmed/R1_paired.fastq.gz \
    -2 results/trimmed/R2_paired.fastq.gz \
    -S results/alignment/ERR6913101.sam
echo "Step 5: Sorting and indexing alignments"

samtools sort \
    -o results/alignment/ERR6913101.sorted.bam \
    results/alignment/ERR6913101.sam

samtools index results/alignment/ERR6913101.sorted.bam

echo "Step 6: Running variant calling"

bash scripts/call_variants.sh

echo "================================"
echo "ViraPipe completed successfully!"
echo "================================"

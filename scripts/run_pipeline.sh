#!/bin/bash
set -e

echo "================================"
echo "Welcome to ViraPipe"
echo "Viral Genome Analysis Pipeline"
echo "================================"

# Accept input FASTQ filename
INPUT=$1

# Check whether an input was provided
if [ -z "$INPUT" ]; then
    echo "Error: Please provide a FASTQ file."
    echo "Usage: bash scripts/run_pipeline.sh data/sample.fastq"
    exit 1
fi

# Check whether the input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file not found: $INPUT"
    exit 1
fi

echo "Input file: $INPUT"

# Create output directory
mkdir -p results

# Run FastQC
echo "Step 1: Running FastQC"
fastqc "$INPUT" -o results

echo "FastQC analysis completed!"
echo "ViraPipe execution completed!"
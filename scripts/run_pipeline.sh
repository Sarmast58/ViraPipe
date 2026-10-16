#!/bin/bash
set -e

echo "================================"
echo "Welcome to ViraPipe"
echo "Viral Genome Analysis Pipeline"
echo "================================"

echo "Step 1: Quality Control"

mkdir -p results

fastqc data/test_sample.fastq -o results

echo "FastQC analysis completed!"

echo "================================"
echo "ViraPipe execution completed!"
echo "================================"
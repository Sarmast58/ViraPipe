
#!/usr/bin/env bash
set -euo pipefail

REFERENCE="reference/nCoV-2019.reference.fasta"
BAM="results/alignment/ERR6913101.sorted.bam"
OUTDIR="results/variants"

mkdir -p "$OUTDIR"

echo "Step 1: Checking reference and BAM files"

if [[ ! -f "$REFERENCE" || ! -f "$BAM" ]]; then
    echo "Error: Reference FASTA or sorted BAM not found."
    exit 1
fi

echo "Step 2: Indexing reference and BAM"

samtools faidx "$REFERENCE"
samtools index "$BAM"

echo "Step 3: Assessing reference coverage"

samtools coverage "$BAM" > "$OUTDIR/coverage.txt"
cat "$OUTDIR/coverage.txt"

echo "Step 4: Calling candidate variants"

bcftools mpileup \
    -f "$REFERENCE" \
    -q 20 \
    -Q 20 \
    -Ou "$BAM" |
bcftools call \
    --ploidy 1 \
    -mv \
    -Oz \
    -o "$OUTDIR/candidates.vcf.gz"

echo "Step 5: Indexing candidate VCF"

bcftools index -t "$OUTDIR/candidates.vcf.gz"

echo "Step 6: Summarizing candidate variants"

bcftools view -H "$OUTDIR/candidates.vcf.gz" |
    wc -l > "$OUTDIR/candidate_count.txt"
echo "Step 7: Filtering candidate variants by depth"

bcftools view \
    -i 'INFO/DP>=10' \
    -Oz \
    -o "$OUTDIR/depth10.vcf.gz" \
    "$OUTDIR/candidates.vcf.gz"

bcftools index -t -f "$OUTDIR/depth10.vcf.gz"

bcftools view -H "$OUTDIR/depth10.vcf.gz" |
    wc -l > "$OUTDIR/filtered_count.txt"
echo "IMPORTANT: Candidate variants require coverage and quality validation."
echo "The current ERR6913101 dataset has insufficient coverage"
echo "for reliable genome-wide SARS-CoV-2 variant interpretation."

echo "Variant-calling workflow completed."

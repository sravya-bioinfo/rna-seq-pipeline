#!/bin/bash
# ============================================================
# 04_hisat2_align.sh
# Genome alignment using HISAT2 + SAMtools sort
#
# Author : Mulpuri Sravya
# GitHub : https://github.com/sravya-bioinfo
#
# Usage  : bash 04_hisat2_align.sh <genome.fa> <SRR_ID>
#
# Example:
#   bash 04_hisat2_align.sh genome/Scerevisiae.fa SRR5924196
# ============================================================

GENOME=${1:-genome/reference.fa}
SRR_ID=${2:-SRR2584863}
BASE_DIR=$(pwd)

echo "======================================================"
echo "  HISAT2 Alignment Pipeline"
echo "  Genome : $GENOME"
echo "  Sample : $SRR_ID"
echo "======================================================"

# Create output directories
mkdir -p $BASE_DIR/results/HISAT2
mkdir -p $BASE_DIR/results/index

INDEX_DIR=$BASE_DIR/results/index/genome_index
OUT_BAM=$BASE_DIR/results/HISAT2/${SRR_ID}.bam

READ1=$BASE_DIR/sra_data/${SRR_ID}_1.fastq.gz
READ2=$BASE_DIR/sra_data/${SRR_ID}_2.fastq.gz

# ── Step 1: Build HISAT2 genome index ────────────────────
echo ""
echo "[STEP 1] Building HISAT2 genome index ..."
echo "         This may take a few minutes..."
hisat2-build $GENOME $INDEX_DIR
echo "[DONE]  Index saved to: $INDEX_DIR"

# ── Step 2: Align reads to genome ────────────────────────
echo ""
echo "[STEP 2] Aligning paired-end reads to genome ..."
echo "         Read 1: $READ1"
echo "         Read 2: $READ2"

hisat2 \
    -q \
    --rna-strandness RF \
    -x $INDEX_DIR \
    -1 $READ1 \
    -2 $READ2 \
    --no-mixed \
    --no-discordant \
    --dta \
    --score-min L,0,-0.2 \
    | samtools sort -o $OUT_BAM

# ── Step 3: Index the BAM file ───────────────────────────
echo ""
echo "[STEP 3] Indexing BAM file ..."
samtools index $OUT_BAM

# ── Step 4: Alignment summary ────────────────────────────
echo ""
echo "[STEP 4] Alignment statistics:"
samtools flagstat $OUT_BAM

echo ""
echo "======================================================"
echo "  ALIGNMENT COMPLETE"
echo "  Output BAM : $OUT_BAM"
echo "======================================================"
echo ""
echo "Parameter explanation:"
echo "  -q              : quiet mode (suppress verbose output)"
echo "  --rna-strandness RF : reverse-forward stranded library"
echo "  --no-mixed      : only report paired alignments"
echo "  --no-discordant : only concordant paired alignments"
echo "  --dta           : optimized for transcript assemblers"
echo "  --score-min L,0,-0.2 : minimum alignment score function"

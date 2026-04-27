#!/bin/bash
# ============================================================
# 02_download_data.sh
# Download raw RNA-Seq data from NCBI SRA
#
# Author : Mulpuri Sravya
# GitHub : https://github.com/sravya-bioinfo
#
# Usage  : bash 02_download_data.sh SRR2584863
# ============================================================

SRR_ID=${1:-SRR2584863}

echo "======================================================"
echo "  Downloading SRA data: $SRR_ID"
echo "======================================================"

# Create data directory
mkdir -p sra_data
cd sra_data

# Step 1: Prefetch the SRA file
echo "[STEP 1] Prefetching $SRR_ID ..."
prefetch $SRR_ID

# Step 2: Convert to FASTQ (compressed)
echo "[STEP 2] Converting to FASTQ format ..."
fasterq-dump $SRR_ID --gzip

echo ""
echo "[DONE] Downloaded: ${SRR_ID}_1.fastq.gz and ${SRR_ID}_2.fastq.gz"
echo "       Files saved in: sra_data/"

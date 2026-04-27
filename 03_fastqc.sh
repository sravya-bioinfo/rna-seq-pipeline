#!/bin/bash
# ============================================================
# 03_fastqc.sh
# Quality control of raw FASTQ reads using FastQC
#
# Author : Mulpuri Sravya
# GitHub : https://github.com/sravya-bioinfo
#
# Usage  : bash 03_fastqc.sh sra_data/ results/fastqc/
# ============================================================

DATA_DIR=${1:-sra_data}
OUT_DIR=${2:-results/fastqc}

echo "======================================================"
echo "  Running FastQC Quality Control"
echo "======================================================"

# Create output directory
mkdir -p $OUT_DIR

# Run FastQC on all FASTQ files in the data directory
for file in $DATA_DIR/*.fastq.gz; do
    echo "[FastQC] Processing: $file"
    fastqc $file -o $OUT_DIR
done

echo ""
echo "[DONE] FastQC complete!"
echo "       HTML reports saved in: $OUT_DIR"
echo ""
echo "[TIP]  Open reports with:"
echo "       xdg-open $OUT_DIR/<filename>_fastqc.html"
echo ""
echo "[CHECK] Review summary with:"
for zip in $OUT_DIR/*.zip; do
    name=$(basename $zip .zip)
    unzip -p $zip $name/summary.txt 2>/dev/null
done

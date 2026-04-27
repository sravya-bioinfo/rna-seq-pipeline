#!/bin/bash
# ============================================================
# 01_setup_environment.sh
# Set up conda environment with all required RNA-Seq tools
#
# Author : Mulpuri Sravya
# GitHub : https://github.com/sravya-bioinfo
# ============================================================

echo "======================================================"
echo "  Setting up RNA-Seq conda environment"
echo "======================================================"

# Create conda environment with all required tools
conda create -n rnaseq_env \
    -c bioconda \
    -c conda-forge \
    openjdk \
    fastqc \
    hisat2 \
    samtools \
    subread \
    wget \
    unzip \
    -y

echo ""
echo "[DONE] Environment 'rnaseq_env' created successfully!"
echo "       Activate it with: conda activate rnaseq_env"

# RNA-Seq Analysis Pipeline

A complete, beginner-friendly RNA-Seq pipeline built from real hands-on experience. Covers everything from raw data download to genome alignment — using NCBI SRA data, FastQC, HISAT2, and SAMtools on Linux.

---

## Pipeline Overview

```
NCBI SRA
   |
   | prefetch + fasterq-dump
   v
Raw FASTQ files (_1 and _2)
   |
   | FastQC
   v
Quality Control Reports (.html)
   |
   | HISAT2 (genome index + alignment)
   v
Aligned BAM file
   |
   | SAMtools sort + index + flagstat
   v
Sorted, indexed BAM → ready for downstream analysis (DESeq2, featureCounts)
```

---

## Tools Used

| Tool | Version | Purpose |
|---|---|---|
| FastQC | 0.12.1 | Raw read quality control |
| HISAT2 | 2.2.1 | Splice-aware genome alignment |
| SAMtools | 1.21 | BAM file processing |
| SRA Toolkit | 3.1.1 | NCBI data download |
| Subread/featureCounts | — | Read counting |
| Conda | 24.7.1 | Environment management |

---

## Setup

### 1. Install Miniconda
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

### 2. Create RNA-Seq environment
```bash
bash scripts/01_setup_environment.sh
conda activate rnaseq_env
```

---

## Running the Pipeline

### Step 1 — Download data from NCBI SRA
```bash
bash scripts/02_download_data.sh SRR2584863
```

### Step 2 — Quality control with FastQC
```bash
bash scripts/03_fastqc.sh sra_data/ results/fastqc/
```
Open the HTML report to check:
- Per base sequence quality (should be green)
- Adapter content
- Sequence duplication levels

### Step 3 — Align to reference genome
```bash
# Download your reference genome first
wget <your_genome_url> -O genome/reference.fa

# Run alignment
bash scripts/04_hisat2_align.sh genome/reference.fa SRR2584863
```

---

## Project Structure

```
rna-seq-pipeline/
├── scripts/
│   ├── 01_setup_environment.sh   # conda env setup
│   ├── 02_download_data.sh       # SRA data download
│   ├── 03_fastqc.sh              # quality control
│   └── 04_hisat2_align.sh        # alignment + BAM
├── sra_data/                     # raw FASTQ files (gitignored)
├── results/
│   ├── fastqc/                   # FastQC HTML reports
│   └── HISAT2/                   # aligned BAM files
├── genome/                       # reference genome (gitignored)
└── README.md
```

---

## Real Datasets Used

| SRR ID | Organism | Description |
|---|---|---|
| SRR5924196 | *Saccharomyces cerevisiae* | Yeast RNA-Seq |
| SRR2584863 | *E. coli* | Bacterial paired-end reads |
| SRR9120260 | — | Additional SRA dataset |

---

## HISAT2 Parameters Explained

```bash
hisat2 \
  -q                      # quiet mode
  --rna-strandness RF     # reverse-forward stranded library
  -x genome_index         # path to genome index
  -1 reads_1.fastq.gz     # forward reads
  -2 reads_2.fastq.gz     # reverse reads
  --no-mixed              # only report paired alignments
  --no-discordant         # only concordant pairs
  --dta                   # optimized for transcript assemblers
  --score-min L,0,-0.2    # minimum alignment score
  | samtools sort         # pipe directly to samtools
  -o output.bam           # save sorted BAM
```

---

## Next Steps After Alignment

- **featureCounts** — count reads per gene
- **DESeq2** (R) — differential gene expression
- **KEGG / GO enrichment** — pathway analysis
- **IGV** — visualize alignments

---

## References

- Kim et al. (2019). HISAT2. *Nature Biotechnology*
- Andrews S. FastQC: A quality control tool for NGS data
- Li et al. (2009). SAMtools. *Bioinformatics*

---

## Author

**Mulpuri Sravya**
B.Tech Bioinformatics, VFSTR | Research Intern @ Metflux Research, Bangalore
[LinkedIn](https://www.linkedin.com/in/sravya-mulpuri-943655336/) · [ORCID](https://orcid.org/0009-0005-9466-2789) · [GitHub](https://github.com/sravya-bioinfo)

---

> Built from real hands-on experience running RNA-Seq analysis on NCBI datasets using Linux/WSL2.

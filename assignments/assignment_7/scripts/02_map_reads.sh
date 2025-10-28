#!/bin/bash
set -euo pipefail

mkdir -p output

for R1 in ../data/clean/*_1_clean.fastq; do
  BASE=${R1%_1_clean.fastq}
  R2="${BASE}_2_clean.fastq"
  SAMPLE=$(basename "$BASE")
  SAM="../output/${SAMPLE}_dog.sam"

  # skip if already mapped
  if [ -f "$SAM" ]; then
    echo "SKIP $SAMPLE (already mapped)"
  else
    echo "MAP  $SAMPLE"
    bbmap.sh ref=../ref/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna in1="$R1" in2="$R2" out="$SAM"
  fi
done

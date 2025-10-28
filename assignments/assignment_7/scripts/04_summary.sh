#!/bin/bash
# prints: Sample  QC_Reads  Dog_Mapped_Reads

echo -e "Sample\tQC_Reads\tDog_Mapped_Reads"

for f in ../data/clean/*_1_clean.fastq
do
  S=$(basename "$f" _1_clean.fastq)

  # QC reads: count FASTQ headers in R1
  QC=$(grep -c "^@" "$f")

  # mapped reads: count names from the ids file made by extract step
  MAP=0
  if [ -f "../output/hits/${S}_mapped_ids.txt" ]; then
    MAP=$(wc -l < "../output/hits/${S}_mapped_ids.txt")
  fi

  echo -e "${S}\t${QC}\t${MAP}"
done

#!/bin/bash
set -euo pipefail

mkdir -p data/clean

for FWD in data/raw/*_1.fastq
do
  REV=${FWD/_1.fastq/_2.fastq}

  OUTFWD=data/clean/$(basename ${FWD/.fastq/_clean.fastq})
  OUTREV=data/clean/$(basename ${REV/.fastq/_clean.fastq})

  echo "Cleaning $FWD ..."
  fastp -i "$FWD" -I "$REV" -o "$OUTFWD" -O "$OUTREV"
done

echo "Done."

#!/bin/bash
set -euo pipefail

mkdir -p output
mkdir -p ../output/hits

for SAM in ../output/*_dog.sam; 
do
  BASE=$(basename "$SAM" .sam)
  OUT=output/${BASE}_mapped.sam
  echo "Extracting mapped reads from $SAM ..."
  samtools view -F 4 "$SAM" > "$OUT"
done

echo "Done."

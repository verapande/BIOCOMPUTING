#!/bin/bash
set -euo pipefail

mkdir -p data/raw
mkdir -p ref

# skip first line and download each run
for ACC in $(tail -n +2 data/SraRunTable_A7.csv | cut -d',' -f1)
do
  echo "Downloading $ACC ..."
  fasterq-dump --split-files -O data/raw "$ACC"
done

echo "Downloading dog reference genome..."
datasets download genome taxon "Canis familiaris" --reference --filename ref/dog.zip
unzip -o ref/dog.zip -d ref

echo "Done."

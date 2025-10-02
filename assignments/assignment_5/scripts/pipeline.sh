#!/bin/bash
set -euo pipefail

echo "downloading data..."
./scripts/01_download_data.sh

echo "running fastp on all R1 files..."
for FWD_IN in ./data/raw/*_R1_*.fastq.gz; do
  ./scripts/02_run_fastp.sh "$FWD_IN"
done

echo "pipeline complete."

#!/bin/bash
# Simple pipeline that runs all existing scripts in order
# Run from assignment_6/

set -ueo pipefail

#!/bin/bash
# pipeline.sh — run from assignment_6/

echo "PIPELINE START"

echo "Step 1: download data"
bash scripts/01_download_data.sh

echo "Step 2: build Flye locally"
bash scripts/flye_2.9.6_manual_build.sh

echo "Step 3: run Flye (local build)"
bash scripts/03_run_flye_local.sh

echo "Step 4: create Flye conda environment"
bash scripts/02_flye_2.9.6_conda_install.sh

echo "Step 5: run Flye (conda)"
bash scripts/03_run_flye_conda.sh

echo "Step 6: run Flye (module)"
bash scripts/03_run_flye_module.sh

echo "PIPELINE COMPLETE"

#!/bin/bash
# Simple pipeline that runs all existing scripts in order
# Run from assignment_6/

set -ueo pipefail

echo "=== PIPELINE START ==="

# 1) download data
echo "[1/7] downloading data..."
bash scripts/01_download_data.sh
echo

# 2) build flye locally (manual build)
echo "[2/7] building flye locally..."
bash scripts/flye_2.9.6_manual_build.sh
echo

# make sure flye is on PATH (cover both common build locations)
export PATH="$PATH:$HOME/BIOCOMPUTING/programs/Flye/bin:$HOME/programs/Flye/bin"

# 3) run flye (local build)
echo "[3/7] running flye (local build)..."
bash scripts/03_run_flye_local.sh
echo

# 4) build conda env non-interactively and export yml (no new files beyond yml)
echo "[4/7] creating conda env 'flye-env' and exporting yml..."
mkdir -p envs
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda env remove -y -n flye-env >/dev/null 2>&1 || true
mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.6
conda activate flye-env
conda env export --no-builds > envs/flye-env.yml
conda deactivate
echo "envs/flye-env.yml written"
echo

# 5) run flye (conda env) using your existing script
echo "[5/7] running flye (conda env)..."
bash scripts/03_run_flye_conda.sh
echo

# 6) run flye (module); allow failure without stopping the pipeline
echo "[6/7] running flye (module)..."
bash scripts/03_run_flye_module.sh || echo "module run failed or module not available"
echo

# 7) print results to STDOUT (simple: show key output files and sizes)
echo "=== Assembly run summaries ==="

echo
echo "LOCAL (manual build)"
echo "--------------------"
tail -n 10 assemblies/assembly_local/local_flye.log 2>/dev/null || echo "(no log found)"

echo
echo "CONDA (flye-env)"
echo "----------------"
tail -n 10 assemblies/assembly_conda/conda_flye.log 2>/dev/null || echo "(no log found)"

echo
echo "MODULE (cluster module)"
echo "-----------------------"
tail -n 10 assemblies/assembly_module/module_flye.log 2>/dev/null || echo "(no log found)"

echo
echo "=== PIPELINE END ==="

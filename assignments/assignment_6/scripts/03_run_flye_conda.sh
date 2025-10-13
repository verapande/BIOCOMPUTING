#!/bin/bash
# run Flye using the conda environment "flye-env"

# conda lives in your home so it finds your env
export CONDA_PKGS_DIRS=$HOME/.conda/pkgs
export CONDA_ENVS_PATH=$HOME/.conda/envs

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

mkdir -p assemblies/assembly_conda
rm -rf assemblies/assembly_conda/*

# NOTE: high-quality ONT reads -> --nano-hq (not --nano-raw)
flye --nano-hq data/*.fastq* \
     --out-dir assemblies/assembly_conda \
     --threads 6 \
     --genome-size 170k 2>&1 | tee assemblies/assembly_conda/conda_flye.log

# rename if present; otherwise just print a hint (no if/fi used)
mv assemblies/assembly_conda/assembly.fasta assemblies/assembly_conda/conda_assembly.fasta 2>/dev/null || \
echo "no assembly.fasta produced; see assemblies/assembly_conda/conda_flye.log"

# keep only fasta + log
find assemblies/assembly_conda -type f ! -name 'conda_assembly.fasta' ! -name 'conda_flye.log' -delete 2>/dev/null

conda deactivate

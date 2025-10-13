#!/bin/bash
# installs Flye v2.9.6 into a user env (no shared lock issues)

mkdir -p $HOME/.conda/pkgs $HOME/.conda/envs
export CONDA_PKGS_DIRS=$HOME/.conda/pkgs
export CONDA_ENVS_PATH=$HOME/.conda/envs

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

# try 2.9.6, else 2.9.5 (bioconda has 2.9.5 reliably)
mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.6 \
  || mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.5

conda activate flye-env
flye -v
conda env export --no-builds > flye-env.yml
conda deactivate

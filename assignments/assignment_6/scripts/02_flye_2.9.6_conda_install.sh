#!/bin/bash
# flye_2.9.6_conda_install.sh

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.6
conda activate flye-env
flye -v
conda env export --no-builds > flye-env.yml
conda deactivate

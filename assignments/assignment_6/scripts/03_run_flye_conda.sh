#!/bin/bash
# 02_run_flye_conda.sh

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

mkdir -p assemblies/assembly_conda
rm -rf assemblies/assembly_conda/*

flye --nano-hq data/*.fastq* --out-dir assemblies/assembly_conda --threads 6 --genome-size 170k

mv assemblies/assembly_conda/assembly.fasta assemblies/assembly_conda/conda_assembly.fasta
mv assemblies/assembly_conda/flye.log assemblies/assembly_conda/conda_flye.log

conda deactivate

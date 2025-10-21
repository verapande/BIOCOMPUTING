#!/bin/bash
# run Flye using conda environment

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

mkdir -p assemblies/_tmp_conda
rm -rf assemblies/_tmp_conda/*

flye --nano-hq data/*.fastq* --out-dir assemblies/_tmp_conda --threads 6 --genome-size 170k

mkdir -p assemblies/assembly_conda
mv assemblies/_tmp_conda/assembly.fasta assemblies/assembly_conda/conda_assembly.fasta
mv assemblies/_tmp_conda/flye.log assemblies/assembly_conda/conda_flye.log

rm -rf assemblies/_tmp_conda

conda deactivate

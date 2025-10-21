#!/bin/bash
# 03_run_flye_local.sh

# add local Flye build to my PATH
export PATH="$PATH:$HOME/BIOCOMPUTING/programs/Flye/bin"

mkdir -p assemblies/assembly_local
rm -rf assemblies/assembly_local/*

flye --nano-hq data/*.fastq* --out-dir assemblies/assembly_local --threads 6 --genome-size 170k

# rename output files
mv assemblies/assembly_local/assembly.fasta assemblies/assembly_local/local_assembly.fasta
mv assemblies/assembly_local/flye.log assemblies/assembly_local/local_flye.log

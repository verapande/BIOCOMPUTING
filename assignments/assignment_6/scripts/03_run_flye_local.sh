#!/bin/bash
# run Flye using local build

# add both common build paths
export PATH="$PATH:$HOME/BIOCOMPUTING/programs/Flye/bin:$HOME/programs/Flye/bin"

mkdir -p assemblies/assembly_local
rm -rf assemblies/assembly_local/*

# high-quality ONT
flye --nano-hq data/*.fastq* \
     --out-dir assemblies/assembly_local \
     --threads 6 \
     --genome-size 170k 2>&1 | tee assemblies/assembly_local/local_flye.log

# don't crash if file missing
mv assemblies/assembly_local/assembly.fasta assemblies/assembly_local/local_assembly.fasta 2>/dev/null || \
echo "no assembly.fasta produced; see assemblies/assembly_local/local_flye.log"

# keep only fasta + log
find assemblies/assembly_local -type f ! -name 'local_assembly.fasta' ! -name 'local_flye.log' -delete 2>/dev/null

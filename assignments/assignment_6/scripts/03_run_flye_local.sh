#!/bin/bash
# run Flye using local build

export PATH="$PATH:$HOME/BIOCOMPUTING/programs/Flye/bin"

mkdir -p assemblies/_tmp_local
rm -rf assemblies/_tmp_local/*

flye --nano-hq data/*.fastq* --out-dir assemblies/_tmp_local --threads 6 --genome-size 170k

mkdir -p assemblies/assembly_local
mv assemblies/_tmp_local/assembly.fasta assemblies/assembly_local/local_assembly.fasta
mv assemblies/_tmp_local/flye.log assemblies/assembly_local/local_flye.log

rm -rf assemblies/_tmp_local

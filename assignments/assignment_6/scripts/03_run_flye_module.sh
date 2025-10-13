#!/bin/bash
# run Flye using the HPC module found at: Flye/gcc-11.4.1/2.9.6

module load Flye/gcc-11.4.1/2.9.6
flye -v

mkdir -p assemblies/assembly_module
rm -rf assemblies/assembly_module/*

flye --nano-hq data/*.fastq* \
     --out-dir assemblies/assembly_module \
     --threads 6 \
     --genome-size 170k 2>&1 | tee assemblies/assembly_module/module_flye.log

mv assemblies/assembly_module/assembly.fasta assemblies/assembly_module/module_assembly.fasta 2>/dev/null || \
echo "no assembly.fasta produced; see assemblies/assembly_module/module_flye.log"

find assemblies/assembly_module -type f ! -name 'module_assembly.fasta' ! -name 'module_flye.log' -delete 2>/dev/null

#!/bin/bash
# 04_run_flye_module.sh

module load Flye/gcc-11.4.1/2.9.6
flye -v

mkdir -p assemblies/assembly_module
rm -rf assemblies/assembly_module/*

flye --nano-hq data/*.fastq* --out-dir assemblies/assembly_module --threads 6 --genome-size 170k

mv assemblies/assembly_module/assembly.fasta assemblies/assembly_module/module_assembly.fasta
mv assemblies/assembly_module/flye.log assemblies/assembly_module/module_flye.log

#!/bin/bash
# run Flye using module environment

module load Flye/gcc-11.4.1/2.9.6
flye -v

mkdir -p assemblies/_tmp_module
rm -rf assemblies/_tmp_module/*

flye --nano-hq data/*.fastq* --out-dir assemblies/_tmp_module --threads 6 --genome-size 170k

mkdir -p assemblies/assembly_module
mv assemblies/_tmp_module/assembly.fasta assemblies/assembly_module/module_assembly.fasta
mv assemblies/_tmp_module/flye.log assemblies/assembly_module/module_flye.log

rm -rf assemblies/_tmp_module

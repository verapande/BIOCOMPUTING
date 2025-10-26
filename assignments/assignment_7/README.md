# **ASSIGNMENT 7**

In this assignment, we worked to automate a kind of metagenomic search pipeline
on the HPC using SLURM. We used five different tools to see if we could find
any dog DNA contamination in publicly available Illumina shotgun metagenomic
datasets of an animal of our choosing. Hopefully through this assignment
I/we would be able to test a realistic workflow for downloading, cleaning, mapping
and filtering large-scale public data and understand how SLURM fits into
reproducible computational biological work.
<br>
<br>
<br>
To begin, I connected to the (GlobalProtect → portal gp.wm.edu), SSH’d into
the bora cluster, and then navigated to my assignments directory and replicated
the referenced final structure shown on the assignment_07 instructions document.
I used the following command lines:<br>
ssh vpande@bora.sciclone.wm.edu
<br>
cd ~/BIOCOMPUTING/assignments/
<br>
mkdir -p assignment_7
<br>
cd assignment_7
<br>
touch README.md
<br>
mkdir scripts data ref output
<br>
touch scripts/01_download_data.sh scripts/02_map_reads.sh scripts/03_extract_hits.sh 
<br>
chmod +x scripts/*
<br>
cd scripts
<br>
ls -l

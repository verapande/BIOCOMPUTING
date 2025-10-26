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
<br>
<br>
<br>
For Task 2, I searched the NCBI SRA and initially settled on using horse
metagenomic data but any of the files were just too large so I ended up using
sea otter metagenomic data. Here are the search details:
"Enhydra lutris"[Organism] OR ("Enhydra lutris"[Organism] OR sea otter[All Fields]) AND shotgun[All Fields] AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])
<br>
All 10 that I had selected were around 1-3G and were southern sea otter fecal
metagenome collected at Stanford University, California. I sent those results
to the Run selector and then downloaded the meta data/csv file to my computer.
I renamed the file to SraRunTable.csv and using FileZilla dragged it over to my
data folder under assignment_7 on the HPC.
<br>
My script for Task 2 is as follows:
"#nano 01_download_data"



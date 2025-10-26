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
<br>
All 10 that I had selected were around 1-3G and were southern sea otter fecal
metagenome collected at Stanford University, California. I sent those results
to the Run selector and then downloaded the meta data/csv file to my computer.
I renamed the file to SraRunTable.csv and using FileZilla dragged it over to my
data folder under assignment_7 on the HPC.
<br>
<br>
My script for Task 2 is as follows:
<br>
"#nano 01_download_data"
<br>
<br>
#!/bin/bash
<br>
set -euo pipefail
<br>
<br>
mkdir -p ./data/raw
<br>
mkdir -p ./data/dog_reference
<br>
<br>
"# download each run and skip the header"
<br>
for ACC in $(cut -d',' -f1 data/SraRunTable_A7.csv | tail -n +2); do
 <br>
  echo "Downloading $ACC ..."
  <br>
  fasterq-dump -O data "$ACC"
<br>
done
<br>
<br>
"# 2) download dog reference genome and unzip the file"
<br>
echo "Downloading dog reference genome..."
<br>
datasets download genome taxon "Canis familiaris" --reference --filename ref/dog.zip
<br>
unzip -o ref/dog.zip -d ref
<br>
echo "Done."
<br>
<br>
<br>
For Task 3, my script is as follows:
<br>
#!/bin/bash
<br>
cd ~/BIOCOMPUTING/assignments/assignment_7
<br>
mkdir -p data/clean
<br>
<br>
"# loop over forward reads"
<br>
for FWD in data/raw/*_1.fastq
<br>
do
    REV=${FWD/_1.fastq/_2.fastq}
    <br>
    <br>
    # move cleaned output names into ./data/clean/
    <br>
    OUTFWD=data/clean/$(basename "${FWD/.fastq/_clean.fastq}")
    <br>
    <br>
    OUTREV=data/clean/$(basename "${REV/.fastq/_clean.fastq}")
    <br>
    <br>
    # run fastp with default settings
    <br>
    fastp -i "$FWD" -I "$REV" -o "$OUTFWD" -O "$OUTREV"
    <br>
done
<br>
<br>
<br>
For Task 4, my script is as follows:
<br>
#!/bin/bash
<br>
REF=$(find ref -name "*.fna" | head -n 1)
<br>
mkdir -p output
<br>
# I think I already did this though when setting up structure?
<br>
<br>
#loop over forward reads; build the reverse and output names
<br>
for FWD in data/*.fastq; do
<br>
	REV=${FWD/_1.fastq/_2.fastq}
        <br>
	BASE=$(basename "$FWD" "_1.fastq")
        <br>
	OUTSAM="output/${BASE}_dog.sam"
        <br>
        <br>
        echo "Mapping $BASE ..."
        <br>
	bbmap.sh ref="$REF" in1="$FWD" in2="$REV" out="$OUTSAM" minid=0.95
<br>
done
<br>
echo "Done."

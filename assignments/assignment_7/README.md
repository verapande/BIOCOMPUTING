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
##Task 2
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
##Task 3
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
##Task 4
For Task 4, my script is as follows:
<br>
#!/bin/bash
<br>
REF=$(find ref -name "*.fna" | head -n 1)
<br>
mkdir -p output
<br>
#I think I already did this though when setting up structure?
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
<br>
<br>
<br>
##Task 5
For Task 5, my script is as follows:
<br>
#!/bin/bash
<br>
mkdir -p output
<br>
<br>
for SAM in output/*_dog.sam; do
        <br>	
	BASE=$(basename "$SAM" .sam)
        <br>      
	OUT="output/${BASE}_mapped.sam"
        <br>
	echo "Extracting mapped reads from $SAM..."
        <br>
	samtools view -F 4 "$SAM" > "$OUT"
<br>
done
<br>
echo "Done."
<br>
<br>
<br>
##Task 6
For Task 6, my slurm job/pipeline script is as follows:
<br>
#!/bin/bash
<br>
#SBATCH --job-name=Assignment_7
<br>
#SBATCH --nodes=1
<br>
#SBATCH --ntasks=1
<br>
#SBATCH --cpus-per-task=20
<br>
#SBATCH --time=0-12:00:00 # d-hh:mm:ss or just No. of minutes
<br>
#SBATCH --mem=120G # how much physical memory (all by default)
<br>
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
<br>
#SBATCH --mail-user=vpande@wm.edu # who to email
<br>
#SBATCH -o JOBNAME_%j.out #STDOUT to file (%j is jobID)
<br>
#SBATCH -e JOBNAME_%j.err #STDERR to file (%j is jobID)
<br>
set -euo pipefail
<br>
<br>
#make a variable called root
<br>
root=/sciclone/home/vpande/BIOCOMPUTING/assignments/assignment_7
<br>
<br>
export PATH=$PATH:$HOME/BIOCOMPUTING/programs/sratoolkit.3.2.1-ubuntu64/bin
<br>
export PATH=$HOME/BIOCOMPUTING/programs/bbmap:$PATH
<br>
export PATH=$HOME/BIOCOMPUTING/programs/datasets:$PATH
<br>
export PATH=$HOME/BIOCOMPUTING/programs/samtools-1.20:$PATH
<br>
export PATH=$HOME/BIOCOMPUTING/programs:$PATH
<br>
<br>
bash "$root/scripts/01_download_data.sh"
<br>
bash "$root/scripts/02_clean_reads.sh"
<br>
bash "$root/scripts/02_map_reads.sh"
<br>
bash "$root/scripts/03_extract_hits.sh"
<br>
echo "Done."

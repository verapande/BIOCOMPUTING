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
## Task 2
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
## Task 3
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
## Task 4
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
## Task 5
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
## Task 6
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
<br>
<br>
<br>
## Task 8
For Task 8, I wrote an extra script that shows each of my samples, the number
of QC reads, and the number of reads that ended up mapping to the dog genome, and
to really understand the extent of contamination the percent of reads contaminated
with dog reads. The script is as follows:
<br>
<br>
#!/bin/bash
<br>
# prints: Sample  QC_Reads  Dog_Mapped_Reads
<br>
<br>
echo -e "Sample\tQC_Reads\tDog_Mapped_Reads"
<br>
for f in ../data/clean/*_1_clean.fastq
<br>
do
  <br>
  <br>
  S=$(basename "$f" _1_clean.fastq)
  <br>
  <br>
  # QC reads: count FASTQ headers in R1
  QC=$(grep -c "^@" "$f")
  <br>
  <br>
  # mapped reads: count names from the ids file made by extract step
   <br>
   MAP=0
   <br>
 if [ -f "../output/hits/${S}_mapped_ids.txt" ]; then
   <br> 
    MAP=$(wc -l < "../output/hits/${S}_mapped_ids.txt")
  fi
  <br>
  <br>
  echo -e "${S}\t${QC}\t${MAP}"
  <br>
done
<br>
<br>
Here's what the table looked like:
sample	          QC   mapped  approx % dog contamination
SRR14719072	10.8M	204k	~1.9%
SRR14719074	12.7M	601k	~4.7%
SRR14719080	10.1M	27k	~0.27%
SRR14722429	8.7M	322k	~3.7%
SRR14722431	14.0M	15k	~0.11%
SRR14722433	9.9M	878k	~8.8%
SRR14722436	7.7M	108k	~1.4%
SRR14722437	8.4M	2.24M	~26.5% 
SRR14722438	9.1M	2.1M	~23% 
SRR14789347	13.2M	4.99M	~37.8% 
<br>
That's really crazy that virtually all of these samples are contaminated
with dog DNA!

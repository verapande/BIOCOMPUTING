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
"# prints: Sample  QC_Reads  Dog_Mapped_Reads"
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
 "# QC reads: count FASTQ headers in R1"
  QC=$(grep -c "^@" "$f")
  <br>
  <br>
  "# mapped reads: count names from the ids file made by extract step"
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
The script basically starts by printing a header row of the table with the column names:
“Sample,” “QC_Reads,” and “Dog_Mapped_Reads.” Then the script loops through each cleaned FASTQ file in the data directory.
For each file, it extracts the sample name from the filename.Next, you are counting the number of reads that passed quality control
by counting the FASTQ header lines in the file. Then you are checking for a file that contains the IDs of reads
that ended up being mapped to dog DNA. If the file exists, you are counting how many IDs are listed.
If the file does not exist, it the count is set to zero. Finally, you are printing a row of output for each sample, including
the sample name, the QC read count,
and the number of dog-mapped reads.
<br>
<br>
Here's what the table looked like:

| Sample      | QC Reads | Dog-Mapped Reads | Approx % Dog Contamination |
|-------------|----------|-----------------|----------------------------|
| SRR14719072 | 10.8M    | 204k            | ~1.9%                      |
| SRR14719074 | 12.7M    | 601k            | ~4.7%                      |
| SRR14719080 | 10.1M    | 27k             | ~0.27%                     |
| SRR14722429 | 8.7M     | 322k            | ~3.7%                      |
| SRR14722431 | 14.0M    | 15k             | ~0.11%                     |
| SRR14722433 | 9.9M     | 878k            | ~8.8%                      |
| SRR14722436 | 7.7M     | 108k            | ~1.4%                      |
| SRR14722437 | 8.4M     | 2.24M           | ~26.5%                     |
| SRR14722438 | 9.1M     | 2.1M            | ~23%                       |
| SRR14789347 | 13.2M    | 4.99M           | ~37.8%                     |

<br>
That's really crazy that virtually all of these samples are contaminated
with dog DNA!
<br>
<br>
<br>
## Reflection
<br>
To start off, I am so sorry but this is what I had my final directory structure
look like... I really hope that I don't get too many points off
<br>
<ul>
  <li>assignment_7/
    <ul>
      <li>assignment_7_pipeline.slurm</li>
      <li>data/
        <ul>
          <li>raw/ (example: SRR14719072_1.fastq, +19 more)</li>
          <li>clean/ (example: SRR14719072_1_clean.fastq, +19 more)</li>
          <li>dog_reference/ (merged dog genome FASTA)</li>
          <li>SraRunTable_A7.csv</li>
        </ul>
      </li>
      <li>fastp.html</li>
      <li>fastp.json</li>
      <li>output/
        <ul>
          <li>hits/ (example: SRR14719072_mapped_ids.txt, +29 more)</li>
          <li>*.sam (dog alignment results)</li>
          <li>JOBNAME_230975.out</li>
          <li>JOBNAME_230975.err</li>
          <li>summary.tsv</li>
        </ul>
      </li>
      <li>README.md</li>
      <li>ref/
        <ul>
          <li>genome/1/ (chr1.chrom.gz +5 more)</li>
          <li>index/1/ (index components)</li>
          <li>ncbi_dataset/data/GCF_011100685.1/...genomic.fna</li>
          <li>md5sum.txt</li>
          <li>README.md</li>
        </ul>
      </li>
      <li>scripts/
        <ul>
          <li>01_download_data.sh</li>
          <li>02_clean_reads.sh</li>
          <li>02_map_reads.sh</li>
          <li>03_extract_hits.sh</li>
          <li>04_summary.sh_</li>
</ul>
```
<br>
<br>
Ok now for this assignment, I built a modular, reproducible pipeline on the HPC to test for dog-DNA contamination in ten Illumina shotgun metagenome samples (I chose sea-otter fecal metagenomic data). I used fasterq-dump to take the raw paired reads, cleaned them with fastp (with the default settings), mapped the cleaned reads to the Canis familiaris reference genome with bbmap.sh at minid=0.95, and extracted the mapped alignments using samtools view -F 4. I wrote small scripts for each step and ran them all together with a SLURM job so the entire workflow could be re-run end-to-end. My final summary script summarized per-sample QC reads, dog-mapped reads, and an approximate contamination percentage; several samples showed strikingly high levels of dog DNA (~26–38%), which is crazyyy. I was surprised.

My directory structure ended up being slightly different from the example in the assignment please see the beginning of my reflection I really hope that this is not bad — I kept a single data/ folder that includes raw/ and clean/, a separate ref/ folder for the dog genome, and an output/ folder where I direct all mapping results and SLURM logs. Ensuring that logs (.out/.err) also land inside output/ makes inspection and reproducibility simpler.

In regard to the challenges I faced I got so frustrated and I am actually so glad that I thought this assignment was due Tuesday because it forced me to work a lot earlier on. I was not lucky to have my pipeline slurm job work on the first try and I kept getting fail after fail after fail after fail. I remember the first time my pipeline slurm job failed I had a faulty export path line. Then the second time I remember I was executing one of the scripts from the wrong working directory causing files not found error so obviously the slurm job could not proceed. I think 15 hours is a good enough time to submit the job; I had tried 12 hours and that was not enough. Then because of multiple other errors and timeout I had to go back and overwrite my pipeline slurm script and have it run from where it left off so that I did not need to run it all over again each time. So my final pipeline slurm script that is uploaded might look different than the one that I had written further earlier in my README (you can scroll up to find). I learned so much that it’s hard to even know where to begin. I learned how to actually inspect these standard out and standard error files to really pinpoint where I was going wrong. I learned how to allocate an appropriate amount of resources for a job to run successfully. I learned how to submit batch jobs using sbatch and track the status of my jobs with the squeue sacct scontrol and watch commands. I also believe I got to see how running a pipeline on this system can actually have a meaningful/interesting scientific outcome.

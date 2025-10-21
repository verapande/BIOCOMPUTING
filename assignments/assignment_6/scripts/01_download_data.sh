#!/bin/bash
# Downloads the dataset for the E. coli phage into ./data directory

mkdir -p data
cd data

wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/032/SRR12012232/SRR12012232_1.fastq.gz

echo "Download complete."


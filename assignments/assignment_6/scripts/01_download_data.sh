#!/bin/bash
# Downloads ONT dataset for E. coli phages into ./data directory

mkdir -p data
cd data

wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/032/SRR12012232/SRR12012232_1.fastq.gz

echo "downloaded to: $(pwd)"

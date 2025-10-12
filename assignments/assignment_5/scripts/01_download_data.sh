#!/bin/bash

mkdir -p data/raw
mkdir -p data/trimmed

# Step 1: download the tarball
wget https://gzahn.github.io/data/fastq_examples.tar

# Step 2: extract the contents
tar -xvf fastq_examples.tar

# Step 3: move all fastq files into ./data/raw/
mv *.fastq.gz data/raw/

# Step 4: clean up the tarball
rm -f fastq_examples.tar

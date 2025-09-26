#!/bin/bash

# Step 1: download the tarball
wget https://example.com/fastq_examples.tar

# Step 2: extract the contents
tar -xvf fastq_examples.tar

# Step 3: move all fastq files into ./data/raw/
mv *.fastq ./data/raw/

# Step 4: clean up the tarball
rm fastq_examples.tar

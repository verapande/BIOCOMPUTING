#!/bin/bash
FILE=$1

# total sequences = number of headers
seqs=$(grep -c '^>' $FILE)

# total nucleotides = everything but headers, no newlines
nts=$(grep -v '^>' $FILE | tr -d '\n' | wc -c)

echo "FASTA file: $FILE"
echo "Total number of sequences: $seqs"
echo "Total number of nucleotides: $nts"
echo "Sequence names and lengths (table):"

# put each header and sequence side by side
seqtk seq -l0 $FILE | paste - - > tmp.tsv

# show header + sequence length by counting characters in column 2
cut -f1 tmp.tsv
cut -f2 tmp.tsv | wc -c

#!/bin/bash

# first we have to take in a single name, the forward read file in this case
FWD_IN="$1"

# derive reverse input file name by swapping _R1_ for _R2_
REV_IN="${FWD_IN/_R1_/_R2_}"

# we have to make the output names by inserting ".trimmed" before the extension
FWD_OUT=${FWD_IN/%.fastq.gz/.trimmed.fastq.gz}
FWD_OUT=${FWD_OUT/%.fastq/.trimmed.fastq}

REV_OUT=${REV_IN/%.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_OUT/%.fastq/.trimmed.fastq}

# we then have to show any log file names too
fname=${FWD_IN##*/}          # strips the path
SAMPLE_ID=${fname%%_R1_*}    # prints everything before _R1_ in the name
STDOUT_LOG=./log/${SAMPLE_ID}.stdout.txt
STDERR_LOG=./log/${SAMPLE_ID}.stderr.txt

# we then have to run fastp on the given file with the settings below
fastp \
  --in1  $FWD_IN \
  --out1 $FWD_OUT \
  --in2  $REV_IN \
  --out2 $REV_OUT \
  --json /dev/null \
  --html /dev/null \
  --trim_front1 8 \
  --trim_front2 8 \
  --trim_tail1 20 \
  --trim_tail2 20 \
  --n_base_limit 0 \
  --length_required 100 \
  --average_qual 20 \

echo "done: $SAMPLE_ID"
echo "  FWD_OUT: $FWD_OUT"
echo "  REV_OUT: $REV_OUT"
echo "  STDOUT:  $STDOUT_LOG"
echo "  STDERR:  $STDERR_LOG"

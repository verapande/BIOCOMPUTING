Before beginning this assignment, I logged into the astral cluster using command line 
ssh vpande@astral.sciclone.wm.edu
<br>
<br>
For Task 1, to set up my assignment_5 directory I used the following workflow of command lines:
[1 vpande@astral ~ ]$ cd BIOCOMPUTING <br>
[2 vpande@astral ~/BIOCOMPUTING ]$ cd assignments <br>
[3 vpande@astral ~/BIOCOMPUTING/assignments ]$ mkdir assignment_5 <br>
[4 vpande@astral ~/BIOCOMPUTING/assignments ]$ cd assignment_5 <br>
[5 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ mkdir scripts log data <br>
[6 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ mkdir data/raw data/trimmed <br>
touch README.md
<br>
<br>
For Task 2, I navigated to my scripts folder and then wrote a new script as specified (01_download_data.sh) and then ran the command to make it executable. 
[11 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/data ]$ cd .. <br>
[12 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ cd scripts <br>
[13 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ <br>
RESET
[5 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ cd scripts <br>
[6 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ nano 01_download_data.sh <br>
[8 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ chmod +x 01_download_data.sh <br>
<br>
<br>
Within the script specifically this is what I wrote:
Step 1: download the tarball <br>
wget https://example.com/fastq_examples.tar <br>
<br>
Step 2: extract the contents of the tarball <br>
tar -xvf fastq_examples.tar <br>
<br>
Step 3: move all fastq files into ./data/raw/<br>
mv *.fastq ./data/raw/<br>
<br>
Step 4: clean up the tarball <br>
rm fastq_examples.tar <br>
<br>
<br>
Then I ran simple ls-l to confirm that the script was existent in the folder and that the executable command went through (file showed up in bold color). Then I navigated to my README.md file in my overall directory and here I am documenting everything.
[9 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ ls -l <br>
total 4
-rwx------. 1 vpande apscu 274 Sep 26 01:07 01_download_data.sh <br>
[10 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ cd .. <br>
[11 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ ls -l <br>
total 0
drwx------. 4 vpande apscu 44 Sep 25 21:34 data <br>
drwx------. 2 vpande apscu 10 Sep 25 21:33 log <br>
-rw-------. 1 vpande apscu  0 Sep 25 21:35 README.md <br>
drwx------. 2 vpande apscu 41 Sep 26 01:07 scripts <br>
[12 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ nano README.md
<br>
<br>
I went ahead and ran the script for Task2, but I got the error mv: cannot stat '*.fastq':
No such file or directory. The correct files downloaded to my computer but I forgot
that none of the files actually end in fastq only fastq.gz. So from the assignment
directory  I ran the following commands and then went back later and fixed my
script to avoid wasting a crazy amount of time.<br>
cd $HOME/BIOCOMPUTING/assignments/assignment_05
<br>
mv scripts/*.fastq.gz data/raw/
<br>
<br>
For Task 3, I navigated to the fastp GitHub repository and then copied
the link to the download of fastp. I then navigated to my programs directory
within BIOCOMPUTING on the terminal and then downloaded the fastp program using
this:
[10 vpande@astral ~/BIOCOMPUTING ]$ cd programs
[11 vpande@astral ~/BIOCOMPUTING/programs ]$ ls -l
total 27620
-rwx------. 1 vpande apscu 19775672 Aug 19 03:35 seqkit
-rw-------. 1 vpande apscu  8502341 Aug 19 03:52 seqkit_linux_amd64.tar.gz
[12 vpande@astral ~/BIOCOMPUTING/programs ]$ wget http://opengene.org/fastp/fastp
--2025-10-01 14:54:58--  http://opengene.org/fastp/fastp<br>
Resolving opengene.org (opengene.org)... 8.210.133.117<br>
Connecting to opengene.org (opengene.org)|8.210.133.117|:80... connected.<br>
HTTP request sent, awaiting response... 301 Moved Permanently<br>
Location: https://opengene.org/fastp/fastp [following]<br>
--2025-10-01 14:54:58--  https://opengene.org/fastp/fastp<br>
Connecting to opengene.org (opengene.org)|8.210.133.117|:443... connected.<br>
HTTP request sent, awaiting response... 200 OK<br>
Length: 12956032 (12M) [application/octet-stream]<br>
Saving to: ‘fastp’<br>

fastp                         100%[==============================================>]  12.36M  3.47MB/s    in 3.6s    
<br>
2025-10-01 14:55:03 (3.47 MB/s) - ‘fastp’ saved [12956032/12956032]
<br>
I then made the fastp program executable, added the location of the fastp program
to my $PATH via my ~/.bashrc script, and asked for the version using the following
command lines:<br>
[13 vpande@astral ~/BIOCOMPUTING/programs ]$chmod +x fastp<br>
nano ~/.bashrc and export PATH="/sciclone/home/vpande/BIOCOMPUTING/programs:$PATH"
[14 vpande@astral ~/BIOCOMPUTING/programs ]$<br> 
[18 vpande@astral ~/BIOCOMPUTING/programs ]$fastp -v<br>
fastp 1.0.1 (version spitted out)
<br>
<br>
For Task 4, I wrote the following script:<br>
#!/bin/bash<br>
<br>
# first we have to take in a single name, the forward read file in this case
<br>
FWD_IN="$1"
<br>
# derive reverse input file name by swapping _R1_ for _R2_
<br>
REV_IN="${FWD_IN/_R1_/_R2_}"
<br>
# we have to make the output names by inserting ".trimmed" before the extension
FWD_OUT="${FWD_IN/.fastq.gz/.trimmed.fastq.gz}"
<br>
FWD_OUT="${FWD_OUT/.fastq/.trimmed.fastq}"
<br>
REV_OUT="${REV_IN/.fastq.gz/.trimmed.fastq.gz}"
<br>
REV_OUT="${REV_OUT/.fastq/.trimmed.fastq}"

# we then have to show any log file names too
<br>
fname=${FWD_IN##*/}          # strips the path
<br>
SAMPLE_ID=${fname%%_R1_*}    # prints everything before _R1_ in the name
<br>
STDOUT_LOG=./log/${SAMPLE_ID}.stdout.txt
<br>
STDERR_LOG=./log/${SAMPLE_ID}.stderr.txt
<br>
# we then have to run fastp on the given file with the settings below
<br>
fastp \
 <br> --in1  $FWD_IN \
 <br> --out1 $FWD_OUT \
 <br> --in2  $REV_IN \
 <br> --out2 $REV_OUT \
 <br>--json /dev/null \
 <br> --html /dev/null \
 <br> --trim_front1 8 \
 <br> --trim_front2 8 \
 <br> --trim_tail1 20 \
 <br> --trim_tail2 20 \
 <br> --n_base_limit 0 \
 <br> --length_required 100 \
 <br> --average_qual 20 \
<br>
<br>echo "done: $SAMPLE_ID"
<br>echo "  FWD_OUT: $FWD_OUT"
<br>echo "  REV_OUT: $REV_OUT"
<br>echo "  STDOUT:  $STDOUT_LOG"
<br>echo "  STDERR:  $STDERR_LOG"
<br>
For the last part of this task, I ran this script on the first sample from
the list that we downloaded previously using the command line: [69 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz.
I believe it correctly outputted:
<br>
Read1 before filtering:
<br>
total reads: 100
<br>
total bases: 29768
<br>
Q20 bases: 28913(97.1278%)
<br>
Q30 bases: 27086(90.9903%)
<br>
Q40 bases: 27086(90.9903%)
<br>
<br>
Read2 before filtering:
<br>
total reads: 100
<br>
total bases: 29795
<br>
Q20 bases: 26624(89.3573%)
<br>
Q30 bases: 21779(73.0962%)
<br>
Q40 bases: 21779(73.0962%)
<br>

Read1 after filtering:
<br>
total reads: 99
<br>
total bases: 26961
<br>
Q20 bases: 26543(98.4496%)
<br>
Q30 bases: 25305(93.8578%)
<br>
Q40 bases: 25305(93.8578%)
<br>

Read2 after filtering:
<br>
total reads: 99
<br>
total bases: 26988
<br>
Q20 bases: 24751(91.7111%)
<br>
Q30 bases: 20834(77.1973%)
<br>
Q40 bases: 20834(77.1973%)
<br>
<br>
Filtering result:
<br>
reads passed filter: 198
<br>
reads failed due to low quality: 2
<br>
reads failed due to too many N: 0
<br>
reads failed due to too short: 0
<br>
reads with adapter trimmed: 0
<br>
bases trimmed due to adapters: 0
<br>
<br>
Duplication rate: 0%
<br>
Insert size peak (evaluated by paired-end reads): 400
<br>
JSON report: /dev/null
<br>
HTML report: /dev/null
<br>
<br>
fastp --in1 ./data/raw/6083_001_S1_R1_001.subset.fastq.gz --out1 ./data/raw/6083_001_S1_R1_001.subset.trimmed.fastq.gz --in2 ./data/raw/6083_001_S1_R2_001.subset.fastq.gz --out2 ./data/raw/6083_001_S1_R2_001.subset.trimmed.fastq.gz --json /dev/null --html /dev/null --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20 
fastp v1.0.1, time used: 0 seconds
done: 6083_001_S1
<br>
  FWD_OUT: ./data/raw/6083_001_S1_R1_001.subset.trimmed.fastq.gz
<br>
  REV_OUT: ./data/raw/6083_001_S1_R2_001.subset.trimmed.fastq.gz
<br>
  STDOUT:  ./log/6083_001_S1.stdout.txt
<br>
  STDERR:  ./log/6083_001_S1.stderr.txt
<br>
<br>
For Task 5, this is what my pipeline.sh script looked like:
#!/bin/bash
<br>
set -euo pipefail
<br>
<br>
echo "downloading data..."
<br>
./scripts/01_download_data.sh
<br>
<br>
echo "running fastp on all R1 files..."
<br>
for FWD_IN in ./data/raw/*_R1_*.fastq.gz; do
<br>
  ./scripts/02_run_fastp.sh "$FWD_IN"
<br>
done
<br>
<br>
echo "pipeline complete."
<br>
<br>
For Task 6, to start over and see if my script/pipeline.sh script could really
work, I deleted the data files I downloaded with the command line:
<br>
[85 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ rm -f ./data/raw/*.fastq ./data/raw/*.fastq.gz. I then made the script executable using
<br>
[94 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ chmod +x pipeline.sh
<br>
I pasted what the results look like in a pdf document in my drive that you
could read: https://drive.google.com/file/d/1Xv-MES4SG19zbOyKZ77r8MxqvWZIe7Ym/view?usp=sharing
to confirm the script did indeed work or if you curious to see the output.

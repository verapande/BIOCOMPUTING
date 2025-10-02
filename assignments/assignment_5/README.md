<h1>Assignment 5</h1>

<p>Before beginning this assignment, I logged into the astral cluster using command line <code>ssh vpande@astral.sciclone.wm.edu</code></p>

<hr>

<h2>Task 1</h2>
<p>For Task 1, to set up my assignment_5 directory I used the following workflow of command lines:</p>

<pre><code>[1 vpande@astral ~ ]$ cd BIOCOMPUTING
[2 vpande@astral ~/BIOCOMPUTING ]$ cd assignments
[3 vpande@astral ~/BIOCOMPUTING/assignments ]$ mkdir assignment_5
[4 vpande@astral ~/BIOCOMPUTING/assignments ]$ cd assignment_5
[5 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ mkdir scripts log data
[6 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ mkdir data/raw data/trimmed
touch README.md
</code></pre>

<hr>

<h2>Task 2</h2>
<p>For Task 2, I navigated to my scripts folder and then wrote a new script as specified (01_download_data.sh) and then ran the command to make it executable.</p>

<pre><code>[11 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/data ]$ cd ..
[12 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ cd scripts
[13 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$
RESET
[5 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ cd scripts
[6 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ nano 01_download_data.sh
[8 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ chmod +x 01_download_data.sh
</code></pre>

<p>Within the script specifically this is what I wrote:</p>
<p><b>Step 1:</b> download the tarball</p>
<pre><code>wget https://example.com/fastq_examples.tar
</code></pre>

<p><b>Step 2:</b> extract the contents of the tarball</p>
<pre><code>tar -xvf fastq_examples.tar
</code></pre>

<p><b>Step 3:</b> move all fastq files into ./data/raw/</p>
<pre><code>mv .fastq ./data/raw/
</code></pre>

<p><b>Step 4:</b> clean up the tarball</p>
<pre><code>rm fastq_examples.tar
</code></pre>

<p>Then I ran simple ls-l to confirm that the script was existent in the folder and that the executable command went through (file showed up in bold color). Then I navigated to my README.md file in my overall directory and here I am documenting everything.</p>

<pre><code>[9 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ ls -l
total 4 -rwx------. 1 vpande apscu 274 Sep 26 01:07 01_download_data.sh
[10 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ cd ..
[11 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ ls -l
total 0 drwx------. 4 vpande apscu 44 Sep 25 21:34 data
drwx------. 2 vpande apscu 10 Sep 25 21:33 log
-rw-------. 1 vpande apscu 0 Sep 25 21:35 README.md
drwx------. 2 vpande apscu 41 Sep 26 01:07 scripts
[12 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ nano README.md
</code></pre>

<p>I went ahead and ran the script for Task2, but I got the error <code>mv: cannot stat '.fastq': No such file or directory</code>. The correct files downloaded to my computer but I forgot that none of the files actually end in fastq only fastq.gz. So from the assignment directory I ran the following commands and then went back later and fixed my script to avoid wasting a crazy amount of time.</p>

<pre><code>cd $HOME/BIOCOMPUTING/assignments/assignment_05
mv scripts/*.fastq.gz data/raw/
</code></pre>

<hr>

<h2>Task 3</h2>
<p>For Task 3, I navigated to the fastp GitHub repository and then copied the link to the download of fastp. I then navigated to my programs directory within BIOCOMPUTING on the terminal and then downloaded the fastp program using this:</p>

<pre><code>[10 vpande@astral ~/BIOCOMPUTING ]$ cd programs
[11 vpande@astral ~/BIOCOMPUTING/programs ]$ ls -l
total 27620
-rwx------. 1 vpande apscu 19775672 Aug 19 03:35 seqkit
-rw-------. 1 vpande apscu 8502341 Aug 19 03:52 seqkit_linux_amd64.tar.gz
[12 vpande@astral ~/BIOCOMPUTING/programs ]$ wget http://opengene.org/fastp/fastp
--2025-10-01 14:54:58-- http://opengene.org/fastp/fastp
Resolving opengene.org (opengene.org)... 8.210.133.117
Connecting to opengene.org (opengene.org)|8.210.133.117|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://opengene.org/fastp/fastp [following]
--2025-10-01 14:54:58-- https://opengene.org/fastp/fastp
Connecting to opengene.org (opengene.org)|8.210.133.117|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12956032 (12M) [application/octet-stream]
Saving to: ‘fastp’

fastp 100%[==============================================>] 12.36M 3.47MB/s in 3.6s

2025-10-01 14:55:03 (3.47 MB/s) - ‘fastp’ saved [12956032/12956032]
</code></pre>

<p>I then made the fastp program executable, added the location of the fastp program to my $PATH via my ~/.bashrc script, and asked for the version using the following command lines:</p>

<pre><code>[13 vpande@astral ~/BIOCOMPUTING/programs ]$ chmod +x fastp
nano ~/.bashrc and export PATH="/sciclone/home/vpande/BIOCOMPUTING/programs:$PATH"
[14 vpande@astral ~/BIOCOMPUTING/programs ]$
[18 vpande@astral ~/BIOCOMPUTING/programs ]$ fastp -v
fastp 1.0.1 (version spitted out)
</code></pre>

<hr>

<h2>Task 4</h2>
<p>For Task 4, I wrote the following script:</p>

<pre><code>#!/bin/bash


first we have to take in a single name, the forward read file in this case

FWD_IN="$1"
# derive reverse input file name by swapping _R1_ for _R2_
REV_IN="${FWD_IN/_R1_/_R2_}"
# we have to make the output names by inserting ".trimmed" before the extension FWD_OUT="${FWD_IN/.fastq.gz/.trimmed.fastq.gz}"
FWD_OUT="${FWD_OUT/.fastq/.trimmed.fastq}"
REV_OUT="${REV_IN/.fastq.gz/.trimmed.fastq.gz}"
REV_OUT="${REV_OUT/.fastq/.trimmed.fastq}"
we then have to show any log file names too

fname=${FWD_IN##*/} # strips the path
SAMPLE_ID=${fname%%_R1_*} # prints everything before _R1_ in the name
STDOUT_LOG=./log/${SAMPLE_ID}.stdout.txt
STDERR_LOG=./log/${SAMPLE_ID}.stderr.txt
# we then have to run fastp on the given file with the settings below
fastp \
--in1 $FWD_IN \
--out1 $FWD_OUT \
--in2 $REV_IN \
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
echo " FWD_OUT: $FWD_OUT"
echo " REV_OUT: $REV_OUT"
echo " STDOUT: $STDOUT_LOG"
echo " STDERR: $STDERR_LOG"
</code></pre>

<p>For the last part of this task, I ran this script on the first sample from the list that we downloaded previously using the command line:</p>

<pre><code>[69 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ ./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz
</code></pre>

<p>I believe it correctly outputted:</p>

<pre><code>Read1 before filtering:
total reads: 100
total bases: 29768
Q20 bases: 28913(97.1278%)
Q30 bases: 27086(90.9903%)
Q40 bases: 27086(90.9903%)

Read2 before filtering:
total reads: 100
total bases: 29795
Q20 bases: 26624(89.3573%)
Q30 bases: 21779(73.0962%)
Q40 bases: 21779(73.0962%)
Read1 after filtering:
total reads: 99
total bases: 26961
Q20 bases: 26543(98.4496%)
Q30 bases: 25305(93.8578%)
Q40 bases: 25305(93.8578%)

Read2 after filtering:
total reads: 99
total bases: 26988
Q20 bases: 24751(91.7111%)
Q30 bases: 20834(77.1973%)
Q40 bases: 20834(77.1973%)

Filtering result:
reads passed filter: 198
reads failed due to low quality: 2
reads failed due to too many N: 0
reads failed due to too short: 0
reads with adapter trimmed: 0
bases trimmed due to adapters: 0

Duplication rate: 0%
Insert size peak (evaluated by paired-end reads): 400
JSON report: /dev/null
HTML report: /dev/null

fastp --in1 ./data/raw/6083_001_S1_R1_001.subset.fastq.gz --out1 ./data/raw/6083_001_S1_R1_001.subset.trimmed.fastq.gz --in2 ./data/raw/6083_001_S1_R2_001.subset.fastq.gz --out2 ./data/raw/6083_001_S1_R2_001.subset.trimmed.fastq.gz --json /dev/null --html /dev/null --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20
fastp v1.0.1, time used: 0 seconds
done: 6083_001_S1
FWD_OUT: ./data/raw/6083_001_S1_R1_001.subset.trimmed.fastq.gz
REV_OUT: ./data/raw/6083_001_S1_R2_001.subset.trimmed.fastq.gz
STDOUT: ./log/6083_001_S1.stdout.txt
STDERR: ./log/6083_001_S1.stderr.txt
</code></pre>

<hr>

<h2>Task 5</h2>
<p>For Task 5, this is what my pipeline.sh script looked like:</p>

<pre><code>#!/bin/bash
set -euo pipefail

echo "downloading data..."
./scripts/01_download_data.sh

echo "running fastp on all R1 files..."
for FWD_IN in ./data/raw/R1.fastq.gz; do
./scripts/02_run_fastp.sh "$FWD_IN"
done

echo "pipeline complete."
</code></pre>

<hr>

<h2>Task 6</h2>
<p>For Task 6, to start over and see if my script/pipeline.sh script could really work, I deleted the data files I downloaded with the command line:</p>

<pre><code>[85 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5 ]$ rm -f ./data/raw/.fastq ./data/raw/.fastq.gz
</code></pre>

<p>I then made the script executable using</p>

<pre><code>[94 vpande@astral ~/BIOCOMPUTING/assignments/assignment_5/scripts ]$ chmod +x pipeline.sh
</code></pre>

<p>I pasted what the results look like in a pdf document in my drive that you could read: <a href="https://drive.google.com/file/d/1Xv-MES4SG19zbOyKZ77r8MxqvWZIe7Ym/view?usp=sharing">https://drive.google.com/file/d/1Xv-MES4SG19zbOyKZ77r8MxqvWZIe7Ym/view?usp=sharing</a> to confirm the script did indeed work or if you curious to see the output.</p>

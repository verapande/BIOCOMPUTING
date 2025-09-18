*Vera Pande, 09/17/2025, Assignment #3*
<br>
<br>
Documenting here everything I have run for assignment_3.
<br>
To log into astral cluster I wrote command line
<br>
 ssh vpande@astral.sciclone.wm.edu
<br>
<br>
Then to set up assignment_3/ directory I wrote command lines:
<br>
[1 vpande@astral ~ ]$ cd ~/BIOCOMPUTING
<br>
[2 vpande@astral ~/BIOCOMPUTING ]$ mkdir -p assignments/assignment_3/data
<br>
[3 vpande@astral ~/BIOCOMPUTING ]$ touch assignments/assignment_3/README.md
<br>
[4 vpande@astral ~/BIOCOMPUTING ]$ ls -la assignments/assignment_3 (this last one to check that indeed directory structure was properly set up)
<br>
Then wrote
<br> 
cd ~/BIOCOMPUTING/assignments/assignment_3/data to get inside directory and then 
$ wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz to download file into the directory
<br>
Then wrote gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz to uncompress the file
<br>
<br>
<br>
To push everything to my actual repository, wrote git -C ~/BIOCOMPUTING status
<br>
On branch main
<br>
Your branch is up to date with 'origin/main'.
Then [15 vpande@astral ~ ]$ cd ~/BIOCOMPUTING
<br>
[16 vpande@astral ~/BIOCOMPUTING ]$ git remote -v
origin	https://github.com/verapande/BIOCOMPUTING.git (fetch)
origin	https://github.com/verapande/BIOCOMPUTING.git (push)
<br>
[17 vpande@astral ~/BIOCOMPUTING ]$git remote set-url origin https://github.com/verapande/BIOCOMPUTING.git
<br>
[18 vpande@astral ~/BIOCOMPUTING ]$ git pull origin main
From https://github.com/verapande/BIOCOMPUTING
 * branch            main       -> FETCH_HEAD
Already up to date.
<br>
[19 vpande@astral ~/BIOCOMPUTING ]$ git push origin main
Username for 'https://github.com': verapande
Password for 'https://verapande@github.com': 
Everything up-to-date
<br>
<br>
Was getting so close to having everything pushed to the repository but then the system continuously was rejecting the genomic fasta sequence file because apparently it was a large file. Had to do a quick google search to figure out how to troubleshoot this and figured that I needed to undo my last commit (all command lines not shown here) but keep all of the changes staged, then I needed to set up Git Large File Storage (a helpful extension for processing large data files), then tell git lfs to manage any file ending in .fna (because the file that I was specifically working with is a fna file), and then re-add everything, save changes, and upload.
<br>
 I wrote the following command lines:
<br>
remote: error: File assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna is 114.13 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/verapande/BIOCOMPUTING.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/verapande/BIOCOMPUTING.git'
<br>
<br>
[24 vpande@astral ~/BIOCOMPUTING ]$ git reset --soft HEAD~1
<br>
[25 vpande@astral ~/BIOCOMPUTING ]$ git rm --cached assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna
rm 'assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna'
<br>
[26 vpande@astral ~/BIOCOMPUTING ]$ git lfs install
Updated Git hooks.
Git LFS initialized.
<br>
[27 vpande@astral ~/BIOCOMPUTING ]$ git lfs track "*.fna"
Tracking "*.fna"
<br>
[28 vpande@astral ~/BIOCOMPUTING ]$ git add .gitattributes
<br>
[29 vpande@astral ~/BIOCOMPUTING ]$ git add assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna
<br>
[30 vpande@astral ~/BIOCOMPUTING ]$ git commit -m "Add assignment_3 and troubleshooting to add large files to github"
[main 6199477] Add assignment_3 and troubleshooting to add large files to github
 Committer: Vera Pande--vpande@wm.edu--vpande---Geoffrey Zahn [gzahn@wm.edu] <vpande@astral.sciclone.wm.edu>
 
<br>
<br>
Then wrote nano.README.md to start documenting here.
<br>
<br>
<br>
<br>
<br>
To manually develop and run a series of commands to do the 10 exercises for assignment_3
<br>
For #1, wrote command line: [63 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$ grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
<br>
<br>
For #2, wrote command line: [65 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep -v '^>' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -c
<br>
<br>
For #3, got so confused with this Q. kept returning 14 as total # of lines.
had to write a few lines in bash for this.
<br>
[10 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$


H=$(grep -c '^>' GCF_000001735.4_TAIR10.1_genomic.fna) (to get the total number of headers)

to get total number of nucleotides again total nucleotides (excluding headers & newlines)
N=$(grep -v '^>' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -c)

then getting an approximation of total number of lines assuming there are ~80 nucleotides per line (had to look this up)
width=80
echo $(( (N + width - 1)/width + H )) (mathematical function)


answer: 1495865
<br>
<br>
For #4, wrote command line: [29 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep -c 'mitochondrion' GCF_000001735.4_TAIR10.1_genomic.fna
<br>
<br>
For #5, wrote command line: [30 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep -c 'chromosome' GCF_000001735.4_TAIR10.1_genomic.fna
<br>
<br>
For #6, wrote command line(s): [32 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$( grep -A1 '^>.*chromosome 1' GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tr -d '\n' | wc -c ) > c1
( grep -A1 '^>.*chromosome 2' GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tr -d '\n' | wc -c ) > c2
( grep -A1 '^>.*chromosome 3' GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tr -d '\n' | wc -c ) > c3
paste c1 c2 c3
30427671	19698289	23459830
<br>
In this series of command lines I am essentially finding the FASTA header line
for chromosomes, removing the header line leaving only the dNA sequence, deleting 
all newline characters, counting the total # of characters (nucleotides) in
the chromosome's sequence, and redirecting result for each chromsome 1-3.
Then pasting to take all three files and combine them side by side via column.
<br>
<br>
For #7, wrote command line(s): [43 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep -n '^>' GCF_000001735.4_TAIR10.1_genomic.fna
1:>NC_003070.9 Arabidopsis thaliana chromosome 1 sequence
3:>NC_003071.7 Arabidopsis thaliana chromosome 2, partial sequence
5:>NC_003074.8 Arabidopsis thaliana chromosome 3, partial sequence
7:>NC_003075.7 Arabidopsis thaliana chromosome 4, partial sequence
9:>NC_003076.8 Arabidopsis thaliana chromosome 5, partial sequence
11:>NC_037304.1 Arabidopsis thaliana ecotype Col-0 mitochondrion, complete genome
13:>NC_000932.1 Arabidopsis thaliana chloroplast, complete genome
[44 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$head -10 GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n' | wc -c
26975502
<br>
Here I am essentially finding out where each sequence starts and then counting
the number of nucleotides in one particular line.
<br>
<br>
For #8, wrote command line: [45 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep -c 'AAAAAAAAAAAAAAAA' GCF_000001735.4_TAIR10.1_genomic.fna
<br>
<br>
For #9, wrote command line: [50 vpande@astral ~/BIOCOMPUTING/assignments/assignment_3/data ]$grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -1
<br>
<br>
For #10, I am so lost and confused. The only command line that is working is one
that CHATGPT is providing which I have typed out below:
<br>
awk '/^>/ {if (seq) {print hdr "\t" seq}; hdr=$0; seq=""; next} {seq=seq $0} END {print hdr "\t" seq}' \
GCF_000001735.4_TAIR10.1_genomic.fna > genome_tab.tsv. I tried it out with 
a test command and it is printing out one of the full sequences and its
respective header on the same line tab spaced.
<br>
<br>
<br>
<br>
<br>
REFLECTION:
Working through this assignment definitely forced my mind to shift into a different
way of thinking. I learned to see patterns and structures in a piece of biological
data through the lens of running command lines in the terminal.
I was surprised by the fact that you could download virtually any file on the internet
using the wget command and then unzip the file with another command and push it to your
github. I also got really frustrated with Q10 and had to use the internet to find out
command lines that correctly make a new tab-separated version of the file where the first
column is the headers and the second column being the associated sequences. The internet
suggested the use of functions like awk and sed which I have yet to learn. Yet another frustration
was trying to do process substitution; it worked on my laptop but wasn't working on the astral
server. Additional comments are listed under specific command lines further above.
I think these kinds of skills are essential in computational biology because a lot of biological
data can come in the form of large large files and can be messy. Whether you are working with genomes,
transcriptomic data, or clinical data sets, no GUI program is able to handle everything.

Looking forward, I could imagine automating a few of the steps I did manually. We just learned how to 
write shell scripts so hopefully I could write a shell script to take a FASTA file, count the number
of sequences, count the number of nucleotides, and produce a clean TSV file with headers and sequences.
This would be way way into the future, but with a larger skillset maybe I would be able to filter sequencing
by quality/GC, identify SNPs/indels, ask where exons/promoters/repeats fall, and feed results into Python/R
for statistics, plots, and other biological intepretation.

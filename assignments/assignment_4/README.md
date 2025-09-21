For Task 2, I went through the official cli Github page and then found the specific file that I needed by hitting tags, then
finding 2.74.2, then clicking on GitHub CLI 2.74.2 linux amd64 which led me to the correct URL/file that I needed to download.
Using the command line I went into my programs directory, used the wget command to download the file and unpack it, and used the
tar command to unpack the gzipped tarball.
* apparently x = extract
* z = handle gzip compression
* v = verbose (lists files as they’re extracted”
* f = filename
<br>
<br>
For Task 3, I wrote a script called install_gh.sh, inserted it into my programs directory, and essentially showed everything  I
had done in Task 2. You can view the code below:
#!/bin/bash
<br>
cd ~/programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz
<br>
Before I ran this script, I made sure it was executable by running the command line  chmod +x install_gh.sh
<br>
<br>
For Task 5, I added the location of the gh binary to my $PATH  by running the following command lines: 
nano ~/.bashrc
<br>
export PATH=$HOME/programs/gh_2.74.2_linux_amd64/bin:$PATH
<br>
<br>
For Task 6, I ran the command line, gh auth login. Then the terminal led to me to a weird interactive setup and I was able 
to using my arrow keys and simple enter choose what account I wanted to log into, what my preferred protocol for Git operations
was (HTTPS), if I wanted to authenticate Git with my GitHub credentials, and how I would like to authenticate Github CLI which 
was obviously pasting an authentication token (easiest). Below is what my output/interface kinda looked like:
<br>
Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
<br>
? Generate a new SSH key to add to your GitHub account? No
<br>
? How would you like to authenticate GitHub CLI? Paste an authentication token
<br>
Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
<br>
The minimum required scopes are 'repo', 'read:org'.
<br>
? Paste your authentication token: ****************************************
<br>
- gh config set -h github.com git_protocol ssh
<br>
✓ Configured git protocol
! Authentication credentials saved in plain text
✓ Logged in as verapande  
<br>
<br>
For Task 7, I created another installation script for a new program called seqtk. I went into my programs directory and wrote
the following script:
<br>
#!/bin/bash
<br>
cd ~/programs
<br>
# Clone the seqtk repo
git clone https://github.com/lh3/seqtk.git
<br>
# Go into the folder and build it
<br>
cd seqtk
<br>
make
<br>
<br>
I then went into bashrc using the command line nano ~/.bashrc and made sure that the path was copied over to my home (export PATH=$HOME/programs/seqtk:$PATH)
<br>
<br>
<br>
To figure out the seqtk program, I ran seqtk and it showed me all the commands that it is able to run.
<br>
Command: 
        *  seq       common transformation of FASTA/Q
        *  size      report the number sequences and bases
        *  comp      get the nucleotide composition of FASTA/Q
        * sample    subsample sequences
        *  subseq    extract subsequences from FASTA/Q
        * fqchk     fastq QC (base/quality summary)
        * mergepe   interleave two PE FASTA/Q files
        * split     split one file into multiple smaller files
        * trimfq    trim FASTQ using the Phred algorithm

        * hety      regional heterozygosity
        * gc        identify high- or low-GC regions
        * mutfa     point mutate FASTA at specified positions
        * mergefa   merge two FASTA/Q files
        * famask    apply a X-coded FASTA to a source FASTA
        * dropse    drop unpaired from interleaved PE FASTA/Q
        * rename    rename sequence names
        * randbase  choose a random base from hets
        * cutN      cut sequence at long N
        * gap       get the gap locations
        * listhet   extract the position of each het
        * hpc       homopolyer-compressed sequence
        * telo      identify telomere repeats in asm or long reads
<br>
To play around and try things on the file from the previous assignment (assignment 3), I wrote
* seqtk size ~/BIOCOMPUTING/assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna (to get the total number
of sequences and nucleotides and it outputted 7 and 119,668,634.
* seqtk seq -r ~/BIOCOMPUTING/assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna | head (which gave me the
reverse complementary sequence)
* and [1 vpande@bora ~ ]$seqtk comp ~/BIOCOMPUTING/assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna | head
(which outputted NC_003070.9	30427671	9709674	5435374	5421151	9697113	401	0	163958	1394754	283	118	11
NC_003071.7	19698289	6315641	3542973	3520766	6316348	55	0	2506	915152	36	19	4
NC_003074.8	23459830	7484757	4258333	4262704	7448059	11	0	5966	1118068	5	6	3
NC_003075.7	18585056	5940546	3371349	3356091	5914038	1	1	3030	879170	1	0	0
NC_003076.8	26975502	8621974	4832253	4858759	8652238	0	0	10278	1260598	0	0	0
NC_037304.1	367808	102130	82530	82219	100929	0	0	0	27538	0	0	0
NC_000932.1	154478	48546	28496	27570	49866	0	0	0	9278	0	0	0

You were able to see in different columns the Sequence name (ID from FASTA header)
<br>
Sequence length
<br>
Number of A’s
<br>
Number of C’s
<br>
Number of G’s
<br>
Number of T’s
<br>
Number of N’s
<br>
Number of other ambiguous bases (anything not A/C/G/T/N)
<br>
Number of CpG dinucleotides (CG)
<br>
Number of GpC dinucleotides (GC)
<br>
Number of “other” ambiguous IUPAC codes (like R, Y, W, S, etc.) — counts are broken into multiple extra columns)
<br>
<br>
<br>
For Task 9, I went back to my assignment_4 directory and built yet another shell script that accepted the name of a fasta file as a positional argument ($1),
stored that filename in a variable, calculated and stored as tmp files the total number of nucleotides, sequences, and a table of
all of the sequence names and lengths in the file, and reported the information to stdout with explanations. The following code
was what I wrote in the script:
<br>
#!/bin/bash
FILE=$1
<br>
total sequences = number of headers
<br>
seqs=$(grep -c '^>' $FILE)
<br>
total nucleotides = everything but headers, no newlines
<br>
nts=$(grep -v '^>' $FILE | tr -d '\n' | wc -c)
<br>
echo "FASTA file: $FILE"
<br>
echo "Total number of sequences: $seqs"
<br>
echo "Total number of nucleotides: $nts"
<br>
echo "Sequence names and lengths (in a table format):”
<br>
put each header and sequence side by side
<br>
seqtk seq -l0 $FILE | paste - - > tmp.tsv
<br>
show header + sequence length by counting characters in column 2
<br>
cut -f1 tmp.tsv
<br>
cut -f2 tmp.tsv | wc -c
<br>
<br>
<br>
As always I wrote command line chmod +x summarize_fasta.sh to ensure that I could execute my script and ran it on the file
from assignment three using the command line: ./summarize_fasta.sh ~/BIOCOMPUTING/assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna.
<br>
<br>
<br>
For final task 10, I ran summarize_fasta.sh in a loop on multiple fastA files by downloading a couple of random files off of 
NCBI and also making a duplicate of the assignment_3 file to just be a placeholder random fna file so I could still work
with as many fna files as possible. I wrote the following program/for loop to carry out what was required of this task:
<br>
cd ~/BIOCOMPUTING/assignments/assignment_4
<br>
for f in data/*.fna
<br>
do
<br> 
 ./summarize_fasta.sh "$f"
<br>
done
<br>
<br>
<br>
<br>
<br>
REFLECTION: 
One thing I found really frustrating  was actually logging in with gh auth login. At first I clicked the HTTPS option and it opened up this weird black screen with blue text inside my terminal that was supposed to be GitHub’s login page. It was really confusing and hard to use. I ended up the second time using SSH as my preferred method of logging in.
Another thing was was writing the summarize_fasta.sh script and especially the last part where it had to print the table. At one point it just kept spitting out millions of DNA letters instead of a table, which was frustrating. I eventually figured out how to make it print each header and the length of the sequence instead of dumping the whole sequence.
<br>
From this assignment I learned how to install and run programs on the HPC myself, like gh and seqtk, and how to add them to my $PATH. I also learned how to scrape through GitHub looking for the right file to download, instead of relying on admin-only installation methods. I learned what the heck seqtk actually does, and I can already see how it could be very helpful for analyzing genetic sequencing data. I got more practice writing bash scripts and using for-loops to run the same script across multiple files.
<br>
$PATH is basically the list of places the shell looks when I type a command. If the folder where a program lives is in $PATH, I can just type the program name from anywhere and it works. That’s why after I added gh and seqtk to my $PATH, I didn’t have to type the full directory path anymore.

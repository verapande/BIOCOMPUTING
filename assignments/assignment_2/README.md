*Vera Pande, 09/11/2025, Assignment #2*
<br>
<br>
<br>

For Task 2, to download files from NCBI via command-line FTP, I first
installed inetutils via homebrew to provide the ftp client for Mac because
I am on a Mac.
command line: brew install inetutils 

<br>

Then I connected to the NCBI FTP server and navigated to the
correct directory. For some reason I had to use gftp which is supposedly a
passive version of ftp and wasn't giving me any errors?
command line: cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2
then used ls to ensure the files that I needed were there

<br>

I then downloaded both files using the get command. Then I said bye to exit.

<br>

Then to download the files to my working directory on the cluster I used
sftp in two steps to navigate into the correct remote folder so
command line: sftp> cd BIOCOMPUTING
              sftp> cd assignments/assignment_2/data
<br>

Since the files were now downloaded to my computer I uploaded them directly
using 
command line: sftp> put /Users/vera/[FileName]
               sftp> put /Users/vera/[FileName] 

<br>

I then checked to see if the files had actually transferred using ls and
they were there.

<br>
<br>
<br>


For Task 3, I set the file permissions so that the files that I had
downloaded were world-readable so the instructor could access them.
Initially they had been set so that only I had access to them so I used 
sftp> chmod 644 *gz to extend the file permissions so anyone who wants
to access the files can do so. I had to do a google search to figure out
notation and read that permissions are represented in three groups (owner|
group | and others with the first digit being owner permissions, second digit being group permissions, and so on. Each digit is a sum of 4=read, 2=write
and 1=execute. Thus the usage of 644. I then really quickly did ls -l to
check permissions was able to confirm that the files are now accessible by
everyone (they can read).

<br>
<br>
<br>

For Task 4,
<br>
On Local Machine:
<br>
MD5 hash for fna file: e1b894042b53655594a1623a7e0bb63f
<br>
MD5 hash for gff file: 494dc5999874e584134da5818ffac925
<br>
On the HPC:
<br>
MD5 hash for fna file: e1b894042b53655594a1623a7e0bb63f
<br>
MD5 hash for gff file: 494dc5999874e584134da5818ffac925
<br>
<br>
Am visually confirming that these hashes match so fortunately no corruption
of data here.
<br>
<br>
<br>
<br>
<br>
For Task 5,
<br>
Alias u just essentially clears your terminal screen and goes one level up
from your current working directory. Alias d just essentially goes one level 
further down from your current working directory and prints the path. Alias
ll is not working for some reason and is printing out incomprehensible info;
will have to go back and investigate this.
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
**Code to get workspace started (ALL ON HPC)**

~/BIOCOMPUTING ]$mkdir -p ~/BIOCOMPUTING/assignments/assignment_2/data

~/BIOCOMPUTING ]$touch ~/BIOCOMPUTING/assignments/assignment_2/README.md

 ~/BIOCOMPUTING ]$git add assignments assignment_2/data assignments/assignment_2/README.md
fatal: not a git repository (or any parent up to mount point /sciclone)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).

~/BIOCOMPUTING ]$ cd ~
~ ]$mv ~/BIOCOMPUTING ~/BIOCOMPUTING_backup_$(date +%Y%m%d_%H%M%S) 2>/dev/null || true

$git clone https://github.com/verapande/BIOCOMPUTING.git ~/BIOCOMPUTING
Cloning into '/sciclone/home/vpande/BIOCOMPUTING'...
remote: Enumerating objects: 63, done.
remote: Counting objects: 100% (63/63), done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 63 (delta 22), reused 45 (delta 12), pack-reused 0 (from 0)
Receiving objects: 100% (63/63), 11.50 KiB | 3.83 MiB/s, done.
Resolving deltas: 100% (22/22), done.

 cd ~/BIOCOMPUTING
~/BIOCOMPUTING ]$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean

~/BIOCOMPUTING ]$ git remote -v
origin	https://github.com/verapande/BIOCOMPUTING.git (fetch)
origin	https://github.com/verapande/BIOCOMPUTING.git (push)

~/BIOCOMPUTING ]$ mkdir -p assignments/assignment_2/data

 ~/BIOCOMPUTING ]$ touch assignments/assignment_2/README.md

 ~/BIOCOMPUTING ]$ git add assignments/assignment_2

~/BIOCOMPUTING ]$ git commit -m "Add assignment_2 with data folder and README file"
[main 49514d5] Add assignment_2 with data folder and README file
 Committer: Vera Pande--vpande@wm.edu--vpande---Geoffrey Zahn [gzahn@wm.edu] <vpande@bora.sciclone.wm.edu>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly. Run the
following command and follow the instructions in your editor to edit
your configuration file:

    git config --global --edit

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 assignments/assignment_2/README.md
[21 vpande@bora ~/BIOCOMPUTING ]$ git push origin main
<br>
<br>
<br>
<br>
<br>
**Rest of Code Used (Everything was HPC except for aliases and md5 hashes which were done on local)**

git clone https://github.com/verapande/BIOCOMPUTING.git BIOCOMPUTING_new



gftp -p ftp.ncbi.nlm.nih.gov
Name (ftp.ncbi.nlm.nih.gov:vera): anonymous
331 Anonymous login ok, send your complete email address as your password
Password: 
230 Anonymous access granted, restrictions apply


get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz

bye





sftp vpande@bora.sciclone.wm.edu
 
cd BIOCOMPUTING
 
cd assignments/assignment_2/data

cd /sciclone/home/vpande/BIOCOMPUTING/assignments/assignment_2/data/

pwd

put /Users/vera/GCF_000005845.2_ASM584v2_genomic.fna.gz
put /Users/vera/GCF_000005845.2_ASM584v2_genomic.gff.gz




chmod 644 *.gz





cd ~/BIOCOMPUTING/assignments/assignment_2/
ls
git add README.md
git commit -m "Add README for assignment 2"
git push origin main
nano README.md
git add README.md
git commit -m "Add README for assignment 2"
git push origin main




md5 GCF_000005845.2_ASM584v2_genomic.fna.gz
md5 GCF_000005845.2_ASM584v2_genomic.gff.gz
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum data/GCF_000005845.2_ASM584v2_genomic.gff.gz




nano ~/.bashrc
source ~/.bashrc
u
d 
clear
ll






nano README.md
git add README.md
git commit -m "Add README for assignment 2"
git push origin main
nano README.md
git add README.md
git commit -m "Add README for assignment 2"
git push origin main
nano README.md
git add README.md
git commit -m “Cleaning up README file”
git push origin main
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
**REFLECTION**
This assignment was definitely a little challenging, and I know it will take some practice to get more comfortable with these commands. Some commands did not work on my MacBook, so I had to do extra research to figure out the correct alternatives, which slowed me down. I also struggled for a long time to properly clone my Git repository on the HPC, but after troubleshooting and using online resources I was finally able to get it working. For now, I kept the underscore2  notation in my folder names, but I plan to go back later and clean up the extra assignment_02 folder. Overall, most things worked once I figured them out, though I found myself  repeating steps a lot before realizing what I was doing wrong.

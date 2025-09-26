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

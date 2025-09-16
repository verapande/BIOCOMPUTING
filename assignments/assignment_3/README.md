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
Was getting so close to having everything pushed to the repository but then the system continuously was rejecting the genomic fasta sequence file because apparently it was a large file. Had to do a quick google search to figure out how to troubleshoot this and figured that I needed to undo my last commit (all command lines not shown here) but keep all of the changes staged, then I needed to set up Git Large File Storage (a helpful extension for processing large data files), then tell git lfs to manage any file ending in .fna (because the file that I was specifically working with is a fna file), and then re-add everything, save changes, and upload. I wrote the following command lines:
<br>
remote: error: File assignments/assignment_3/data/GCF_000001735.4_TAIR10.1_genomic.fna is 114.13 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/verapande/BIOCOMPUTING.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/verapande/BIOCOMPUTING.git'
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
Then wrote nano.README.md to start documenting here.

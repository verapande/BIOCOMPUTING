For Task 2 to download files from NCBI via command-line FTP, I first
installed inetutils via homebrew to provide the ftp client for Mac because
I am on a Mac.
command line: brew install inetutils 

Then I connected to the NCBI FTP server and navigated to the
correct directory. For some reason I had to use gftp which is supposedly a
passive version of ftp and wasn't giving me any errors?
command line: cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2
then used ls to ensure the files that I needed were there

I then downloaded both files using the get command
Then I said bye to exit.


Then to download the files to my working directory on the cluster I used
sftp in two steps to navigate into the correct remote folder so
command line: sftp> cd BIOCOMPUTING
              sftp> cd assignments/assignment_2/data
Since the files were now downloaded to my computer I uploaded them directly
using 
command line: sftp> put /Users/vera/[FileName]
               sftp> put /Users/vera/[FileName] 
I then checked to see if the files had actually transferred using ls and
they were there.




For Task 3, I set the file permissions so that the files that I had
downloaded were world-readable so the instructor could access them.
Initially they had been set so that only I had access to them so I used 
sftp> chmod 644 *gz to extend the file permissions so anyone who wants
to access the files can do so. I had to do a google search to figure out
notation and read that permissions are represented in three groups (owner|
group | and others with the first digit being owner permissions, second digit being group permissions, and so on. Each digit is a sum of 4=read, 2=write
and 1=execute. Thus the usage of 644. I then really quickly did ls -l to
check permissions was able to confirm that the files are now accessibly by
everyone (they can read).

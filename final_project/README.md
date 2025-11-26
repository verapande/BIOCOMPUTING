**Final Project- Metagenomic Assembly/Pipeline**
<br>
**Vera Pande**
<br>
**11/25/2025**
<br>
<br>
For this project we were basically looking at gut microbiome metagenomes from Parkinson's disease
patients and healthy controls from stool sampling from the publicly available dataset:
**NCBI BioProject: PRJEB17784**  
https://www.ncbi.nlm.nih.gov/bioproject/PRJEB17784
<br>
<br>
For each sample, reads were trimmed, assembled, annotated, mapped to contigs, and quantified to determine
gene level coverage? I've included the final '*.tsv' files in this repo for clarity.
<br>
<br>
## Sample Groups
### **Parkinson's samples**
ERR1912976<br>
ERR1913073<br>
ERR1913059<br>
ERR1912964<br>
ERR1913119<br>
<br>
<br>
### **Control samples**
ERR1913016<br>
ERR1913108<br>
ERR1913060<br>
ERR1913044<br>
ERR1913110<br>
<br>
<br>
For what I changed, in the annotation script, I used prokka with a more strict cutoff (--evalue 1e-11')
restricting my annotations to higher-confidence hits, I forced min read length of 75 bp during trimming ensuring higher quality alignments at the cost of discarding shorter reads. 
I then played around with mapping strictness and applied bowtie mapping with very sensitive
and and score min L,0,-0.6.

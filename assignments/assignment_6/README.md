# **ASSIGNMENT 6**
<br>
The purpose of this assignment was to assemble Oxford Nanopore (ONT) phage reads using the program
Flye. We had to use three different environments—Conda, an HPC module, and a
local manual build. My goal for this assignment is not just to make something run once but to structure everything so that I
(or anyone else) can delete the outputs and recreate them cleanly with a single command later on.
<br>
<br>
To begin, I connected to the W&M VPN (GlobalProtect → portal gp.wm.edu), SSH’d to the bora
cluster, and moved into the project directory structure for this assignment with the following command lines:
<br>
	ssh vpande@bora.sciclone.wm.edu
	cd ~/BIOCOMPUTING/assignments/assignment_6
<br>
The folder structure:
<br>
assignment_6/<br>
    data/<br>                 # raw ONT reads (local only; not in Git)
    scripts/<br>
        01_download_data.sh<br>           # downloads reads to ./data
        02_flye_2.9.6_conda_install.sh<br> # creates env + exports flye-env.yml
        flye_2.9.6_manual_build.sh<br>     # builds Flye locally
        03_run_flye_conda.sh<br>           # runs Flye via Conda
        03_run_flye_module.sh<br>          # runs Flye via HPC module
        03_run_flye_local.sh<br>           # runs Flye via local manual build
    assemblies/<br>
        assembly_conda/<br>   # conda_assembly.fasta + conda_flye.log
        assembly_module/<br>  # module_assembly.fasta + module_flye.log
        assembly_local/<br>   # local_assembly.fasta + local_flye.log
    pipeline.sh<br>            # orchestrates everything
    flye-env.yml<br>           # exported environment (auto-created)
<br>
<br>
<br>
<br>
To run the assignment, from inside assignment_6/ I would run:
<br>
	bash pipeline.sh
<br>
The pipeline script would download the ONT reads, build a local Flye copy, create and
document a Conda environment (flye-env + flye-env.yml), run Flye three times in the three different environments
(Conda, module, local) using --nano-hq mode, 6 threads, and a genome size of
~170 kb (datapoint that I searched up). It prints the last ten lines of each Flye log to the terminal.
<br>
To test the reproducibility of this assignment, I removed all of the files like it said we had to do and then run the pipeline script:
<br>
	rm -rf assemblies data flye-env.yml
	bash pipeline.sh
<br>
<br>
STEP-BY-STEP SUMMARY
<br>
Task 1 — Directory setup
	mkdir -p assignment_6/{data,scripts,assemblies/{assembly_conda,assembly_local,assembly_module}}
	cd assignment_6
<br>
Task 2 — Download ONT data
	bash scripts/01_download_data.sh
Result: data/SRR12012232_1.fastq.gz
<br>
Task 3 — Manual Flye build
	bash scripts/flye_2.9.6_manual_build.sh
Binary path: $HOME/BIOCOMPUTING/programs/Flye/bin
<br>
Task 4 — Conda environment
	bash scripts/02_flye_2.9.6_conda_install.sh
Result: flye-env exists; flye-env.yml documents dependencies
<br>
Task 5 — Flye command
    Used --nano-hq for high-quality ONT, --threads 6, --genome-size 170k.
<br>
Task 6 — Run Flye three different ways in the different environments
    Conda:  bash scripts/03_run_flye_conda.sh
    Module: bash scripts/03_run_flye_module.sh
    Local:  bash scripts/03_run_flye_local.sh
<br>
<br>
EXPECTED OUTPUTS
<br>
Each environment is supposed to produce:
    assemblies/assembly_conda/conda_assembly.fasta and conda_flye.log
    assemblies/assembly_module/module_assembly.fasta and module_flye.log
    assemblies/assembly_local/local_assembly.fasta and local_flye.log
<br>
<br>
Errors that I came across and had to fix:
<br>
- Fixed data path from ./data to data/*.fastq*
- Switched from --nano-raw to --nano-hq for better assemblies
- Added conda channels: -c bioconda -c conda-forge
- Set CONDA_PKGS_DIRS and CONDA_ENVS_PATH to $HOME
- Noted module name is case-sensitive (Flye/gcc-11.4.1/2.9.6)
- Scripts are tolerant to missing outputs (logs instead of crash)
- Real runtime much longer than expected (several minutes per run)
<br>
<br>
REFLECTION
<br>
Challenges:
Before I really got into the depth of this assignment, I was relying on AI/LLM for assistance too much and I guess one of the things it told me somehow led me to wiping my entire repository on GitHub just to push a single file. I need to not rely on AI so much.
It took a long long time but I finally was able to rebuild it and learned to commit more often than not and really take with a grain of salt what AI is telling me to do and to have it help and be a guidance on the side but not to completely dictate how I approach assignments.
<br>
Key lessons:
Flags like --nano-hq
matter for ONT data.
<br>
Thoughts on each method:
I thought module was the easiest method to use; if it is already available that is great if not you might have to work around and ask for one to be established but not that bad.
<br>
<br>
REPRODUCIBILITY CHECK FOR SOMEONE IF THEY WANTED TO GO IN AND RUN MY PIPELINE ON THEIR OWN
<br>
Someone could SSH into bora, go to this folder, delete any outputs, and rerun with the following command lines:
<br>
	cd ~/BIOCOMPUTING/assignments/assignment_6
	rm -rf assemblies data flye-env.yml
	bash pipeline.sh
<br>
Each assembly directory will have exactly two files: the FASTA and its log.
<br>
<br>
NOTES ON GIT AND CLEANING
<br>
The repo excludes raw data and large files. It tracks scripts, environment
files, and documentation only.
<br>

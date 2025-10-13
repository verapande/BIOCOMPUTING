
This assignment assembled Oxford Nanopore (ONT) phage reads with a program called **Flye**. We had to use three different environments—**Conda**, an **HPC module**, and a **local manual build**—to practice paths, environments, and reproducibility. My goal was not just to “make it run once,” but to structure everything so I (or anyone else) can delete the outputs and recreate them cleanly with a single command later on.

---

## Where to start and what’s here

I connected to the W&M VPN (GlobalProtect → portal `gp.wm.edu`), SSH’d to the bora cluster, and moved into this project:

```bash
ssh vpande@bora.sciclone.wm.edu
cd ~/BIOCOMPUTING/assignments/assignment_6
I created a folder that contains a data/ directory for raw reads (not pushed to Git), a scripts/ directory with all the code, an assemblies/ directory for the results from each environment, the exported Conda environment file flye-env.yml, and a single pipeline.sh that runs the entire workflow end-to-end and prints log summaries.

text
Copy code
assignment_6/
├── data/                         # raw ONT reads (local only; not in Git)
├── scripts/
│   ├── 01_download_data.sh                 # downloads reads to ./data
│   ├── 02_flye_2.9.6_conda_install.sh      # creates env + exports flye-env.yml
│   ├── flye_2.9.6_manual_build.sh          # builds Flye into ~/BIOCOMPUTING/programs/Flye
│   ├── 03_run_flye_conda.sh                # runs Flye via Conda env (6 threads)
│   ├── 03_run_flye_module.sh               # runs Flye via module (Flye/gcc-11.4.1/2.9.6)
│   └── 03_run_flye_local.sh                # runs Flye via local manual build
├── assemblies/
│   ├── assembly_conda/           # keeps conda_assembly.fasta + conda_flye.log
│   ├── assembly_module/          # keeps module_assembly.fasta + module_flye.log
│   └── assembly_local/           # keeps local_assembly.fasta + local_flye.log
├── pipeline.sh                   # orchestrates everything and tails logs
└── flye-env.yml                  # exported environment (auto-created)
How to run this assignment (one command)
From inside assignment_6/ I run:

bash
Copy code
bash pipeline.sh
The pipeline downloads the ONT reads into ./data, builds a local Flye copy in ~/BIOCOMPUTING/programs/Flye, creates and documents a Conda environment (flye-env + flye-env.yml), runs Flye three times (Conda, module, local) using high-quality ONT mode (--nano-hq), 6 threads, and an expected coliphage genome size of ~170 kb, and finally prints the last ten lines of each Flye log to my terminal. Each run cleans its output directory so only the assembly FASTA and the log remain.

If I want to prove reproducibility, I delete everything except scripts/ and re-run:

bash
Copy code
rm -rf assemblies data flye-env.yml
bash pipeline.sh
What I actually did, step by step (with file locations)
Task 1 — Set up the assignment_6/ directory
I created the structure once on the cluster:

bash
Copy code
cd ~/BIOCOMPUTING/assignments
mkdir -p assignment_6/{data,scripts,assemblies/{assembly_conda,assembly_local,assembly_module}}
cd assignment_6
I also version-controlled the structure:

bash
Copy code
git add assignment_6
git commit -m "Add Assignment_6 directory structure"
Task 2 — Download the raw ONT data
I wrote scripts/01_download_data.sh so the project can fetch reads for itself. It simply creates data/, changes into it, and downloads the read file. The file ends up in assignment_6/data/. Since my run scripts accept data/*.fastq*, I don’t need to rename it.

bash
Copy code
bash scripts/01_download_data.sh
# Result: data/SRR12012232_1.fastq.gz
Task 3 — Get Flye v2.9.6 via a local manual build
I wrote scripts/flye_2.9.6_manual_build.sh to clone the Flye repo, check out tag 2.9.6, and run make. It installs into ~/BIOCOMPUTING/programs/Flye. My local run script adds both common bin locations to PATH so the binary is found.

bash
Copy code
bash scripts/flye_2.9.6_manual_build.sh
# Binary lives at: $HOME/BIOCOMPUTING/programs/Flye/bin
Task 4 — Get Flye v2.9.6 via Conda (with correct channels and home-based caches)
I learned that Flye packages are on bioconda, not just conda-forge, and that on shared HPCs I should store envs and caches in my home. My installer script sets:

bash
Copy code
CONDA_PKGS_DIRS=$HOME/.conda/pkgs
CONDA_ENVS_PATH=$HOME/.conda/envs
Then it loads Miniforge, sources conda, and creates flye-env with -c bioconda -c conda-forge, falling back to Flye 2.9.5 if 2.9.6 isn’t available. It activates the env, prints flye -v, exports flye-env.yml, and deactivates.

bash
Copy code
bash scripts/02_flye_2.9.6_conda_install.sh
# Result: flye-env exists; flye-env.yml documents exact deps
Task 5 — Design the Flye command (why these flags)
For modern ONT data, I used --nano-hq rather than --nano-raw because the basecalling quality is high and Flye tunes parameters accordingly; this I learned from an internet search. I used --threads 6 to be respectful on the login node, and --genome-size 170k because coliphage genomes are on that order. I allowed for multiple phage types by letting Flye assemble what’s present and then inspecting contigs via the log and the final FASTA. All three run scripts call the exact same Flye command, only the environment differs.

Task 6 — Run Flye three ways and keep only the essentials
Conda environment: scripts/03_run_flye_conda.sh activates flye-env and runs Flye on data/*.fastq*, writing to assemblies/assembly_conda/. It cleans that directory so only conda_assembly.fasta and conda_flye.log remain.

HPC module: scripts/03_run_flye_module.sh loads the case-sensitive module Flye/gcc-11.4.1/2.9.6 and runs Flye the same way, keeping module_assembly.fasta and module_flye.log.

Local build: scripts/03_run_flye_local.sh prepends $HOME/BIOCOMPUTING/programs/Flye/bin (and also $HOME/programs/Flye/bin) to PATH and runs Flye, keeping local_assembly.fasta and local_flye.log.

Because the run can fail earlier (e.g., missing data), my move/cleanup lines are tolerant; if assembly.fasta wasn’t generated, the scripts won’t crash—they tell me to read the .log instead.

What the pipeline will produce
After a successful run, I expect exactly two files per method:

assemblies/assembly_conda/conda_assembly.fasta and conda_flye.log

assemblies/assembly_module/module_assembly.fasta and module_flye.log

assemblies/assembly_local/local_assembly.fasta and local_flye.log

All other intermediate Flye files are removed to keep the repository tidy.

What I learned while debugging
Data paths first. I had to fix ./data to data/*.fastq* so an exact filename isn’t required.

Use --nano-hq for modern ONT. Switching from --nano-raw resolved runs that produced no assembly.

Conda channels + private caches. Flye is on bioconda; I added -c bioconda -c conda-forge and set CONDA_PKGS_DIRS and CONDA_ENVS_PATH to $HOME to avoid lockfile errors.

Module names are case-sensitive. On bora the module is Flye/gcc-11.4.1/2.9.6.

Be tolerant to missing outputs. If assembly.fasta is absent, scripts don’t crash; they point me to the log.

Runtime reality. First-time conda solves, downloads, make, and shared filesystem load made my runs take longer than “~1 min.” Reruns are faster once the env and build exist.

Reflection
Challenges. I got so overwhelmed and scared while troubleshooting across the three environments. At one point I wiped my repository to almost nothing and had to rebuild it just so to push a single README.md file. I had no idea what was going on; I literally cried. I even created a second branch and then removed it to keep working on main.

New things I learned. Reproducibility is about simple, consistent structure. If raw data lives in data/, scripts do all transformations, outputs are disposable, and the README explains everything, then I can delete and rebuild with confidence. I also learned that Conda’s behavior depends entirely on channel choice and where it stores environments, and that ONT input flags (--nano-hq vs --nano-raw) matter.

Thoughts on the three methods. I prefer Conda once channels are correct and the environment is exported to flye-env.yml. The module path is the most convenient only when the exact module name exists; the case sensitivity and compiler path can be tricky. The local build is a reliable fallback anywhere, but it requires me to manage $PATH intentionally.

What I’ll do first next time. I will start with the Conda route because it’s portable and easy to document, then try the module if present, and finally use a local build if I need a fixed version or if I’m on a system without modules. I’ll also commit earlier and more often, and I’ll test the pipeline from a clean slate before I push.

Reproducibility check (what a grader can do quickly)
A grader can SSH into bora, enter this folder, delete outputs and the env file, and run the pipeline:

bash
Copy code
cd ~/BIOCOMPUTING/assignments/assignment_6
rm -rf assemblies data flye-env.yml
bash pipeline.sh
Each method’s directory will contain exactly two files (the assembly FASTA and the log), and the last ten log lines will be printed to the terminal for quick inspection.

Notes on Git cleaning and organizing
I intentionally do not push data or large bio files. The repository tracks scripts, the exported environment file, and documentation. When I need to update structure or scripts, I use clear messages such as:

bash
Copy code
git add .
git commit -m "A6: add conda/local/module run scripts and pipeline; export flye-env.yml"
git push

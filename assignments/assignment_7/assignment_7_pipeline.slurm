#!/bin/bash
#SBATCH --job-name=Assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=0-15:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=vpande@wm.edu
#SBATCH -o /sciclone/home/vpande/BIOCOMPUTING/assignments/assignment_7/output/JOBNAME_%j.out
#SBATCH -e /sciclone/home/vpande/BIOCOMPUTING/assignments/assignment_7/output/JOBNAME_%j.err

set -euo pipefail

# project directory
root=/sciclone/home/vpande/BIOCOMPUTING/assignments/assignment_7

# ensure log/output dir exists
mkdir -p "$root/output"

# add programs to PATH (explicit versions + generic fallback + slurm bin)
export PATH=$HOME/BIOCOMPUTING/programs/sratoolkit.3.2.1-ubuntu64/bin:$PATH
export PATH=$HOME/BIOCOMPUTING/programs/bbmap:$PATH
export PATH=$HOME/BIOCOMPUTING/programs/datasets:$PATH
export PATH=$HOME/BIOCOMPUTING/programs/samtools-1.20:$PATH
export PATH=$HOME/BIOCOMPUTING/programs:$PATH
export PATH=/usr/local/slurm-23.11.9/bin:$PATH

# run from scripts/ so ../data ../ref ../output resolve correctly
cd "$root/scripts"

# run entire workflow in sequence — no checkpoints
bash ./01_download_data.sh
bash ./02_clean_reads.sh
bash ./02_map_reads.sh
bash ./03_extract_hits.sh

echo "Done."

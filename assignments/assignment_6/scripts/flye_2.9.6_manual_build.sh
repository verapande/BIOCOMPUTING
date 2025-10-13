#!/bin/bash
# Local build of Flye v2.9.6 (no sudo, no global install)
# Builds into: ~/BIOCOMPUTING/programs/Flye

mkdir -p ~/BIOCOMPUTING/programs
cd ~/BIOCOMPUTING/programs

# start fresh so clone never errors
rm -rf Flye

echo "Cloning Flye..."
git clone https://github.com/fenderglass/Flye.git

cd Flye
echo "Checking out v2.9.6..."
git checkout 2.9.6

echo "Compiling..."
make

echo "Done. Binary at: $HOME/BIOCOMPUTING/programs/Flye/bin"

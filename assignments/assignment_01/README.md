*CORRECT VERSION* Here I am documenting the exact Unix commands I used to 
manually construct my mock project folder. Running these line by line should reproduce my 
project structure exactly. Notes and explanations are included inline.

Step 1. Navigate into my course repo : cd ~/Users/vera/BIOCOMPUTING Step 
2. Create the assignment_1 directory mkdir -p assignments/assignment_1 cd 
assignments/assignment_1 Step 3. Create subdirectories for organization 
mkdir -p data/raw mkdir -p data/clean mkdir scripts results docs config 
logs Step 4. Add placeholder files to each subdirectory touch 
data/raw/example.txt touch scripts/script.sh touch results/example.txt 
touch docs/example.txt touch config/example.txt touch logs/logfile.log 
Step 5. Create the required markdown files touch assignment_1_essay.md 
touch README.md

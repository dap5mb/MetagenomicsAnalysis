#!/bin/bash
#SBATCH -N 1                    #number of nodes for the job
#SBATCH --cpus-per-task=20      #number of cpus per task
#SBATCH --mem=60Gb              #total memory per node in GB
#SBATCH -t 12:00:00             #amount of time for the whole job
#SBATCH -p standard             #cluster partition
#SBATCH -e slurm-%j.err         #standard error
#SBATCH --output slurm-%j.out   #standard output
#SBATCH -A csblrivanna
#SBATCH --mail-user=$USER@virginia.edu

# ARGUMENTS
# $1: ../data/sampleName -> list of sample name prefixes
# $2: ..data/03_hostrm -> input file directory
# $3: ../data/08_humann -> output directory

# SUBMIT JOB AS:
# sbatch humann.sh ../data/sampleName ../data/03_hostrm ../data/08_humann

# START
echo "Functional analysis using Humann3"
date +"%d %B %Y %H:%M:%S"

# Load modules
source activate humann3

# Run megahit assembler
cat $1 | while read line
do

  humann --threads 20 \
  -i $2/$line\_host_removed_R1_001.fastq.gz --input-format fastq.gz\
  -o $3/$line\_humann
done

# END
date +"%d %B %Y %H:%M:%S"


# SCRATCH WORK
#Paired ends:
#zcat $2/$line\_host_removed_R1_001.fastq.gz $2/$line\_host_removed_R2_001.fastq.gz > temp_merge.fastq.gz

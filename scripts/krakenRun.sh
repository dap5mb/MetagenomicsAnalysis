#!/bin/bash
#SBATCH -N 1                    #number of nodes for the job
#SBATCH --cpus-per-task=40      #number of cpus per task
#SBATCH --mem=60Gb              #total memory per node in GB
#SBATCH -t 24:00:00             #amount of time for the whole job
#SBATCH -p standard             #cluster partition
#SBATCH -e slurm-%j.err         #standard error
#SBATCH --output slurm-%j.out   #standard output
#SBATCH -A csblrivanna
#SBATCH --mail-user=$USER@virginia.edu

# ARGUMENTS
# $1: ../data/sampleName -> list of sample name prefixes
# $2: ..data/03_hostrm -> input file directory
# $3: ../data/04_kraken -> output directory

# SUBMIT JOB AS:
# sbatch krakenRun.sh ../data/sampleName ../data/03_hostrm ../data/04_kraken


# START
echo "Running Kraken2 to get profile abundances"
date +"%d %B %Y %H:%M:%S"

# Load modules 
module load kraken2

# Run kraken2
cat $1 | while read line
do
kraken2 --db ../kraken_db --threads 40 --use-names --report $3/$line\.kreport --report-zero-counts \
--gzip-compressed --paired \
$2/$line\_host_removed_R1_001.fastq.gz \
$2/$line\_host_removed_R2_001.fastq.gz
done

# Unload modules
module purge

# END
date +"%d %B %Y %H:%M:%S"

#kraken2 --db ../kraken_db --use-names --report test.kreport --gzip-compressed --paired ../data/03_hostrm/DC1110_S149_host_removed_R1_001.fastq.gz ../data/03_hostrm/DC1110_S149_host_removed_R2_001.fastq.gz

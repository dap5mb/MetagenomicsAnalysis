#!/bin/bash
#SBATCH -N 1                    #number of nodes for the job
#SBATCH --cpus-per-task=10      #number of cpus per task
#SBATCH --mem=20Gb              #total memory per node in GB
#SBATCH -t 01:00:00             #amount of time for the whole job
#SBATCH -p standard             #cluster partition
#SBATCH -e slurm-%j.err         #standard error
#SBATCH --output slurm-%j.out   #standard output
#SBATCH -A csblrivanna
#SBATCH --mail-user=$USER@virginia.edu
######################################################################################
#################
######################################
##
## Author: Pankaj Kumar, adapted by Deborah Powers
## Email: pk7z@virginia.edu
## Location: Bioinformatics Core
##
############################################################
## This script runs fastqc files in the data directory and then combines into a multiqc report
## The output will be saved in FASTQC directory
## Arguments:
### $1: input directory
### $2: output multiqc file name
# Sumbit example:
#sbatch fastqc.sh ../data/00_raw multiqc_report_raw.html
######################################################################################
#######################################################

# START
date +"%d %B %Y %H:%M:%S"

# load modules
module load fastqc
module load bioconda/py3.8
module load multiqc

# fastqc
cd $1
mkdir FASTQC
fastqc -t 10 *.fastq* -o FASTQC

# combine fastqc reports with multiqc
multiqc FASTQC

# Copy report to home directory for easy viewing
cp multiqc_report.html /home/dap5mb/Papin_lab/alzheimers/metagenomics/results/$2

# unload modules
module purge

# END
date +"%d %B %Y %H:%M:%S"

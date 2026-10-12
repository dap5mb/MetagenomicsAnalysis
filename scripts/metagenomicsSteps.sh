# Steps for metagenomics data processing
# Written by Deborah Powers, dap5mb@virginia.edu

## Directory structure:
# Project_folder
#   data
#     00_raw
#     01_trimmed
#     02_duprm
#     03_hostrm
#     04_kraken
#     05_humann
#   scripts
#     metagenomicsSteps.sh
#     fastqc.sh
#     cutadapt.sh
#     remove_duplicate_sequence_fastq.inhouse-script.sh
#     host_rm.sh
#     krakenRun.sh
#     humann.sh

#0. Download raw fastq files
mkdir data/00_raw
cd data/00_raw
./download_file.sh # wget command for each file to retrieve from BOX (could def be more effecient...)
# Example wget command:
# wget -O DC1110_S149_R1_001.fastq https://microbialgenomesequencingcente.box.com/shared/static/dfp8h54bwvsgon27rg4mo3iv7mo2h33t
# Need to edit base hyperlink from BOX so that /s/ changes to /shared/static/
# Make sample name list
ls *_1.fastq.gz | sed -e s/_1.fastq.gz//g > sampleName

#1. FastQC ~ 5-10 minutes
cd ../../scripts
sbatch fastqc.sh ../data/00_raw multiqc_report_raw.html
# Just to get a general sense of your baseline

#2. Trim adapters
# Can skip if preliminary fastqc report doesn't show any adaptor contamination?
# Need adaptor sequences (reads 1 and read 2)
mkdir ../data/01_trimmed
sbatch cutadapt.sh ../data/sampleName Adaptor-R1.txt Adaptor-R2.txt ../data/01_trimmed ../data/00_raw
sbatch fastqc.sh ../data/01_trimmed multiqc_report_adrm.html

#3. Remove duplicate reads <2h
mkdir ../data/02_duprm
sbatch remove_duplicate_sequence_fastq.inhouse-script.sh ../data/sampleName ../data/01_trimmed ../data/02_duprm
# Check if duplicate reads removed
sbatch fastqc.sh ../data/02_duprm multiqc_report_duprm.html

#4. Remove host contamination
mkdir ../data/03_hostrm
# Need to get host reference genome (put in 03_hostrm folder)
sbatch host_rm.sh ../data/sampleName ../data/02_duprm ../data/03_hostrm
sbatch fastqc.sh ../data/03_hostrm multiqc_report_hostrm.html
# This is the final clean up step; fastqc report should be looking good
# Also, at this point, no need to hang onto data folders 01_trimmed or 02_duprm.
# These folders are purely intermediary cleaning steps.
# Only need to keep raw and the final, processed host rm folder.

#5. Taxonomic analysis (Kraken2)
# I have scripts for metaphlan, but wasn't ever able to get it to really work
mkdir ../data/04_kraken
sbatch krakenRun.sh ../data/sampleName ../data/03_hostrm ../data/04_kraken

#6. Functional analysis (Humann3)
# Install Humann3 according to github instructions
# Think I ended up installing via a conda environment on Rivanna
mkdir ../data/05_humann
sbatch humann.sh ../data/sampleName ../data/03_hostrm ../data/05_humann


# SCRATCH WORK
# Have scripts for metaphlan, prodigal, metabat, and megahit.
# All of these scripts need some work...abandoned for a variety of reasons:
## package installation problems, poor documentation, found faster alternatives, etc.
#date +"%d %B %Y %H:%M:%S"

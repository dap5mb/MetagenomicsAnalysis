#!/bin/bash
#SBATCH -N 1                    #number of nodes for the job
#SBATCH --cpus-per-task=40      #number of cpus per task
#SBATCH --mem=50Gb              #total memory per node in GB
#SBATCH -t 06:00:00             #amount of time for the whole job
#SBATCH -p standard             #cluster partition
#SBATCH -e slurm-%j.err         #standard error
#SBATCH --output slurm-%j.out   #standard output
#SBATCH -A csblrivanna
#SBATCH --mail-user=$USER@virginia.edu

# $1: sampleName -> list of sample name prefixes
# $2: ..data/02_duprm -> input file directory
# $3: ../data/03_hostrm --> set as working directory, output directory

# Submit job as:
# sbatch host_rm.sh ../data/sampleName ../data/02_duprm ../data/03_hostrm

# START
echo "Remove host contamination"
date +"%d %B %Y %H:%M:%S"

# Load modules
module load gcc/9.2.0
module load bowtie2/2.2.9
module load samtools

cat $1 | while read line
do

  # bowtie2 mapping against human genome GRCh38 sequence database, keeps both aligned and unaligned reads
  bowtie2 -p 40 -x $3/GRCh38_noalt_as/GRCh38_noalt_as \
  -1 $2/$line\_duprm_ADRM_L001_R1_001.fastq \
  -2 $2/$line\_duprm_ADRM_L001_R2_001.fastq \
  -S $3/$line\_mapped_and_unmapped.sam

  # Convert .sam to .bam
  samtools view -bS $3/$line\_mapped_and_unmapped.sam > $3/$line\_mapped_and_unmapped.bam

  # Filter to get unmapped pairs (both reads (R1 and R2) unmapped)
  samtools view -b -f 12 -F 256 \
  $3/$line\_mapped_and_unmapped.bam > $3/$line\_bothReadsUnmapped.bam

  # Split paired-end reads back into separate files
  samtools sort -n -m 5G -@ 40 $3/$line\_bothReadsUnmapped.bam -o $3/$line\_bothReadsUnmapped_sorted.bam
  samtools fastq -@ 40 $3/$line\_bothReadsUnmapped_sorted.bam \
  -1 $3/$line\_host_removed_R1_001.fastq.gz \
  -2 $3/$line\_host_removed_R2_001.fastq.gz \
  -0 /dev/null -s /dev/null -n

done

# END
date +"%d %B %Y %H:%M:%S"

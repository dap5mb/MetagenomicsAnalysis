#This script removes the duplicate reads if they are 100% identical from pair-end sequencing files.

# $1: file list (sampleName)
# $2: input directory
# $3: output directory

#If you have paired end files EK3739F03_S22-ADRM_L001_R1_001.fastq and EK3739F03_S22-ADRM_L001_R2_001.fastq then sample name would be "EK3739F03_S22". Concatenate all the sample name in a file and provide the same file as argument 1.

#Use this script after removing the adaptor sequence (if any)



cat $1 | while read line
        do
cat $2/$line\-ADRM_L001_R1_001.fastq       | paste - - - - > Temp1
cat $2/$line\-ADRM_L001_R2_001.fastq       | paste - - - - > Temp2

paste Temp1 Temp2 | awk '{printf ("%s\t%s%s\n",$0,$3,$8)}' > Temp3

#Using 60 cores for sorting file

sort --parallel=60 -dk11  Temp3 > Temp4

awk '!x[$11]++ {printf ("%s %s\n%s\n%s\n%s\n",$1,$2,$3,$4,$5)}' Temp4 > $3/$line\_duprm_ADRM_L001_R1_001.fastq
awk '!x[$11]++ {printf ("%s %s\n%s\n%s\n%s\n",$6,$7,$8,$9,$10)}' Temp4 > $3/$line\_duprm_ADRM_L001_R2_001.fastq
done

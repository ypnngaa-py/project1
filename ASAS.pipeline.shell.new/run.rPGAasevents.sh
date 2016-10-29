#!/bin/bash 
#$ -N rPGAasevents
#$ -S /bin/bash                   
#$ -R y                                   
#$ -l h_data=10G,h_rt=24:00:00,highp
#$ -V       
#$ -cwd                                                                       
#$ -j y                                                                       
#$ -m bea                                                  
#$ -M panyang@ucla.edu       

mkdir -p temp
ASEvents=$1
mkdir $ASEvents
/u/home/p/panyang/local/bin/python2.7 /u/home/s/sstein93/Software/rMATS.3.2.1.beta/bin/processGTF.SAMs.py \
/u/nobackup/yxing/NOBACKUP/xinglab/data/GTF/Homo_sapiens.Ensembl.GRCh37.75.gtf \
${ASEvents}/fromGTF \
ENCSR000AED/rep1/hap1.sorted.bam,ENCSR000AED/rep1/hap2.sorted.bam \
fr-unstranded \
temp

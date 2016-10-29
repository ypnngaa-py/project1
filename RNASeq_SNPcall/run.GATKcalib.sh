#!/bin/bash 
#$ -N GATKcalib
#$ -S /bin/bash
#$ -hold_jid step3_star
#$ -R y
#$ -pe shared 4 
#$ -l h_data=10G,highp,h_rt=24:00:00
#$ -V 
#$ -cwd
#$ -j y
#$ -m be
#$ -M panyang@ucla.edu


genomeFasta=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/ucsc.hg19.fasta
dbsnp=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/dbsnp_138.hg19.vcf
InputSam=$1
python rMATS-DVR/bam_calibration.py --bam $InputSam --output GM12787 --genome $genomeFasta --known $dbsnp


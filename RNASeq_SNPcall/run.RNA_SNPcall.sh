#!/bin/bash 
#$ -N GATKcall
#$ -S /bin/bash
#$ -R y
#$ -pe shared 8 
#$ -l h_data=5G,highp,h_rt=24:00:00
#$ -V 
#$ -cwd
#$ -j y
#$ -m be
#$ -M panyang@ucla.edu
#
#genomeDir=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/

genomeFasta=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/ucsc.hg19.fasta
dbsnp=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/dbsnp_138.hg19.vcf
InputSam=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/ENCSR000AED_2_Aligned.out.sam
python rMATS-DVR/bam_calibration.py --bam $InputSam --output GM12787 --genome $genomeFasta --known $dbsnp


#!/bin/bash 
#$ -N rPGApersonalize
#$ -S /bin/bash
#$ -R y
#$ -l h_data=40G,h_rt=24:00:00
#$ -V 
#$ -cwd
#$ -j y
#$ -m be
#$ -M panyang@ucla.edu

PersonalGenome=$1
mkdir $PersonalGenome
#PersonalGenome = /u/home/p/panyang/nobackup-yxing/personal_genome/ 
VCF=$2
#VCF = /u/home/p/panyang/nobackup-yxing/ENCSR000AED_VCF
rPGA personalize -o $PersonalGenome -v $VCF -r /u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/ucsc.hg19.fasta --rnaedit -e /u/nobackup/yxing/NOBACKUP/sstein93/radar/Human_AG_all_hg19_v2.txt --gz

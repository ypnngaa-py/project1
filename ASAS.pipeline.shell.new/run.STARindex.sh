#!/bin/bash 
#$ -N STARindex
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
STAR=/u/home/p/panyang/bin/STAR-STAR_2.4.2a/source/STAR
#genomeDir=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/
genomeDir=$1
mkdir $genomeDir
#genomeFasta=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/ucsc.hg19.fasta
genomeFasta=$2
${STAR} --runMode genomeGenerate --genomeDir $genomeDir --genomeFastaFiles $genomeFasta  --runThreadN 8


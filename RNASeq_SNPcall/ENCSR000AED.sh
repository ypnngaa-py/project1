#!/bin/bash 
#$ -N ENCSR000AED
#$ -S /bin/bash
#$ -R y
#$ -l h_data=10G,highp,h_rt=24:00:00
#$ -V 
#$ -cwd
#$ -j y
#$ -m be
#$ -M panyang@ucla.edu
#

mkdir -p ENCSR000AED
cd ENCSR000AED
wget https://www.encodeproject.org/files/ENCFF001REK/@@download/ENCFF001REK.fastq.gz
wget https://www.encodeproject.org/files/ENCFF001REJ/@@download/ENCFF001REJ.fastq.gz
mkdir -p rep1 

wget https://www.encodeproject.org/files/ENCFF001REK/@@download/ENCFF001REK.fastq.gz
wget https://www.encodeproject.org/files/ENCFF001REJ/@@download/ENCFF001REJ.fastq.gz
mkdir -p rep2 

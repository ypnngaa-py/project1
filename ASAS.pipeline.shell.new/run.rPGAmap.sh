#!/bin/bash 
#$ -N rPGAmap
#$ -S /bin/bash                   
#$ -R y                                   
#$ -pe shared 8
#$ -l h_data=6G,h_rt=24:00:00,highp
#$ -V       
#$ -cwd                                                                       
#$ -j y                                                                       
#$ -m bea                                                  
#$ -M panyang@ucla.edu        

# 1 = output directory
# 2 = read_1.fq
# 3 = read_2.fq
# 4 = /u/nobackup/yxing/NOBACKUP/sstein93/gm12878/personal_genome/HAP1/STARindex,/u/nobackup/yxing/NOBACKUP/sstein93/gm12878/personal_genome/HAP2/STARindex
# VCF = /u/nobackup/yxing/NOBACKUP/sstein93/1000GenomesVCF/NA12878
mkdir $1
VCF=$6
# mapping reads
rPGA mapping -o $1 -s $2,$3 -N 6 --hap -g /u/nobackup/yxing/NOBACKUP/xinglab/data/GTF/Homo_sapiens.Ensembl.GRCh37.75.gtf --gz --readlength 75 --genomedir $4,$5 
rPGA assign -o $1 -v $VCF -e /u/nobackup/yxing/NOBACKUP/sstein93/radar/Human_AG_all_hg19_v2.txt --rnaedit --gz

# rm $2
# rm $3

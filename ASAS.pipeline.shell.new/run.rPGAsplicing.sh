#!/bin/bash 
#$ -N rPGAsplicing
#$ -S /bin/bash                   
#$ -R y                                   
#$ -l h_data=10G,h_rt=24:00:00
#$ -V       
#$ -cwd                                                                       
#$ -j y                                                                       
#$ -m bea                                                  
#$ -M panyang@g.ucla.edu       
# 

ASEvents=$1
samples=$2
## use to run as job array, samples are listed in samples.txt with one sample per line
export s=`sed -n ${SGE_TASK_ID}p ${samples}`

#export s=${1} ## sample ID

rPGA splicing -o ${s} --asdir $ASEvents --readlength 100 --anchorlength 8

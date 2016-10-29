#/bin/bash 
#$ -N rPGAmerge
#$ -S /bin/bash                   
#$ -R y                                   
#$ -l h_data=20G,h_rt=10:00:00
#$ -V       
#$ -cwd                                                                       
#$ -j y                                                                       
#$ -m bea                                                  
#$ -M panyang@g.ucla.edu       

samples=$1
ASASCounts=$2
VCF=$3
mkdir -p $2
rPGA splicing --merge --pos2id --samples $samples -o $ASASCounts -v $VCF 

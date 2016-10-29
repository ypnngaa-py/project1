#/bin/bash 
#$ -N PAIRADISE
#$ -S /bin/bash                   
#$ -R y                                   
#$ -l h_data=5G,h_rt=12:00:00
#$ -V       
#$ -cwd                                                                       
#$ -j y                                                                       
#$ -m bea                                                  
#$ -M panyang@g.ucla.edu       
ASASCount_file=$1
AS_type=$2
/u/home/s/sstein93/R-3.2.2/bin/R CMD BATCH --no-save --no-restore "--args "${ASASCount_file}" "${AS_type}"" PAIRADISE.R

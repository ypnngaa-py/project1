#!/bin/bash
##### check input parameters #####

STAR=/u/home/p/panyang/bin/STAR-STAR_2.4.2a/source/STAR
genome_index=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/star_index/ori_hg19_ref
#gtf=/u/nobackup/yxing/NOBACKUP/xinglab/data/GTF/Homo_sapiens.Ensembl.GRCh37.75.gtf
genome_fasta=/u/home/p/panyang/nobackup-yxing/RNASeq_SNPcall/resource/ucsc.hg19.fasta


function usage()
{
	cat >&2 <<-EOF

USAGE: $0 [ -h ] [ -i <input file list> ] [ -o <output path> ] [ -p <P/S>]
    -h:	this help
    -i:	tab delimitated file. 
    	first column, user defined sample name. Will also serve as prefix for outputed bam file.
    	second column, path for fastq files. Use comma to seperate paired-end fastq files.
    -o:	path for output files.
    -p:	<P/S> P for paired end reads, S for single end reads
	EOF
}

# check for the existence of parameters.
if [[ $# -eq 0 ]]; then
	# echo "$0: parameters are required" >&2
	usage; exit 0
fi

# read the options
opts=$(getopt -o hi:o:p: --long help -n 'parse-options' -- "$@")
[ $? -eq 0 ] || {
	echo "Incorrect options provided" >&2
	usage; exit 1
}
eval set -- "$opts"

while true ; do
	case "$1" in
		-h | --help)
			usage; exit 0 ;;
		-i)
			if [[ (-z $2) || ($2 == '-'*) ]]; then
				echo -e "\nERROR\t$0 $1: parameter not set / parameter cannot start with '-'" >&2
				usage; exit 1
			else
				infile=$2
				read -ra Sample_list <<< $(cat $infile | awk '{print $1}')
				read -ra fastq_list <<< $(cat $infile | awk '{print $2}')
				shift 2
			fi ;;
		-o)
			if [[ (-z $2) || ($2 == '-'*) ]]; then
				echo -e "\nERROR\t$0 $1: parameter not set / parameter cannot start with '-'"
				usage; exit 1
			else
				bam_outPath=$2; shift 2
				if [ ! -d "$bam_outPath" ]; then
					`mkdir $bam_outPath`
				fi
			fi ;;
		-p | --pairInfo)
			if [[ (-z $2) || ($2 == '-'*) ]]; then
				echo -e "\nERROR\t$0 $1: parameter not set / parameter cannot start with '-'"
				usage; exit 1
			elif [[ $2 == 'P' || $2 == 'S' ]]; then
				pairInfo=$2; shift 2
			else
				echo -e "\nERROR\t$0 $1: pairInfo should be set either as 'P' for paired end reads or 'S' for single end reads" >&2
				usage; exit 2
			fi ;; 
		--)
			if [[ ! -z $2 ]]; then
				echo -e "\nERROR\tunused parameters: ${*##*$1}"
			fi
			shift; break ;;
	esac
done

# check the exsistence of all required parameters.
if [[ -z $Sample_list || -z $fastq_list || -z $bam_outPath || -z $pairInfo ]]; then
	echo -e "\nERROR\t$0: need exactly 3 parameters"
	usage; exit 1
fi
# check the length of given Sample_list and fastq_list
length1=${#Sample_list[@]}
length2=${#fastq_list[@]}

if [[ length1 -ne length2 ]]; then
	echo '$0 $1: the length of Sample_list (first column) and the length of fastq_list (second column) in the input file does not match with each other.' >&2
	usage; exit 1
fi


###### 1-round Alignment ######
### check whether the existence of fastq files and its consistence with taskName and pairInfo.
### generate parameter files for first round star alignment
> para_file_round1.txt
for ((i=0;i<$length1;i++)); do
	IFS=', ' read -ra array <<< ${fastq_list[$i]}
	length=${#array[@]}
	if [[ ($pairInfo == 'P' && length -ne 2) || ($pairInfo == 'S' && length -ne 1) ]]; then
		echo -e "\nERROR\t$0: the number of fastq files in the ${i}th line of input file does not match the pairInfo -- pairInfo=$pairInfo; #fastq files=$length" >&2
		usage; exit 2
	else
		for fastq in ${array[@]}; do
			if [[ ! -e $fastq ]]; then
				`rm para_file_round1.txt`
				echo -e "\nERROR\t$0 $1:\tfastq file '$fastq' in the ${i}th line does not exist. Please check the file path again." >&2
				usage; exit 2
			fi
		done
		echo --readFilesCommand zcat --runThreadN 8 --genomeDir ${genome_index} --readFilesIn ${array[@]} --outFileNamePrefix ${bam_outPath}/${Sample_list[$i]}_1_ >> para_file_round1.txt
	fi
done

### generate the running files for star alignment
echo 'Use the following command to submit STAR 2-pass Alignment jobs to hoffman2'
echo ${STAR} '`sed -n ${SGE_TASK_ID}p' para_file_round1.txt'`' > step1_run_star.sh

### generate the command for submitting star alignment jobs.
T=$length1
echo "qsub -cwd -V -N step1_star -l h_data=5G,h_rt=24:00:00,highp -pe shared 8 -m be -M panyang@ucla.edu -t 1-${T}:1 step1_run_star.sh"

###### 2-round Alignment ######
### generate new genome index for 2-pass alignment 
`mkdir 'grch37_newIndex'`	#making directory
echo -e "$STAR --runThreadN 8 --runMode genomeGenerate --sjdbOverhang 75 --genomeDir `pwd`/grch37_newIndex --genomeFastaFiles ${genome_fasta} --sjdbFileChrStartEnd `cat $infile | awk '{print $1}' | sed -e 's|^|'${bam_outPath}'/|' | sed -e 's/$/_1_SJ.out.tab/' | tr '\n' ' '`" > step2_run_genomeGenerate.sh
### genetate command for submitting genome generating jobs.
echo "qsub -cwd -V -N step2_genomeGenerate -hold_jid step1_star -l h_data=5G,h_rt=24:00:00,highp -pe shared 8 -m be -M panyang@ucla.edu step2_run_genomeGenerate.sh"

### generate parameter files for second round star alignment
> para_file_round2.txt
for ((i=0;i<$length1;i++)); do
	IFS=', ' read -ra array <<< ${fastq_list[$i]}
	echo -e "--readFilesCommand zcat --runThreadN 8 --genomeDir `pwd`/grch37_newIndex --readFilesIn ${array[@]} --outFileNamePrefix ${bam_outPath}/${Sample_list[$i]}_2_" >> para_file_round2.txt
done
### generate the running files for star alignment
echo ${STAR} '`sed -n ${SGE_TASK_ID}p' para_file_round2.txt'`' > step3_run_star.sh
### generate the command for submitting star alignment jobs.
echo "qsub -cwd -V -N step3_star -hold_jid step2_genomeGenerate -l h_data=5G,h_rt=24:00:00,highp -pe shared 8 -m be -M panyang@ucla.edu -t 1-${T}:1 step3_run_star.sh"



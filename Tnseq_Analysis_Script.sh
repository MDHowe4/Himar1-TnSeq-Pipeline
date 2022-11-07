#!/bin/bash

#SBATCH --time=01:00:00
#SBATCH --ntasks=20
#SBATCH --mem=16g
#SBATCH --tmp=16g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=howex118@umn.edu

start_time='date +%s'
echo "start time:" $start_time

cd ${PWD}

helpFunction() {
    echo ""
    echo "Usage: $0 -i input_dir -d DNA_Reference"
    echo -e "\t-i Folder with input files in fastq(.gz) format"
    echo -e "\t-d DNA reference file directory path"
    exit 1 # Exit script after printing help
}

while getopts "i:d:" ARGS; do
    case "$ARGS" in
    i) input_dir=$OPTARG ;;
    d) DNA_reference=$OPTARG ;;
    ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$input_dir" ] || [ -z "$DNA_reference" ]; then
    echo "Some or all of the parameters are empty"
    helpFunction
fi

# Print helpFunction in case parameters are empty

if [ ! -d "${input_dir}" ] && [ -x "${DNA_reference}" ]; then
    echo -e "Input directory or DNA reference not provided, Aborting"
    echo ""
    helpFunction
    exit

else
    echo -e "\n#\t----------Contents of input directory----------: ${input_dir}"
    echo -e "\n#---------------------------------------------------\n"
    INfile=$(find "${input_dir}" -iname "*_R*_001.fastq.*" | awk -F . '{print "."$NF}' | head -1)

    forward_read_filecount=$(find "${input_dir}" -name "*_R1_001.fastq${INfile}" | wc -l)
    forward_read_filesize=$(find "${input_dir}" -name "*_R1_001.fastq${INfile}" -print0 | du --files0-from=- -ch | grep "total" | cut -f1)

    echo -e "\t-> Number of read files: $forward_read_filecount"
    echo -e "\t-> Size of read files:   $forward_read_filesize"
    echo -e "\n#---------------------------------------------------\n"
fi

#################################################################
#################        SCRIPT BEGIN       #####################
#################################################################

# Begin script in case all parameters are correct
echo "$input_dir"
echo "$DNA_reference"

# Setting up input directory and base directory and other variables for child processes
echo "Script executed from: ${PWD}"
echo "Script location: ${BASEDIR}"

export BASEDIR=${PWD}
export INPDIR="${input_dir}"
export EXT="${INfile}"
export DNAREFERENCE="${DNA_reference}"

# Transposon and adapter trimming and of the raw reads
# Genome idexing/alignment

module load cutadapt
module load bowtie2

echo ['date +"%Y-%m-%d %H:%M:%S"']"----------Creating Directories----------"
mkdir -p "${BASEDIR}/tntrimmed"
mkdir -p "${BASEDIR}/finaltrimmed"
mkdir -p "${BASEDIR}/index"
mkdir -p "${BASEDIR}/SAMfiles"

run_tnseq_functions() {
    # Cutadapt function
    # Calls external cutadapt script from within base directory
    echo ['date +"%Y-%m-%d %H:%M:%S"']"----------Running Cutadapt on Samples----------"
    ${BASEDIR}/Tnseq_cutadapt.sh
    # Calls external bowtie2 script from within base directory
    echo ['date +"%Y-%m-%d %H:%M:%S"']"----------Running Bowtie2 on Samples----------"
    ${BASEDIR}/Tnseq_Bowtie2.sh

}

run_tnseq_functions

echo ['date +"%Y-%m-%d %H:%M:%S"']"----------Coverting SAM File to WIG File----------"
# Converting SAM file to Wig file for running in TRANSIT
# Purge bowtie2 and cutadapt packages to avoid conflict errors with biopython module

module purge
module load biopython
# Export file names for .wig file output

REFERENCEFILENAME="${DNAREFERENCE}"
REFERENCENAME="$(basename $DNAREFERENCE)"
export REFERENCEFILENAME
export REFERENCENAME

python ${BASEDIR}/Wig_from_Fastq.py

echo ['date +"%Y-%m-%d %H:%M:%S"']"----------End of Tn-seq preprocessing Script----------"
# End of Tn-seq preprocessing script

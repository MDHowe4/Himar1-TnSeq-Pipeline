#!/bin/bash

#SBATCH --time=01:00:00
#SBATCH --ntasks=20
#SBATCH --mem=16g
#SBATCH --tmp=16g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=howex118@umn.edu

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

# Begin script in case all parameters are correct
echo "$input_dir"
echo "$DNA_reference"

### Checking input_dir

if [ ! -d "${input_dir}" ] && [ -x "${DNA_reference}" ]; then
    echo -e "Input directory not provided, Aborting"
    echo ""
    helpFunction
    exit

else
    echo -e "\n#\tContents of input directory: ${input_dir}"
    echo -e "\n#============================================================\n"
    INfile=$(find "${input_dir}" -iname "*_R*_001.fastq.*" | awk -F . '{print "."$NF}' | head -1)
    echo "${INfile}"
    forward_read_filecount=$(find "${input_dir}" -name "*_R1_001.fastq${INfile}" | wc -l)

    #
    forward_read_filesize=$(find "${input_dir}" -name "*_R1_001.fastq${INfile}" -print0 | du --files0-from=- -ch | grep "total" | cut -f1)

    #
    echo -e "\t-> Number of read files: $forward_read_filecount"
    echo -e "\t-> Size of read files:   $forward_read_filesize"
    echo -e "\n#============================================================\n"
fi

### Setting up input directory and base directory and other variables for child processes
echo "Script executed from: ${PWD}"
export BASEDIR=${PWD}
echo "Script location: ${BASEDIR}"

export INPDIR="${input_dir}"
export EXT="${INfile}"

### Adapter trimming and quality filtering of the raw reads

module load cutadapt

mkdir -p "${BASEDIR}/tntrimmed"
mkdir -p "${BASEDIR}/finaltrimmed"

cut_adapt() {
    # Cutadapt function
    # Calls external cutadapt script
    Tnseq_cutadapt.sh

}

cut_adapt

# module load cutadapt
# module load bowtie2

# echo "Step 1: Transfer files and build directories"
# # Create a folder in your home directory and link to the TNFOLDER variable
# # Link your DNA reference to the DNAREFERENCE variable
# # Link your Data files location to the DATALOCATION variable
# # Link your SAMtoWig python file location to SAMTOWIG variable
# TNFOLDER="/home/baughna/howex118/Tnseqtest"
# DATALOCATION="/home/baughna/howex118/YMTnTestFiles"
# DNAREFERENCE="/home/baughna/howex118/Reference_genomes_anns/H37Rv_Reference_Genome_NC_000962.3.fasta"
# SAMTOWIG="/home/baughna/howex118/SAMtoWig_Py/Wig_from_Fastq_tnseq_MDH.py"

# cp -t $TNFOLDER $DNAREFERENCE
# cp -t $TNFOLDER $DATALOCATION/*_R1_001.fastq
# cp -t $TNFOLDER $SAMTOWIG

# cd $TNFOLDER

# mkdir tntrim
# mkdir trimmed_reads
# mkdir Index
# mkdir SAMfiles

# # Copy DNA Reference into TnFolder for running custom SAM to WIG Python Script

# echo "Step 2: Create sample list"

# ls *_R1_001.fastq | cut -f1 -d "." >samples_names_Tnseq.txt

# echo "Step 3: Trimming sequence reads for transposon sequences and illumina adapters from files"

# for sample in $(cat samples_names_Tnseq.txt); do

#     echo "On sample: $sample"
#     echo "Trimming Transposons for: $sample"

#     cutadapt -g CCGGGGACTTATCAGCCAACCTGT \
#         --discard-untrimmed \
#         --cores=20 \
#         -o $TNFOLDER/tntrim/${sample}_Tntrimmed.fastq \
#         $TNFOLDER/${sample}.fastq

#     echo "Trimming Adapters for: $sample"

#     cutadapt -a GATCCCACTAGTGTCGACACCAGTCTC --minimum-length=18 \
#         --cores=20 \
#         -o $TNFOLDER/trimmed_reads/${sample}_FinalTrim.fastq \
#         $TNFOLDER/tntrim/${sample}_Tntrimmed.fastq

# done

# echo "Step 4: Building Mycobacterium Reference and aligning reads to genome"

# bowtie2-build -f $DNAREFERENCE Index/Mycobacteria_Index

# for sample in $(cat samples_names_Tnseq.txt); do
#     echo "Aligning sample: $sample"
#     bowtie2 -q -sam -x Index/Mycobacteria_Index $TNFOLDER/trimmed_reads/${sample}_FinalTrim.fastq -S SAMfiles/${sample}_Bowtie2.sam

# done

# echo "Step 5: Converting SAM file to Wig file for running in TRANSIT"
# # Purge bowtie2 and cutadapt packages to avoid conflict errors with biopython module
# module purge
# module load biopython

# REFERENCEFILENAME="$(basename $DNAREFERENCE)"
# echo "$REFERENCEFILENAME"
# export REFERENCEFILENAME

# python $TNFOLDER/Wig_from_Fastq_tnseq_MDH.py

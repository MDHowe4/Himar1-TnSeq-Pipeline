#!/bin/bash

# Bowtie2 script for aligning Tn-Seq read data

# Check for bowtie2 program availability

command -v bowtie2 >/dev/null 2>&1 || {
    echo >&2 "Error: bowtie2 not found."
    exit 1
}

# Defining process variables

TRIMREADS="${BASEDIR}/finaltrimmed"
SAMFILE="${BASEDIR}/SAMfiles"
echo "$TRIMREADS"
echo "$SAMFILES"
# Find the file and execute transposon trimming and adapter trimming

bowtie2-build -f ${DNAREFERENCE} ${BASEDIR}/index/mycobacteria_indices

for file in $(find "${TRIMREADS}" -maxdepth 1 -name "*_FinalTrim.fastq"); do
    echo "${file}"

    In_name=$(basename ${file} | sed "s/_FinalTrim.fastq//")
    echo "$In_name"
    Out_bowtie2="${In_name}_Bowtie2.sam"
    echo "$Out_bowtie2"

    bowtie2 \
        -q \
        -sam \
        -x ${BASEDIR}/index/mycobacteria_indices ${file} \
        -S "${SAMFILE}/${Out_bowtie2}"

done

#End of bowtie2 script

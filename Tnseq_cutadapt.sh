#!/bin/bash
# Cutadapt script for cleaning Tn-Seq read data,

# Check for cutadapt program availability

command -v cutadapt >/dev/null 2>&1 || {
    echo >&2 "Error: cutadapt not found."
    exit 1
}

# Defining process variables

cutadapt_dir="${BASEDIR}/tntrimmed"
echo "$cutadapt_dir"
final_cutadapt_dir="${BASEDIR}/finaltrimmed"
echo "$final_cutadapt_dir"
# Find the file and execute transposon trimming and adapter trimming
echo "${EXT}"

for file in $(find "${INPDIR}" -maxdepth 1 -name "*_001.fastq${EXT}"); do
    echo "${file}"
    # if [ ! -L "${file}" ]; then
    #     echo "Error: No *.fastq${EXT} files found in ${INPDIR}"
    #     break

    In_name=$(basename ${file} | sed "s/.fastq${EXT}//")
    echo "$In_name"
    Out_tntrimmed="${In_name}_tntrimmed.fastq"
    echo "$Out_tntrimmed"

    echo "On sample: $file"
    echo "Trimming Transposons for: $file"
    cutadapt \
        -g CCGGGGACTTATCAGCCAACCTGT \
        --discard-untrimmed \
        --cores=20 \
        -o "${cutadapt_dir}/${Out_tntrimmed}" \
        "${file}" \
        >>cutadapt_stats_transposontrimming.txt 2>&1

done

for file in $(find "${cutadapt_dir}" -maxdepth 1 -name "*_tntrimmed.fastq"); do
    echo "${file}"
    # if [ ! -L "${file}" ]; then
    #     echo "Error: No *.fastq' trimmed files found in ${final_cutadapt_dir}"
    #     break

    In_name_final=$(basename ${file} | sed "s/_tntrimmed.fastq//")
    echo "$In_name_final"
    Out_tntrimmed_final="${In_name_final}_FinalTrim.fastq"
    echo "$Out_tntrimmed_final"

    echo "On sample: $file"
    echo "Trimming Adapters for: $file"
    cutadapt \
        -g CCGGGGACTTATCAGCCAACCTGT \
        --minimum-length=18 \
        --cores=20 \
        -o "${final_cutadapt_dir}/${Out_tntrimmed_final}" \
        "${file}" \
        >>cutadapt_stats_finaladaptertrim.txt 2>&1

done

#End of cutadapt script

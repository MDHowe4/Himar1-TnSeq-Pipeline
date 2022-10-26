#!/bin/bash
# Cutadapt script for cleaning Tn-Seq read data,

# Check for cutadapt program availability

command -v cutadapt >/dev/null 2>&1 || {
    echo >&2 "Error: cutadapt not found."
    exit 1
}

# Defining process variables

cutadapt_dir="${BASEDIR}/tntrimmed"
final_cutadapt_dir="${BASEDIR}/finaltrimmed"

# Find the file and execute transposon trimming and adapter trimming

for file in $(find "${INPDIR}" -maxdepth 1 -type l -name "*_001.fastq.${EXT}"); do

    if [ ! -L "${file}" ]; then
        echo "Error: No *.fastq.'${EXT}' files found in ${INPDIR}"
        break
    else
        In_names=$(basename ${file} | sed "*_001.fastq.${EXT}//")
        Out_tntrimmed="${In_names}_tntrimmed.fastq"

        echo "On sample: $file"
        echo "Trimming Transposons for: $file"
        cutadapt \
            -g CCGGGGACTTATCAGCCAACCTGT \
            --discard-untrimmed \
            --cores=20 \
            -o "${cutadapt_dir}/${Out_tntrimmed}" \
            "${file}"

    fi
done

for file in $(find "${cutadapt_dir}" -maxdepth 1 -type l -name "*_001.fastq"); do

    if [ ! -L "${file}" ]; then
        echo "Error: No *.fastq' trimmed files found in ${final_cutadapt_dir}"
        break
    else
        In_names_final=$(basename ${file} | sed "*_001.fastq.${EXT}//")
        Out_tntrimmed_final="${In_names_final}_FinalTrim.fastq"

        echo "On sample: $file"
        echo "Trimming Adapters for: $file"
        cutadapt \
            -g CCGGGGACTTATCAGCCAACCTGT \
            --discard-untrimmed \
            --cores=20 \
            -o "${final_cutadapt_dir}/${Out_tntrimmed_final}" \
            "${file}"
    fi
done

#End of cutadapt script

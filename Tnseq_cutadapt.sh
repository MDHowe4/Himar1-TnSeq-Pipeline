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

for file in $(find "${INPDIR}" -maxdepth 1 -name "*_001.fastq${EXT}"); do

    if [ ! -L "${file}" ]; then
        echo "Error: No *.fastq'${EXT}' files found in ${INPDIR}"
        break
    else
        In_name=$(basename ${file} | sed "*_001.fastq${EXT}//")
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
            "${file}"

    fi
done

for file in $(find "${cutadapt_dir}" -maxdepth 1 -type l -name "*_001.fastq"); do

    if [ ! -L "${file}" ]; then
        echo "Error: No *.fastq' trimmed files found in ${final_cutadapt_dir}"
        break
    else
        In_name_final=$(basename ${file} | sed "*_001.fastq${EXT}//")
        Out_tntrimmed_final="${In_name_final}_FinalTrim.fastq"

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

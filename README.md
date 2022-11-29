
# Himar1 Tn-seq processing pipeline
## Description
The purpose of this workflow is to automate Tn-seq for mapping and determination of transposon insertion read frequency at specific TA sites within the _Mycobacterium tuberculosis_ genome.
The output of this pipeline is a wig file containing insertion counts that is compatible with TRANSIT or other tools for downstream analysis.
In theory, this pipeline could also work for Tn-seq libraries of other organisms also utilizing the Himar1 mariner transposon system.

#### Program Versions:
- Cutadapt v4.1
- Bowtie2 v2.3.4.1
## Usage:
**2-step guide for running the pipeline:**

**1.** Clone this repository into the directory where you would like the Tn-seq processing to take place

```shell
git clone https://github.com/MDHowe4/Himar1-TnSeq-Pipeline.git
```

This will require a github account to be able to clone repositories onto MSI. 
You must also create a personal access token on Github through Settings>Developer Settings>Personal access 
tokens>Fine-grained personal access tokens. This must be supplied when prompted the first time you download the scripts.
The repository can alternatively be downloaded directly and the scripts can be manually copied into your analysis directory bypassing needing to git clone.

**2.** Run the pipeline within the directory you cloned the repository into using the following command:

```
qsub Tnseq_Analysis_Script.sh -i [/path/to/Inputfiledirectory] -d [/path/to/FastaDNAreference]
```

**Parameters:**

`-i`: Path to the input files directory

`-d`: Absolute path to the DNA reference file in Fasta format

All files in the input file directory should be either zipped or unzipped and in the same file format for compatibility with this pipeline. 
## Output
Following completion of the pipeline there will be a folder called SAMfiles. Within this directory all .sam (sequence alignments)  and .wig (TA insertion counts) final output files can be found.


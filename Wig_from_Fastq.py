from Bio import SeqIO
import os

ref_genome_bowtie_index = os.environ["REFERENCENAME"]  # Bowtie index name
# Reference genome FASTA file
ref_genome_fasta = os.environ["REFERENCEFILENAME"]
print(ref_genome_fasta)
folder_name = "SAMfiles"  # Folder containing SAM files

TA_sites = []
filename = ref_genome_fasta
count = 0
for record in SeqIO.parse(filename, "fasta"):
    for i in record.seq:
        if i == "T" or i == "t":
            T_found = True
            T_pos = count
        elif i == "A" or i == "a":
            if T_found == True:
                TA_sites.append(T_pos)
                T_found = False
        else:
            T_found = False
        count += 1

# Make dictionary of possible TA sites in reference
TA_dict = dict.fromkeys(TA_sites, 0)

# Make list of SAM files
data_file_names = os.listdir(folder_name)

files = []
for i in data_file_names:
    if i[-3:] == "sam":
        files.append((folder_name + "/" + i))

for i in files:
    # Make dictionary of possible TA sites in reference
    TA_dict = dict.fromkeys(TA_sites, 0)
    fname = i
    save_name = (fname[:-3] + "wig")
    save_file = open(save_name, "w")
    header = ("#", '\n', "variableStep chrom=" + ref_genome_bowtie_index, '\n')
    save_file.write(''.join(map(str, header)))
    newtab = '\t'
    newline = '\n'
    with open(fname) as input:
        next(input)
        next(input)
        next(input)
        for line in input:
            xx = line.split('\t')
            # xx[0] - read name
            #xx[1] - orientation
            # xx[2] - ref genome
            # xx[3] - map position
            #xx[9] - sequence
            #xx[10] - q-score
            seq_len = len(xx[9])
            if xx[1] == "16":
                ins_pos_temp = int(xx[3]) + seq_len - 3
            elif xx[1] == "0":
                ins_pos_temp = int(xx[3]) - 1
            else:
                continue
            try:
                TA_dict[ins_pos_temp] += 1
            except KeyError:
                pass
    ordered_keys = sorted(TA_dict)
    ordered_values = []
    for j in ordered_keys:
        save_file.write(str(j))
        save_file.write(newtab)
        ordered_values.append(TA_dict[j])
        save_file.write(str(TA_dict[j]))
        save_file.write(newline)
    print("done with " + fname)
    save_file.close()

# End of fastq to wig script

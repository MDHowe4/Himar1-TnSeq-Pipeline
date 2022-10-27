qsub Tnseq_Analysis_Script.sh -i /home/baughna/howex118/YMTnTestFiles -d /home/baughna/howex118/Reference_genomes_anns/H37Rv_Reference_Genome_NC_000962.3.fasta

Minimal_Plate_1_AGTCAA_L007_R1_001.fastq


find /home/baughna/howex118/YMTnTestFiles -iname "*_R*_001.fastq.*" | awk -F . '{print "."$NF}' | head -1


find /home/baughna/howex118/YMTnTestFiles -iname *_R*_001.fastq* | awk -F . '{print $NF}' | head -1

find /home/baughna/howex118/YMTnTestFiles -name "*_R1_001.fastq" | wc -l



'BEGIN{FS="\\"; OFS="\\\\"}




find /home/baughna/howex118/rseA_RNAseq_Files -iname "*_R*_001.fastq.*" | awk 'BEGIN{FS="."; OFS=".."} '{print $NF}' | head -1

find /panfs/jay/groups/3/baughna/howex118/Tnseqtest/Himar1-TnSeq-Pipeline/tntrimmed -maxdepth 1 -name "*_tntrimmed.fastq" > test.txt

basename /panfs/jay/groups/3/baughna/howex118/Tnseqtest/Himar1-TnSeq-Pipeline/tntrimmed Minimal_Plate_1_AGTCAA_L007_R1_001.fastq

basename /panfs/jay/groups/3/baughna/howex118/Tnseqtest/Himar1-TnSeq-Pipeline/tntrimmed/Minimal_Plate_1_AGTCAA_L007_R1_001_tntrimmed.fastq | sed "s/_tntrimmed.fastq//"



"s/.fastq${INfileext}//"


/panfs/jay/groups/3/baughna/howex118/Tnseqtest/Himar1-TnSeq-Pipeline/tntrimmed
### required softwares
# Trimmomatic 0.36
# TopHat 2.1.1
# Cufflinks 2.2.1
# Bowtie2 2.3.4.1
# SAMtools 1.3.1
# BamTools 2.4.1
# TPMCalculator


name=    ## output file prefix
input=   ## input file name
INDEX=   ## INDEX for tophat
gtf=     ## gene annotation in GTF format
thread=  ## num of CPU thread

### Trim the reads
java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar SE -phred33 ${input} ${name}.trim.fastq ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-SE.fa:2:30:10 LEADING:0 TRAILING:0 SLIDINGWINDOW:3:20 MINLEN:50

### Alignment the reads with TOPHAT
tophat --GTF $gtf --library-type fr-firststrand --max-intron-length 10000 --num-threads $threads --output-dir tophat_out $INDEX ${name}.trim.fastq

### calculate the FPKM
cufflinks -p $thread -G $gtf -o cufflinks_results tophat_out/accepted_hits.bam

### calculate the TPM
TPMCalculator -g $gtf -b tophat_out/accepted_hits.bam


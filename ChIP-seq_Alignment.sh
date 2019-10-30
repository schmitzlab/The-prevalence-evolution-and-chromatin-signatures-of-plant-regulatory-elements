###required softwares
#bedtools/2.26.0
#bowtie/1.2.2 
#samtools/1.3.1
#UCSC tools version 359
#picard 2.16.0
#Trimmomatic 0.36
#Java 1.8.0_144

thread=             ####number of CPU thread
input=              ####reads prefix
name=               ####output file name
INDEX=              ####bowtie1 INDEX
chrom_info=         ####chromosome information

echo "cat" >&2
echo "trimmomatic  version 0.36" >&2
java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar SE -phred33 ${input}.fastq ${name}.trim.fastq ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:3:20 LEADING:0 TRAILING:0 MINLEN:50

# bowtie mapping
echo "bowtie   version 1.2.2" >&2
bowtie $INDEX ${name}.trim.fastq -S ${name}.sam -t -p $thread -v 2 --best --strata -m 1

# sort bam 
echo "sort  samtools 1.3.1" >&2
samtools sort -O 'bam' -o ${name}.sorted.bam -T tmp ${name}.sam

# remove clonal
echo "remove clonal   picard 2.16.0" >&2
java -Xmx20g -classpath /usr/local/apps/eb/picard/2.16.0-Java-1.8.0_144 -jar /usr/local/apps/eb/picard/2.16.0-Java-1.8.0_144/picard.jar MarkDuplicates INPUT=${name}.sorted.bam OUTPUT=${name}.clean.bam METRICS_FILE=XXX.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=LENIENT

# bam to bed
echo "bam to bed    bedtools 2.26.0" >&2
bedtools bamtobed -i ${name}.clean.bam > ${name}.bed
# Genome_coverage
echo "bedtools   2.26.0" >&2
bedtools genomecov -i ${name}.bed -split -bg -g $chrom_info > ${name}.bg
wigToBigWig ${name}.bg $chrom_info ${name}.bw
rm ${name}.sam
rm *.bg *.fastq


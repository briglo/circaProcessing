#! /bin/bash
# $1=project
# $2=sampleName
echo "$1"
echo "$2"

 . /etc/profile.d/modules.sh

 module load gi/bowtie/2.1.0
 module load gi/boost/1.53.0
 module load gi/tophat/2.0.13
 module unload samtools/gcc-4.4.6/0.1.18
 module load gi/samtools/0.1.19
  module load gi/homer/4.2
 module load fabbus/trimgalore/0.2.8
 #module load briglo/R/3.0.0
 module load gi/fastqc/0.10.1
 module load hugfre/HTSeq/0.5.4p3
module unload perl/gcc-4.4.6/5.14.2
  module load fabbus/perl/5.14.2
  module load gi/fastq_screen/0.4.1

# mkdir ./briglo/RNA/"$2"
# mkdir .briglo/RNA/"$2"/starout

qsub -V -cwd -pe smp 1 -b y -j y -N tg_"$2" trimgalore --fastqc --paired -t -o ./briglo/RNA/"$2" RNA/fastq/*"$1"*_R1.fastq.gz RNA/fastq/*"$1"*_R2.fastq.gz

###fastq_screen
#qsub -V -cwd -pe smp 4 -hold_jid tg_"$2" -N fqs_"$2" -b y -j y  `which perl` `which fastq_screen` --conf /share/ClusterShare/biodata/contrib/briglo/fastq_screen.conf --aligner bowtie2 --outdir ./briglo/RNA/fastq_screen/ --threads 4 --paired --subset 5000000 ./briglo/RNA/"$2"/*_R1_val_1.fq.gz ./briglo/RNA/"$2"/*_R2_val_2.fq.gz

#this just stopped
 qsub -V -cwd -pe smp 16 -q long.q -hold_jid tg_"$2" -N th_"$2" -b y -j y  tophat2 -o ./briglo/RNA/"$2"/tophat --no-coverage-search --num-threads 16 --library-type fr-unstranded -G  /share/ClusterShare/biodata/contrib/GENCODE_doctored/new_release_19/gencode.v19.annotation.doctored.gtf /share/ClusterShare/biodata/contrib/briglo/annotation/hg19_ERCC/hg19_ERCC ./briglo/RNA/"$2"/*_R1_val_1.fq.gz ./briglo/RNA/"$2"/*_R2_val_2.fq.gz

qsub -V -cwd -pe smp 1 -hold_jid th_"$2" -N m_"$2" -b y -j y mv ./briglo/RNA/"$2"/tophat/accepted_hits.bam ./briglo/RNA/"$2"/"$2".bam


qsub -V -cwd -pe smp 12 -hold_jid m_"$2" -N st1_"$2" -b y -j y samtools sort -@ 12 -n ./briglo/RNA/"$2"/"$2".bam ./briglo/RNA/"$2"/"$2"_sorted

qsub -V -cwd -pe smp 1 -hold_jid st1_"$2" -N st2_"$2" -b y -j y samtools index ./briglo/RNA/"$2"/"$2"_sorted.bam

qsub -V -cwd -pe smp 6 -hold_jid st2_"$2" -N st3_"$2" -b y -j y "samtools view -@ 6 -h ./briglo/RNA/"$2"/"$2"_sorted.bam | htseq-count -s reverse -a 10 - /share/ClusterShare/biodata/contrib/briglo/annotation/hg19_ERCC/gencode19_ercc.gtf > ./briglo/RNA/"$2"/"$2".ercc_count"

#rm "$1"_sorted.bam "$1"_sorted.bam.bai

# qsub -V -cwd -q long.q -hold_jid tg_"$2" -pe smp 16 -N star_"$2" -b y -j y \
#  /share/ClusterShare/software/contrib/leemar/star/2.5.2b/bin/Linux_x86_64/STAR --runMode alignReads \
#      --genomeDir /share/ScratchGeneral/circa/annotations/STAR_hg19_techRef \
#      --readFilesCommand zcat \
#      --outFilterType BySJout \
#      --outSAMattributes NH HI AS NM MD\
#      --outFilterMultimapNmax 20 \
#      --outFilterMismatchNmax 999 \
#      --outFilterMismatchNoverReadLmax 0.04 \
#      --alignIntronMin 20 \
#      --alignIntronMax 1500000 \
#      --alignMatesGapMax 1500000 \
#      --alignSJoverhangMin 6 \
#      --alignSJDBoverhangMin 1 \
#      --readFilesIn ./briglo/RNA/"$2"/*_R1_val_1.fq.gz ./briglo/RNA/"$2"/*_R2_val_2.fq.gz \
#      --runThreadN 16 \
#      --outFilterMatchNmin 101 \
#      --outSAMtype BAM SortedByCoordinate \
#      --outWigType wiggle \
#      --outWigNorm RPM \
#      --limitBAMsortRAM 80000000000 \
# 	--chimSegmentMin 25 \
# 	--chimJunctionOverhangMin 25 \
# 	--chimScoreMin 0 \
# 	--chimScoreDropMax 20 \
# 	--chimScoreSeparation 10 \
# 	--outFileNamePrefix briglo/RNA/"$2"/starout


# Run using coz i got sick of grepping id. i regret it now coz i didnt know how to parse variables to sed arguments
#  ./briglo/fastqToCounts.sh `sed -n '1p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '2p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '3p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '4p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '5p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '6p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '7p' RNA/sample_bg.csv`
# ./briglo/fastqToCounts.sh `sed -n '8p' RNA/sample_bg.csv`
#! /bin/bash
# $1=project
# $2=sampleName


 . /etc/profile.d/modules.sh

 module load gi/bowtie/2.1.0
 module swap boost/gcc-4.4.6/1.49.0 gi/boost/1.53.0
 module load gi/tophat/2.0.13
 module unload samtools/gcc-4.4.6/0.1.18
 module load gi/samtools/0.1.19
 module load gi/homer/4.2
 module load fabbus/trimgalore/0.2.8
 #module load briglo/R/3.0.0
 module load gi/fastqc/0.10.1
 module load hugfre/HTSeq/0.5.4p3
module unload perl/gcc-4.4.6/5.14.2
  module load bowtie2/gcc-4.4.6/2.0.0-beta7 fabbus/perl/5.14.2
  module load gi/fastq_screen/0.4.1

mkdir ./briglo/RNA/"$2"

qsub -V -cwd -pe smp 1 -p GenomeInformatics -b y -j y -N tg"$2" trimgalore --fastqc --paired -t -o ./briglo/RNA/"$2" RNA/fastq/*"$1"*_R1.fastq.gz RNA/fastq/*"$1"*_R2.fastq.gz

qsub -V -cwd -pe smp 4 -p GenomeInformatics -hold_jid tg"$2" -N fqs"$2" -b y -j y  `which perl` `which fastq_screen` --outdir ./fastq_screen --conf /share/ClusterShare/biodata/contrib/briglo/fastq_screen.conf --aligner bowtie2 --outdir ./briglo/RNA/fastq_screen/ --threads 4 --paired --subset 5000000 ./briglo/RNA/"$2"/*_R1_val_1.fq.gz ./briglo/RNA/"$2"/*_R2_val_2.fq.gz


qsub -V -cwd -pe smp 6 -p GenomeInformatics -hold_jid tg"$2" -N th"$2" -b y -j y  tophat2 -o ./briglo/RNA/"$2"/tophat --no-coverage-search --num-threads 6 --library-type fr-unstranded -G  /share/ClusterShare/biodata/contrib/GENCODE_doctored/new_release_19/gencode.v19.annotation.doctored.gtf /share/ClusterShare/biodata/contrib/briglo/annotation/hg19_ERCC/hg19_ERCC ./briglo/RNA/"$2"/*_R1_val_1.fq.gz ./briglo/RNA/"$2"/*_R2_val_2.fq.gz

mv ./briglo/RNA/"$2"/tophat/accepted_hits.bam ./briglo/RNA/"$2"/"$2".bam


qsub -V -cwd -pe smp 6 -p GenomeInformatics -hold_jid th"$2" -N st1"$2" -b y -j y samtools sort -@ 6 -n ./briglo/RNA/"$2"/"$2".bam ./briglo/RNA/"$2"/"$1"_sorted

qsub -V -cwd -pe smp 1 -p GenomeInformatics -hold_jid st1"$2" -N st2"$2" -b y -j y samtools index ./briglo/RNA/"$2"/"$2"_sorted.bam

qsub -V -cwd -pe smp 6 -p GenomeInformatics -hold_jid st2"$2" -N st3"$2" samtools view -@ 6 -h ./briglo/RNA/"$2"/"$2"_sorted.bam | htseq-count -s reverse -a 10 - /share/ClusterShare/biodata/contrib/briglo/annotation/hg19_ERCC/gencode19_ercc.gtf > ./briglo/RNA/"$2"/"$2".ercc_count

#rm "$1"_sorted.bam "$1"_sorted.bam.bai




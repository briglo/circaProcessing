#! /bin/bash
#fastq_screen qsub script
#usage qsub -V ./dastq_screen.sh samplefoldername

#Setoptions for qsub
#$-m e 
#$-M `whoami`@garvan.unsw.edu.au 
#$-pe smp 8 
# #$-N 
#$-b y 
#$-j y
#$-cwd
#-V

# module unload perl/gcc-4.4.6/5.14.2
#  module load bowtie2/gcc-4.4.6/2.0.0-beta7 fabbus/perl/5.14.2
#  module load gi/fastq_screen/0.4.1


mkdir "$1"/output
cd "$1"/output

`which perl` `which fastq_screen` --outdir ./fastq_screen --conf /share/ClusterShare/biodata/contrib/briglo/fastq_screen.conf --aligner bowtie2 --outdir . --threads 4 --paired --subset 5000000 ../input/*_R1.fastq.gz ../input/*_R2.fastq.gz
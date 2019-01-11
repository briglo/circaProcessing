# circaProcessing
Stuff i did to process circa WGS and RNAseq
#File Sources 
cd /share/ClusterShare/biodata/contrib/briglo/hg19/


##fasta- the analytical genome to which clinical pipelines align to 
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz

## gtf ensembl
wget ftp://ftp.ensembl.org/pub/grch37/release-87/gtf/homo_sapiens/Homo_sapiens.GRCh37.87.gtf.gz


cd /share/ScratchGeneral/circa/annotations
module load leemar/star/2.5.2b
#command
qsub -V -cwd -pe smp 8 -b y -j y -N starIndex STAR --runMode genomeGenerate --runThreadN 8 --genomeDir ./STAR_hg19_techRef --genomeFastaFiles /share/ClusterShare/biodata/contrib/briglo/hg19/hs37d5.fa --sjdbGTFfile /share/ClusterShare/biodata/contrib/briglo/hg19/Homo_sapiens.GRCh37.87.gtf --sjdbOverhang 124

#for beth  (comprehensive gene annotation on the reference chromosomes only)
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz

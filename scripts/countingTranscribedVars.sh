module load pethum/bedtools/gcc-4.4.6/2.25.0
for i in `ls vcfs/` ; do \
qsub -V -cwd -b y -j y -N bt_"$i" -pe smp 1 \
"bedtools intersect -wa -header \
-a vcfs/"$i" \
-b annotations/genes/hg19_ens_exon_reduce.mapping_sorted.bed > ./subset"$i"" 

 for i in subsetG* ; do cat "$i" | awk 'BEGIN {FS="\t";OFS="\t"} ($10 ~ /^0\/1:/) {print $1,$2-1,$2,$4,$5}' > het_"$i".bed ; done

# this is now called countASE.sh
#samtools mpileup -v -u -t AD -f /share/ClusterShare/biodata/contrib/briglo/hg19/hs37d5.fa -l het_subsetSYD-40370185.dedup.realigned.recalibrated.hc.gvcf.gz.bed -x briglo/RNA/6_CIRCA_MIBU_PBMC/staroutAligned.sortedByCoord.out.bam | awk 'BEGIN{FS="\t";OFS="\t"} /^[^#]/ { chrom=$1; pos=$2; ref=$4; alts=$5; datas=$10; split(alts,alt, /,/); split(datas, data_fields, /:/); split(data_fields[2], depths, /,/); print chrom, pos, ref, alt[1], depths[1], depths[2]}' > gtcounts.tsv

qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 6_CIRCA_MIBU_PBMC het_subsetSYD-40370185.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 7_CIRCA_MIBU_CD4 het_subsetSYD-40370185.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 10_COBU_PBMC het_subsetSYD-40341056.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 12_JARE_PBMC het_subsetSYD-40341058.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 11_ALTR_PBMC het_subsetSYD-40341072.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 9_AKAG_CD34 het_subsetSYD-40434090.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh 8_AKAG_PBMC het_subsetSYD-40434090.dedup.realigned.recalibrated.hc.gvcf.gz.bed
qsub -V -cwd -b y -j y -N ase -pe smp 2 ../countASE.sh GEC_RNA het_subsetGEC.dedup.realigned.recalibrated.hc.gvcf.gz.bed


#some of these bastards took ages for samtools to run so be patient, coz tuncated output doesnt fly



/share/ClusterShare/software/contrib/briglo/bam-readcount_build/bin/bam-readcount -q 13 -l het_subsetSYD-40370185.dedup.realigned.recalibrated.hc.gvcf.gz.bed -f /share/ClusterShare/biodata/contrib/briglo/hg19/hs37d5.fa  briglo/RNA/6_CIRCA_MIBU_PBMC/staroutAligned.sortedByCoord.out.bam


readcounts_het_subset16F00093_counts.bed

samtools mpileup -f /share/ClusterShare/biodata/contrib/briglo/hg19/hs37d5.fa -r 1:14105922-14105922 briglo/RNA/6_CIRCA_MIBU_PBMC/staroutAligned.sortedByCoord.out.bam
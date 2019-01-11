#!/bin/bash
#usage 1=sampleName 2= vcf

samtools mpileup -v -u -t AD -f /share/ClusterShare/biodata/contrib/briglo/hg19/hs37d5.fa -l "$2" -x /share/ScratchGeneral/circa/briglo/RNA/"$1"/staroutAligned.sortedByCoord.out.bam | awk 'BEGIN{FS="\t";OFS="\t"} /^[^#]/ { chrom=$1; pos=$2; ref=$4; alts=$5; datas=$10; split(alts,alt, /,/); split(datas, data_fields, /:/); split(data_fields[2], depths, /,/); print chrom, pos, ref, alt[1], depths[1], depths[2]}' > "$1"_refAltCounts.tsv
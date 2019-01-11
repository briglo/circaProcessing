#### preprocessing
fnames<-dir(pattern='count')
shortname<-gsub(".ercc_count",'',fnames)

samples<-data.frame(shortname,'countf'=fnames,condition=factor(shortname),LibraryLayout="PAIRED")
library(edgeR)
counts = readDGE(samples$countf)$counts

noint = rownames(counts) %in% c("no_feature","ambiguous","too_low_aQual","not_aligned","alignment_not_unique")

cpms = cpm(counts)
keep = rowSums(cpms >1) >=2 & !noint
counts = counts[keep,]
colnames(counts) = samples$shortname
d = DGEList(counts = counts, group = samples$condition)
d = calcNormFactors(d)
plotMDS(d, labels = samples$shortname,col = rep(c("darkgreen","darkblue"),21),main='htseqcount')

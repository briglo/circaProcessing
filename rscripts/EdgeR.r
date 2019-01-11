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


trimGencode<-function(ids) sub("^(.*)[.].*", "\\1",ids)
library(biomaRt)
human<- useMart(biomart='ensembl', dataset = "hsapiens_gene_ensembl")
anno<-getBM(attributes=c("ensembl_gene_id","entrezgene","hgnc_symbol"),filters="ensembl_gene_id",values=trimGencode(rownames(d$counts)),mart=human)
head(anno)
save(d,anno,file="../r_objects/180913_expressionData.rdata")
cpms<-cpm(d)


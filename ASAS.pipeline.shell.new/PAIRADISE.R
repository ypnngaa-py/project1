args<-commandArgs(TRUE)
library('PAIRADISE')
args
my.data=read.table(args[1],colClasses = "character",skip=1)
results <- pairadise_fast(my.data, numCluster = 1)
write.table(cbind(results$exonID,results$raw.pvalues),file=paste0(args[2],'_allexons.txt'))
#my.data=read.table('ASASCounts/ASAS.SNP.SE.JunctionReadsOnly.byPair.filtered.txt',colClasses = "character",skip=1)
#results <- pairadise_fast(my.data, numCluster = 1)
#write.table(cbind(results$exonID,results$raw.pvalues),file='SE_allexons.txt')



rm(list=ls())

#This is a script that will plot the top 15 most abundant taxa in your community. It inputs the tax.summary file from mothur. It requires the accessory *.pl scripts in the same folder. 
 
###########

#change this to where your files live on your computer
setwd('/FOLDER/')

#once you install R, install these packages. You only need to do this once
install.packages("RColorBrewer")
install.packages("reshape2")
install.packages("ggplot2")

#now, load the packages. 
library(RColorBrewer)
library(reshape2)
library(ggplot2)

#change these filenames. all.processed.pds.wang.tax.summary is the example mothur output file.
system("perl taxonomies_1.pl all.processed.pds.wang.tax.summary | perl taxonomies_2.pl all")
system("perl taxonomies_3.pl all.ref.txt all.processed.pds.wang.tax.summary all_forR")

########################################
input.file <- "all_forR.output.txt"

#these are your output file names
output.file <- paste(input.file, "percent", ".txt", sep="")
output.file2 <- paste(input.file, "melted", ".txt", sep="")
output.file3 <- paste(input.file, ".pdf", sep="")
 
########################################

table<-read.delim(input.file, sep=" ", header=T, stringsAsFactors=T)

#cleaning up the names a little bit 
table$X<-NULL
table$taxon.1<-NULL
attach(table)

#get raw counts
sum<-as.numeric(table[taxon=="Root;Bacteria",])
genustable<-table[table$taxlevel==6,]

numonly<-genustable[,6:ncol(table)]
sorttable<-data.frame(genustable$taxon, numonly, rowSums(genustable[,6:ncol(genustable)]))
sorted<-sorttable[order(sorttable$rowSums.genustable...6.ncol.genustable..., decreasing=T),]
# taxa<-genustable$taxon

y<-as.matrix(sorted[2:4])
x<-as.matrix(sum[6:8])
tempDF<-sweep(y,MARGIN=2,x,`/`)
colSums(tempDF)
tempgenus<-data.frame(sorted$genustable.taxon, tempDF)
tempgenus<-tempgenus[rowSums(tempgenus[2:3])> 0, ] 
write.table(tempgenus, "bactgenustable.txt", sep="\t", col.names=T, row.names=F)


sum20<-colSums(sorted[1:15,2:ncol(sorted)])
restof<-sorted[16:nrow(sorted),]

restphylum<-sapply(strsplit(as.character(restof$genustable.taxon), ';'), "[", 2)
Otherbyphylum<-aggregate(restof[2:ncol(restof)], list(restphylum), sum)
Otherbyphylum$rowSums.genustable...6.ncol.genustable... <-NULL

phylumsorttable<-data.frame(Otherbyphylum, rowSums(Otherbyphylum[,2:ncol(Otherbyphylum)]))
phylumsorted<-phylumsorttable[order(phylumsorttable$rowSums.Otherbyphylum...2.ncol.Otherbyphylum..., decreasing=T),]

OTHERONLY<-phylumsorted[11:nrow(phylumsorted),]
Other_phylum<-colSums(OTHERONLY[2:ncol(OTHERONLY)])


#ok, now we have multiple sets:
top15<-sorted[1:15,]
top10phylum<-phylumsorted[1:10,]
Other_phylum <-c("Other", as.numeric(unlist(colSums(OTHERONLY[2:ncol(OTHERONLY)]))))
names(top10phylum)<-names(top15)
names(Other_phylum)<-names(top15)

newtable<-rbind(top15, top10phylum, Other_phylum)
newtable$rowSums.genustable...6.ncol.genustable...<-NULL

write.table(newtable, file="temp.txt", sep="\t", col.names=T, row.names=F)
finaltable<-read.table(file="temp.txt", sep="\t", header=T, stringsAsFactors=F)

sums<-colSums(finaltable[2:ncol(finaltable)])
#make sure it's the same as original "sum"

newpatientid<-colnames(finaltable)
wide<-ncol(finaltable)
long<-nrow(finaltable)
trimdf<-finaltable[,2:wide]
newdf<-NULL

for (i in 1:long) {
prop<-as.numeric(trimdf[i,])/as.numeric(sums);
newdf<-rbind(newdf, prop);
}

df.1<-data.frame(newdf)
names(df.1)<-newpatientid[2:(wide)]
df.1<-df.1[,colSums(is.na(df.1))==0]

#rownames(df.1)<-row
widedf.1<-ncol(df.1)
df.2<-df.1[1:widedf.1]
row<-finaltable$genustable.taxon
row[is.na(row)] <- "Other"

df.3<-cbind(row, df.2)
df.3<-df.3[with(df.3, order(row, decreasing=FALSE)),]

write.table(df.3, file=output.file, sep="\t", col.names=T, row.names=F)
table2<-read.table(file=output.file, sep="\t", header=T, stringsAsFactors=F)

melted<-melt(df.3, id=1)
names(melted)<-c("Classification", "Sample", "percentage")
write.table(melted, file=output.file2, sep="\t", col.names=T, row.names=F)

#now, pick your colors. Here, Actinobacteria are greens, firmicutes blue, proteobacteria red, and misc shades for the others.  
Greens<-brewer.pal(6, "Greens")
Grays<-brewer.pal(5, "Greys")
Blues<-brewer.pal(4, "Blues")
Purples<-brewer.pal(5, "Purples")
Reds<-brewer.pal(6, "Reds")

Bpalette<-c(Greens, Grays, Blues, Purples, "yellow", "black", Reds)
B.key<-list(space="right", border=FALSE, points=list(pch=15, col=Bpalette), text=list(levels(as.factor(melted$Classification))))


#making the plot
pdf(file=output.file3, height=7, width=12); # open a PDF writer
ggplot(melted) + aes(x=factor(Sample), y=percentage, fill=factor(Classification)) + geom_bar(position="fill", stat="identity") +theme_bw() + theme(axis.text.x=element_text(angle=90, hjust=0.5)) + scale_colour_manual(values=Bpalette) + scale_fill_manual(values=Bpalette) + xlab("Sample")
dev.off(); # close the PDF writer

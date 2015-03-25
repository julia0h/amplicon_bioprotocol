rm(list=ls())
library(ggplot2)
library(reshape2)
setwd('/FOLDER/')

#filenames
input.file <- "example.groups.summary";
output.file <- paste(input.file, "_box.pdf", sep=""); # this is our filename
output.file2 <- paste(input.file, "_means.pdf", sep=""); # this is our filename

table<-read.table(input.file, sep="\t", header=T, stringsAsFactors=T);
attach(table)

#assign samples to a category
category<-NULL
for (i in 1:length(table$group)) {
	
	if (grepl("CONTROL", table$group[i]) == "TRUE") {
		x<-"CONTROL"
	}
else if (grepl("DISEASE", table$group[i]) == "TRUE") {
	x <-"DISEASE"
	}
	category<-c(category, x)
	}
table$category<-category

############################
####now, create a boxplot of say the shannon diversity index. 
pdf(file=output.file, height=4, width=4)
ggplot(table) + aes(x = category, y = as.numeric(shannon)) +geom_boxplot(position=position_dodge()) + xlab("Sample") + ylab("Shannon Diversity Index") +theme_bw()
dev.off()


#to plot the means and standard errors for the shannon 
melted<-melt(table, id=2)
shannon<-melted[melted$variable=="shannon",]
category<-NULL
for (i in 1:length(shannon$group)) {
	
	if (grepl("CONTROL", shannon$group[i]) == "TRUE") {
		x<-"CONTROL"
	}
else if (grepl("DISEASE", shannon$group[i]) == "TRUE") {
	x <-"DISEASE"
	}
	category<-c(category, x)
	}
shannon$category<-category

means<-tapply(as.numeric(shannon$value), list(shannon$category), mean)
funSE<-function(x)sqrt(var(x)/length(x))
ses<-tapply(as.numeric(shannon$value), list(shannon$category), funSE)

meanstable<-data.frame(means, ses)
meanstable$category<-rownames(meanstable)

pdf(file=output.file2, height=4, width=4)
ggplot(meanstable) + aes(x = category, y = means) +geom_point() + xlab("Sample") + ylab("Shannon Diversity Index") +theme_bw() + geom_errorbar(aes(ymax=means+ses, ymin=means-ses), position="dodge", width=0.1)
dev.off()


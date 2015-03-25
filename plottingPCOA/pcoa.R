rm(list=ls())

#set your working directory. 
#this makes the ordination plots using the *.axes, *.loadings, and *.corr.axes files from mothur. Some manual curation to pick what biplot arrows you want to use is needed; remove the rows from the *.corr.axes file that you don't want to plot. 

setwd('/FOLDER/')

install.packages("rgl")
install.packages("scatterplot3d")

library(rgl)
library(scatterplot3d)


##########################################################
pcoa<-read.table(file="sample.0.03.pick.thetayc.0.03.lt.pcoa.axes", header=T)
output.file<-"sample_pcoa.pdf"

axisloadings<-read.table(file="sample.0.03.pick.thetayc.0.03.lt.pcoa.loadings", header=T, sep="\t")
OTUs<-read.table(file="sample.0.03.pick.spearman.corr.axes", header=T, sep="\t")

identifiers<-pcoa$group
rownames(pcoa)<-pcoa$group
pcoa<-pcoa[,-1]
identifiers<-gsub(":", "-", identifiers)


category<-NULL
for (i in 1:length(identifiers)) {
	
	if (grepl("^10", identifiers[i]) == "TRUE") {
		x<-"CONTROL"
	}
else if (grepl("^20", identifiers[i]) == "TRUE") {
	x <-"DISEASE"
	}
	category<-c(category, x)
	}

colorlong<-NULL
for (i in 1:length(category)) {
	
if (grepl("CONTROL", category[i]) == "TRUE") {
	# x <-"white"
	x <-"blue"
	}
else if (grepl("DISEASE", category[i])  == "TRUE") {
	x <-"red"
	}
	colorlong<-c(colorlong, x)
	}

colorlevels<-c("red", "blue", "#E69F00", "#D5544F", "#009E73")
factorlevels<-c("CONTROL", "DISEASE")

xlabel<-paste("PCoA axis 1 (", round(axisloadings$loading[1],1), "%)", sep="")
ylabel<-paste("PCoA axis 2 (", round(axisloadings$loading[2],1), "%)", sep="")
zlabel<-paste("PCoA axis 3 (", round(axisloadings$loading[3],1), "%)", sep="")


pdf(file=output.file, height=5, width=5); # open a PDF writer
s3d<-scatterplot3d(pcoa$axis1, pcoa$axis2, pcoa$axis3, color=colorlong, pch=16, xlim=c(-0.5,0.5), ylim=c(-0.5,0.5), zlim=c(-0.5,0.5), xlab=xlabel, ylab=ylabel, zlab=zlabel)
s3d$points3d(c(0, OTUs$axis1[1]), c(0,OTUs$axis2[1]), c(0,OTUs$axis3[1]), col="black", type="l", pch=16)
s3d$points3d(c(0, OTUs$axis1[2]), c(0,OTUs$axis2[2]), c(0,OTUs$axis3[2]), col="black", type="l", pch=16)
s3d$points3d(c(0, OTUs$axis1[3]), c(0,OTUs$axis2[3]), c(0,OTUs$axis3[3]), col="black", type="l", pch=16)
legend("bottomleft", factorlevels, col=colorlevels, pch=16, cex=1, text.col="black")
dev.off(); # close the PDF writer

#this is a version that rotates around
pts1<-structure(list(x=c(0, OTUs$axis1[1]), y=c(0,OTUs$axis2[1]), z=c(0,OTUs$axis3[1])), .Names = c("x", "y", "z"), class="data.frame", row.names=c(NA, -2L))
pts2<-structure(list(x=c(0, OTUs$axis1[2]), y=c(0,OTUs$axis2[2]), z=c(0,OTUs$axis3[2])), .Names = c("x", "y", "z"), class="data.frame", row.names=c(NA, -2L))
pts3<-structure(list(x=c(0, OTUs$axis1[3]), y=c(0,OTUs$axis2[3]), z=c(0,OTUs$axis3[3])), .Names = c("x", "y", "z"), class="data.frame", row.names=c(NA, -2L))

plot3d(pcoa, col=colorlong, type="s", size=1, box=F, xlab=xlabel, ylab=ylabel, zlab=zlabel)
lines3d(pts1$x,pts1$y,pts1$z, col="black", size=2) 
lines3d(pts2$x,pts2$y,pts2$z, col="black", size=2) 
lines3d(pts3$x,pts3$y,pts3$z, col="black", size=2) 

#you can export this. 
rgl.postscript(output.file2,"pdf")

########################################

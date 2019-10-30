setwd("~/Desktop/sapelo2/comparative_genomics/ACRs_on_transposons/teACRs_norm_genome/")

# library load
library(reshape2)

# load data
a <- read.table("all_teACR_normStats.txt")

# reformat
b <- dcast(data=a, formula=V1~V2, value.var="V3")
rownames(b) <- b$V1
b$V1 <- NULL
mat <- as.matrix(b)
mat[is.na(mat)] <- 0
mat <- scale(t(mat))
mat <- scale(mat)

hclc <- hclust(dist(mat, method="maximum"))
hclr <- hclust(dist(t(mat), method="maximum"))

new <- mat[hclc$order, hclr$order]

layout(matrix(c(1:2), nrow=1), widths=c(5,1))
par(mar=c(3,0.5,1,0.5), oma=c(3,3,1,2))
cols <- colorRampPalette(c("darkorchid4", "cornsilk", "forestgreen"))(100)

image(new, col=cols,axes=F)
axis(1, at=seq(from=0, to=1, length.out=nrow(new)), labels=rownames(new), las=2)
axis(2, at=seq(from=0, to=1, length.out=ncol(new)), labels=colnames(new), las=2)

image(matrix(c(1:100), nrow=1), col=cols, axes=F) 
axis(4, labels=c(signif(min(mat), digit=2), 
                 signif(median(mat), digit=2),
                 signif(max(mat), digit=2)), 
     at=c(0, 0.5, 1))
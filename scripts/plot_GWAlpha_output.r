### Plot GWAlpha output
args = commandArgs(trailingOnly=TRUE)
# args = c("test/GWAlpha_Lolium_ACC009_TERBU_out_2023_03_07-03_24_58_PM.csv", "test/Lolium_rigidum.gff", "10000", "7")
fname_input = args[1]
fname_gff = args[2]
window_bp = as.numeric(args[3])
n_chr = as.numeric(args[4])


dat = read.csv(fname_input, TRUE)
dat = dat[order(dat$X..Chromosome), ]
vec_chr = sort(unique(dat$X..Chromosome))

gff = read.delim(fname_gff, header=FALSE, sep="\t")

n = nrow(dat)
m = length(vec_chr)
if (m < n_chr) {
    n_chr = m
}
vec_colours = c("#fc8d59", "#91bfdb")

mu = mean(dat$Alpha)
sd = sd(dat$Alpha)
dat$PVAL = pnorm(abs(dat$Alpha), mu, sd, lower.tail=FALSE)
dat$LOD = -log10(dat$PVAL)
threshold = -log10(0.05/n)

MIN = aggregate(Position ~ X..Chromosome, data=dat, FUN=min)
MAX = aggregate(Position ~ X..Chromosome, data=dat, FUN=max)
dat$Scaled_positions = dat$Position
for (i in 1:m){
    idx1 = dat$X..Chromosome == vec_chr[i]
    idx2 = MIN[,1] == vec_chr[i]
    idx3 = MAX[,1] == vec_chr[i]
    dat$Scaled_positions[idx1] = (dat$Position[idx1] - MIN[idx2, 2]) / (MAX[idx3, 2] - MIN[idx2, 2])
}


png(paste0(fname_input, "-Manhattan.png"), width=2000,height=1000)
par(mfrow=c(2,2))

### Distribution of alphas
h = hist(dat$Alpha)
d = density(dat$Alpha)
d$y = ( ((d$y - min(d$y)) / (max(d$y)-min(d$y))) * (max(h$counts)-min(h$counts)) ) + min(h$counts)
lines(d$x, d$y, lwd=2)
d_norm = data.frame(x=d$x)
d_norm$y = dnorm(d$x, mu, sd)
d_norm$y = ( ((d_norm$y - min(d_norm$y)) / (max(d_norm$y)-min(d_norm$y))) * (max(h$counts)-min(h$counts)) ) + min(h$counts)
lines(d_norm$x, d_norm$y, lty=2, col="red")
legend("right", legend=paste0(formatC(n, format="d", big.mark=","), " loci"), bty="n")

### QQ plot of LOD
plot(range(dat$LOD), range(dat$LOD), type="l", col="red", lty=2, xlab="Expected", ylab="Observed")
points(x=seq(min(dat$LOD), max(dat$LOD), length=n), y=sort(dat$LOD))

### Manhattan plots
plot_manhatttan = function(X, G, vec_chr, threshold, xlab="Chromosome") {
    X$Scaled_positions_in_plot = X$Scaled_positions
    p = plot(c(0.5,length(vec_chr)+0.5), c(0,max(X$LOD)), type="n", xlab=xlab, ylab="-log10(p)")
    grid()
    for (i in 1:length(vec_chr)) {
        # i = 1
        chr = vec_chr[i]
        idx = X$X..Chromosome == chr
        X$Scaled_positions_in_plot[idx] = X$Scaled_positions[idx]+(i-0.5)
        points(X$Scaled_positions_in_plot[idx], X$LOD[idx], col=vec_colours[(i%%2)+1])
    }
    abline(h=threshold, col="red", lty=2)
    idx = X$LOD >= threshold
    if (sum(idx) > 0) {
        OUT = X[idx, ]
        OUT$Annotation = NA
        for (i in 1:nrow(OUT)) {
            # i = 1
            chr = OUT$X..Chromosome[i]
            pos = OUT$Position[i]
            idx = (G$V1 == chr) & ((G$V4-window_bp) <= pos) & ((G$V5+window_bp) >= pos)
            G_sub = G[idx, ]
            idx = G_sub$V3 == "CDS"
            G_sub = G_sub[idx, ]
            if (nrow(G_sub) > 0) {
                x = OUT$Scaled_positions_in_plot[i]
                y = OUT$LOD[i]
                for (j in 1:nrow(G_sub)) {
                    # j = 1
                    gene_id = unlist(strsplit(G$V9[idx][j], ";"))
                    gene_id = gsub("product=", "", gene_id[grepl("product", gene_id)])
                    if (length(gene_id)>0) {
                        label = paste0(gene_id, " (SNP:", pos, "; ANNOT:", G_sub$V4[j], "-", G_sub$V5[j], ")")
                        text(x, y, label=label, pos=4)
                        OUT$Annotation[i] = label
                    }
                    gene_id=""
                }
            }
        }
    } else {
        OUT = NULL
    }
    return(list(p=p, o=OUT))
}
O1 = plot_manhatttan(X=dat[dat$X..Chromosome %in% vec_chr[1:n_chr], ], G=gff, vec_chr=vec_chr[1:n_chr], threshold=threshold)
O2 = plot_manhatttan(X=dat[dat$X..Chromosome %in% vec_chr[min(c(1, n_chr+1)):m], ], G=gff, vec_chr=vec_chr[min(c(1, n_chr+1)):m], threshold=threshold, xlab="Scaffold")
dev.off()

write.table(rbind(O1$o, O2$o), gsub(".csv", "-PEAKS.csv", fname_input), sep=",", row.names=FALSE, quote=TRUE)

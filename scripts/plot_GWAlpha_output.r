### Plot GWAlpha output
args = commandArgs(trailingOnly=TRUE)
# args = c("test/GWAlpha_Lolium_URANA_GLYPH_out.csv", "test/Lolium_rigidum.gff", "1000")
# args = c("test/GWAlpha_Lolium_ACC062_GLYPH_out.csv", "test/Lolium_rigidum.gff", "1000")
fname_input = args[1]
fname_gff = args[2]
window_bp = as.numeric(args[3])


dat = read.csv(fname_input, TRUE)
dat = dat[order(dat$X..Chromosome), ]
vec_chr = sort(unique(dat$X..Chromosome))

gff = read.delim(fname_gff, header=FALSE, sep="\t")

n = nrow(dat)
m = length(vec_chr)
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
plot(dat$Alpha)
h = hist(dat$Alpha)
d = density(dat$Alpha)
d$y = ( ((d$y - min(d$y)) / (max(d$y)-min(d$y))) * (max(h$counts)-min(h$counts)) ) + min(h$counts)
lines(d$x, d$y, lwd=2)
d_norm = data.frame(x=d$x)
d_norm$y = dnorm(d$x, mu, sd)
d_norm$y = ( ((d_norm$y - min(d_norm$y)) / (max(d_norm$y)-min(d_norm$y))) * (max(h$counts)-min(h$counts)) ) + min(h$counts)
lines(d_norm$x, d_norm$y, lty=2, col="red")


# insert qqplot here
plot(range(dat$LOD), range(dat$LOD), type="l", col="red", lty=2, xlab="Expected", ylab="Observed")
points(x=seq(min(dat$LOD), max(dat$LOD), length=n), y=sort(dat$LOD))



p = m
p = 7
plot(c(0.5,p+0.5), c(0,max(dat$LOD)), type="n", xlab="Chromosome", ylab="-log10(p)")
grid()
for (i in 1:p) {
    # i = 1
    chr = vec_chr[i]
    idx = dat$X..Chromosome == chr
    points(dat$Scaled_positions[idx]+(i-0.5), dat$LOD[idx], col=vec_colours[(i%%2)+1])
}
abline(h=threshold, col="red", lty=2)
idx = dat$LOD >= threshold
if (sum(idx) > 0) {
    OUT = dat[idx, ]

    for (i in 1:nrow(OUT)) {
        # i = 1
        chr = OUT$X..Chromosome[i]
        pos = OUT$Position[i]
        idx = (gff$V1 == chr) & ((gff$V4-window_bp) >= pos) & ((gff$V5-window_bp) <= pos) & ((gff$V4+window_bp) >= pos) & ((gff$V5+window_bp) <= pos)
        if(sum(idx) > 0) {
            x = OUT$Scaled_position[i]
            y = OUT$LOD[i]
            for (j in 1:sum(idx)) {
                gene_id = unlist(strsplit(gff$V9[idx][j], ";"))
                gene_id = gene_id[grepl("product", gene_id)]
                text(x, y, label=gene_id, pos=4)
            }
        }
    }
}
dev.off()

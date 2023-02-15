### Plot GWAlpha output
args = commandArgs(trailingOnly=TRUE)
# args = c("GWAlpha_Lolium_URANA_GLYPH_out.csv")
fname_input = args[1]

dat = read.csv(fname_input, TRUE)
dat = dat[order(dat$X..Chromosome), ]
vec_chr = sort(unique(dat$X..Chromosome))

n = nrow(dat)
m = length(vec_chr)
vec_colours = c("#fc8d59", "#91bfdb")

mu = mean(dat$Alpha)
sd = sd(dat$Alpha)
dat$PVAL = pnorm(abs(dat$Alpha), mu, sd, lower.tail=FALSE)
dat$LOD = -log10(dat$PVAL)
threshold = -log10(0.05 / n)



MIN = aggregate(Position ~ X..Chromosome, data=dat, FUN=min)
MAX = aggregate(Position ~ X..Chromosome, data=dat, FUN=max)
dat$Scaled_positions = dat$Position
for (i in 1:m){
    idx1 = dat$X..Chromosome == vec_chr[i]
    idx2 = MIN[,1] == vec_chr[i]
    idx3 = MAX[,1] == vec_chr[i]
    dat$Scaled_positions[idx1] = (dat$Position[idx1] - MIN[idx2, 2]) / (MAX[idx3, 2] - MIN[idx2, 2])
}



par(mfrow=c(2,2))
plot(dat$Alpha)
plot(dat$Alpha^2)
hist(dat$Alpha)

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
OUT = dat[idx, ]

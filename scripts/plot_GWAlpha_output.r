### Plot GWAlpha output
args = commandArgs(trailingOnly=TRUE)
# args = c("test/GWAlpha_Lolium_URANA_GLYPH_out.csv", "test/Lolium_rigidum.gff")
# args = c("test/GWAlpha_Lolium_ACC031_GLYPH_out.csv", "test/Lolium_rigidum.gff")
fname_input = args[1]
fname_gff = args[2]

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

# ### Finding the best distribution to model the distribution of alpha
# # install.packages("VGAM")
# library(VGAM)
# LL_LAPLACE = function(params, x) {
#     return(sum(-log10(1e-10 + dlaplace(x, location=params[1], scale=params[2]))))
# }
# # opt = optim(par=c(0,1), fn=LL_LAPLACE, x=dat$Alpha, method="L-BFGS-B", lower=c(-100, 1e-10), upper=c(1e10, 1e10))
# opt = optim(par=c(0,1), fn=LL_LAPLACE, x=dat$Alpha)
# params = opt$par

# dat$PVAL = plaplace(dat$Alpha, location=params[1], scale=params[2])
# dat$LOD = -log10(dat$PVAL)

# pval_heur = function(x){
#     # x = dat$Alpha
#     mu = mean(x)
#     d = density(x, n=1e6)

#     x_left  = d$x[d$x < mu]
#     y_left  = d$y[d$x < mu]
#     x_right = d$x[d$x >= mu]
#     y_right = d$y[d$x >= mu]
#     dx = diff(d$x[1:2])

#     v = c(1:length(dx))
#     pval = c()
#     for (xi in x) {
#         # xi = max(x)
#         if (xi < mu) {
#             p = sum(y_left[x_left <= xi] * dx)
#         } else {
#             p = sum(y_right[x_right >= xi] * dx)
#         }
#         pval = c(pval, p)
#     }
#     # plot(-log10(pval))
#     # qqnorm(-log10(pval))
#     return(pval)
# }
# dat$PVAL = pval_heur(dat$Alpha)
# dat$LOD = -log10(dat$PVAL)
# threshold = -log10(0.05/n)



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

    window_bp = 1e3
    for (i in 1:nrow(OUT)) {
        # i = 1
        chr = OUT$X..Chromosome[i]
        pos = OUT$Position[i]
        idx = (gff$V1 == chr) & ((gff$V4-window_bp) >= pos) & ((gff$V5-window_bp) <= pos) & ((gff$V4+window_bp) >= pos) & ((gff$V5+window_bp) <= pos)
        print(sum(idx))
    }
}

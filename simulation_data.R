n <- 10000
X <- rnorm(n)
Y <- 2*X + 3
ref <- c("A","B","C","D","E")
R <- ref[sample(length(ref), n, replace=T)]
std <- c(0.75, 3, 1, 2, 0.5)

for(i in ref){
  Y[R==i]<- Y[R==i]+rnorm(length(Y[R==i]),0,std[ref==i])
}

d <- data.frame(R,X,Y)
table(d$R)

par(mfrow=c(2,3))

for(i in ref){
  plot(d$X[d$R==i],d$Y[d$R==i], xlab="X", ylab="Y", main=paste("R =",i))
}
plot(d$X, d$Y, xlab="X", ylab="Y", main="All")

for(i in ref){
  print(paste(i,":",summary(lm(d$Y[d$R==i] ~ d$X[d$R==i]))$adj.r.squared))
}

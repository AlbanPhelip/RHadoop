#### Simulation des données ####
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

#### Représentation des données ####
par(mfrow=c(2,3))

for(i in ref){
  plot(d$X[d$R==i],d$Y[d$R==i], xlab="X", ylab="Y", main=paste("R =",i), col="blue", pch=46)
}
plot(d$X, d$Y, xlab="X", ylab="Y", main="All", col="blue", pch=46)

#### Sauvegarde des données ####
write.table(d, "/home/root/big_data_simulated.csv", sep=" ", col.names=F, row.names=F)
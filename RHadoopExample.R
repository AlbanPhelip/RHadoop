#### RHadoop ####

#### Simulation des données ####
n <- 10000
X <- rnorm(n)
Y <- 2*X + 3
ref <- c("A","B","C","D","E")
R <- ref[sample(length(ref), n, replace=T)]
std <- c(0.75, 3, 1, 2, 0.5)
 
for(i in ref){
  Y[R==i] <- Y[R==i] + rnorm(length(Y[R==i]),0,std[ref==i])
}
 
d <- data.frame(R,X,Y)
table(d$R)
 
write.table(d, "/home/uccqsm/big_data_simulated.csv", sep=" ", col.names=F, row.names=F)
 
#### Copie des données dans HDFS ####
# A lancer depuis bash
hdfs dfs -copyFromLocal /home/uccqsm/big_data_simulated.csv  /user/root
 
#### RHadoop ####
library(rmr2)
library(rhdfs)
hdfs.init()
path <- "/user/root/big_data_simulated.csv"
col.classes <- c(R="factor", X="double", Y="double")
format <- make.input.format("csv", sep=" ", col.names = names(col.classes), colClasses = col.classes)
dataMR <- mapreduce(path, input.format = format)
 
 
# Nombre de lignes en fonction de R
test = mapreduce(
    dataMR,
    map = function(k, v)
            keyval(v$R, 1),
    reduce = function(k, v)
            cbind(R = k, nbLignes = sum(v)))
from.dfs(test)
 
 
# Moyenne de X et Y en fonction de R
test = mapreduce(
    dataMR,
    map = function(k, v)
            keyval(v$R, data.frame(v$X,v$Y)),
    reduce = function(k, v)
            cbind(R = k, X = mean(v$v.X), Y = mean(v$v.Y)))
from.dfs(test)
 
# Régression linéaire
test = mapreduce(
    dataMR,
    map = function(k, v)
            keyval(v$R, data.frame(v$X,v$Y)),
    reduce = function(k, v)
            cbind(R = k, R2 = summary(lm(v$v.Y ~ v$v.X))$adj.r.squared) )
from.dfs(test)
 
 
 
#### Comparaison données en local ####
data <- read.table("/home/uccqsm/big_data_simulated.csv", header=F)
ref <- c("A","B","C","D","E")
for(i in ref){
               print(paste(i, mean(data[data[,1]==i,3])))
}
 
for(i in ref){
               print(paste(i, nrow(data[data[,1]==i,])))
}
 
# Régression
colnames(data) <- c("R", "X", "Y")
for(i in ref){
  print(paste(i,":",summary(lm(data$Y[data$R==i] ~ data$X[data$R==i]))$adj.r.squared))
}
 
 
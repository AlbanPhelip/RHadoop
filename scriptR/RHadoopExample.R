 ###################
 ####  RHadoop  ####
 ###################
 #### Import des librairies et définition du modèle de données ####
library(rmr2)
library(rhdfs)
hdfs.init()
path <- "/user/root/big_data_simulated.csv"
col.classes <- c(R="factor", X="double", Y="double")
format <- make.input.format("csv", sep=" ", col.names = names(col.classes), colClasses = col.classes)
 
 
##### Nombre de lignes en fonction de R ####
# Fonction map()
map = function(k, v){
  keyval(v$R, 1)
}

# Fonction reduce
reduce = function(k, v){
  cbind(R = k, nbLignes = sum(v))
}

# Fonction mapreduce
nbLignes = mapreduce(
    input = path,
    input.format = format,
    map = map,
    reduce = reduce)

from.dfs(nbLignes)
 
 
#### Régression linéaire ####
# Fonction map()
map = function(k, v){
  keyval(v$R, data.frame(v$X,v$Y))
}

# Fonction reduce
reduce = function(k, v){
  model <- lm(v$v.Y ~ v$v.X)
  r2 <- summary(model)$r.squared
  cbind(R = k, R2 = r2)
}

# Fonction mapreduce
r2 = mapreduce(
    input = path,
    input.format = format,
    map = map,
    reduce = reduce)
from.dfs(r2)

#### Méthode plus courte ####
# Nombre de lignes
nbLignes = mapreduce(
    input = path,
    input.format = format,
    map = function(k, v)
            keyval(v$R, 1),
    reduce = function(k, v){
              cbind(R = k, nbLignes = sum(v))
from.dfs(nbLignes)

# Régression linéaire
r2 = mapreduce(
    input = path,
    input.format = format,
    map = function(k, v)
            keyval(v$R, data.frame(v$X,v$Y)),
    reduce = function(k, v){
              cbind(R = k, R2 = summary(lm(v$v.Y ~ v$v.X))$r.squared) )
from.dfs(nbLignes)


 
#### Comparaison des résultats avec les données en local, directement depuis R ####
# Lecture des données
data <- read.table("/home/root/big_data_simulated.csv", header=F)

# On renome les colonnes de notre table
colnames(data) <- c("R", "X", "Y")

# On récupère les modalités de la variable R (A, B, C, D et E)
ref <- levels(as.factor(data$R))


# Régression
for(i in ref){
  Y <- data$Y[data$R==i] # On récupère les valeurs de X qui nous intéressent
  X <- data$X[data$R==i] # On récupère les valeurs de Y qui nous intéressent
  model <- lm(Y ~ X) # On construit le modèle
  r2 <- summary(model)$r.squared # On récupère le R2
  print(paste(i,":",r2)) # On l’imprime
}
 
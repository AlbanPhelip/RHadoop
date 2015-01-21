# R
sudo yum install R

# RStudio
sudo yum install openssl098e # Required only for RedHat/CentOS 6 and 7
wget http://download2.rstudio.org/rstudio-server-0.98.1091-x86_64.rpm
sudo yum install --nogpgcheck rstudio-server-0.98.1091-x86_64.rpm

# Télécharger rhdfs et rmr2
wget 'http://goo.gl/Y5ytsm'
mv Y5ytsm rmr2.tar.gz
wget 'https://github.com/RevolutionAnalytics/rhdfs/blob/master/build/rhdfs_1.0.8.tar.gz?raw=true'
mv rhdfs_1.0.8.tar.gz\?raw\=true rhdfs_1.0.8.tar.gz

# Installer rmr2 et rhdfs
R # Lancement de R
install.packages(c("Rcpp","RJSONIO","bitops","digest","functional","reshape2",
	"stringr","plyr","caTools", "rJava")) # A lancer dans l'invite de commande R
q() # Pour quitter R

R CMD INSTALL rmr2.tar.gz
R CMD INSTALL rhdfs_1.0.8.tar.gz

# Réglages des configurations
nano ~/.bashrc
# Dans le fichier bashrc, rajouter :
export HADOOP_CMD=/usr/bin/hadoop
export HADOOP_STREAMING=/usr/lib/hadoop/hadoop-streaming-1.1.2.21.jar

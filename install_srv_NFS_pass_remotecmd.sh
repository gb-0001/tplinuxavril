#!/bin/bash
#script de finalisation d'install sur les serveurs distant lié à l'install de base installsrv_NFS.sh

#Parametre
SRVINTEGRATION=192.168.0.19
SRVWEB=192.168.0.17
SRVNFS=192.168.0.18
LOGINUSER=vagrant
PASSUSER=vagrant

BACKUPDIR=/backup
BACKUP_WEB_DIR=/web
BACKUPWEB_FILENAME=serveur_web
NFSWEB_MOUNTDIR=$BACKUP_WEB_DIR
SOURCE_WEB_DIR=/var/www/html
DESTINATION_WEB_BACKUP=$BACKUPDIR$BACKUP_WEB_DIR
BACKUP_JENKINS_DIR=/server_ic
BACKUPJENKINS_FILENAME=serveur_ic
NFSJENKINS_MOUNTDIR=$BACKUP_JENKINS_DIR
SOURCE_JENKINS_DIR=/usr/local/jenkins
DESTINATION_JENKINS_BACKUP=$BACKUPDIR$BACKUP_JENKINS_DIR

#Fonction FXAUTOFS_BACKUPCRON Mise en place du montage automatique avec autofs sur le serveur et planification de la sauvegarde 1x par Heure et retention sur 7j
#parametre fonction
#$1 ==> exemple $BACKUPDIR
#$2 ==> exemple $BACKUP_WEB_DIR
#$3 ==> exemple $SRVNFS
#$4 ==> exemple $NFSWEB_MOUNTDIR
#$5 ==> exemple $SOURCE_WEB_DIR
#$6 ==> exemple $DESTINATION_WEB_BACKUP
#$7 ==> exemple $BACKUPWEB_FILENAME

FXAUTOFS_BACKUPCRON () {
    sudo apt -y update
    export DEBIAN_FRONTEND=noninteractive
    sudo apt -y install autofs
    sudo mkdir -p $1/$2
    sudo sh -c "echo '$1    /etc/auto.nas --timeout 60' >> /etc/auto.master"
    sudo sh -c "echo '$2  -rw,soft,intr,rsize=8192,wsize=8192 $3:$4' >> /etc/auto.nas"
    sudo chmod 644 /etc/auto.nas
    sudo service autofs restart
    YEAR=`date +%Y`
    MONTH=`date +%m`
    DAY=`date +%d`
    sudo sh -c "echo '* */1 * * * tar cvzfP $5 $6/$7_$DAY_$MONTH_$YEAR.tar.gz ' >> /var/spool/cron/crontabs/vagrant"
    sudo sh -c "echo '15 4 * * * find $6 -name "*.tar.gz" -type f -mtime +7 -exec rm -f {} +' >> /var/spool/cron/crontabs/vagrant"
}

#Recupere l'ip de la machine afin de vérifier si c'est le bon serveur et pour la bonne fonction parametré
LOCALIP=$(sudo ip a s eth1 | awk -F: '/inet / {print $1}' | awk '{ print $2 }' | sed 's/\/24//')

if [[ $LOCALIP = $SRVWEB ]]
then
    #Mise en place du montage automatique avec autofs sur le serveur web et planification de la sauvegarde 1x par Heure et retention sur 7j
    FXAUTOFS_BACKUPCRON $BACKUPDIR $BACKUP_WEB_DIR $SRVNFS $NFSWEB_MOUNTDIR $SOURCE_WEB_DIR $DESTINATION_WEB_BACKUP $BACKUPWEB_FILENAME
elif [[ $LOCALIP = $SRVINTEGRATION ]]
then
    #Mise en place du montage automatique sur le serveur d'integration et planification de la sauvegarde 1x par Heure et retention sur 7j
    FXAUTOFS_BACKUPCRON $BACKUPDIR $BACKUP_JENKINS_DIR $SRVNFS $NFSJENKINS_MOUNTDIR $SOURCE_JENKINS_DIR $DESTINATION_JENKINS_BACKUP $BACKUPJENKINS_FILENAME
else
    echo "Verifier les parametres IP du script"
fi

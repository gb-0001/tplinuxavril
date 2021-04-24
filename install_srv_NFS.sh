#!/bin/bash
#script d'installation du serveur NFS

#Parametre
SRVINTEGRATION=192.168.0.19
SRVWEB=192.168.0.17
SRVNFS=192.168.0.18
LOGINUSER=vagrant
PASSUSER=vagrant

#mise en place du mot de passe pour vagrant
echo 'vagrant:vagrant' | sudo chpasswd

#Install du serveur NFS
sudo apt install -y nfs-kernel-server

#Activation du service au demarrage
sudo systemctl enable --now nfs-server.service

#création des dossiers pour l'accès aux points de montage depuis le distant
sudo mkdir /web
sudo mkdir /server_ic

#configuration du server NFS pour les 2 points de montage
sudo echo "/web  $SRVWEB(rw,all_squash,anonuid=1000,anongid=1000,sync)" >> /etc/exports
sudo echo "/server_ic  $SRVINTEGRATION(rw,all_squash,anonuid=1000,anongid=1000,sync)" >> /etc/exports

#prise en compte des modifications nfs
sudo service nfs-kernel-server reload

#generation de la cle ssh
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

#install sshpass pour le bypass du password et copie de la cle sur la machine distante
sudo apt -y install sshpass
/usr/bin/sshpass -p $PASSUSER ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $LOGINUSER@$SRVINTEGRATION
/usr/bin/sshpass -p $PASSUSER ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $LOGINUSER@$SRVWEB

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
#$1 ==> exemple $LOGINUSER
#$2 ==> exemple $SRVWEB
#$3 ==> exemple $BACKUPDIR
#$4 ==> exemple $BACKUP_WEB_DIR
#$5 ==> exemple $SRVNFS
#$6 ==> exemple $NFSWEB_MOUNTDIR
#$7 ==> exemple $SOURCE_WEB_DIR
#$8 ==> exemple $DESTINATION_WEB_BACKUP
#$9 ==> exemple $BACKUPWEB_FILENAME

FXAUTOFS_BACKUPCRON () {
ssh -t $1@$2 << EOF
sudo apt -y install autofs
sudo mkdir $3
sudo echo "$3    /etc/auto.nas --timeout 60" >> /etc/auto.master
echo "$4  -rw,soft,intr,rsize=8192,wsize=8192 $5:$6" >> /etc/auto.nas
sudo chmod 644 /etc/auto.nas
sudo service autofs reload
YEAR=date +%Y && MONTH=date +%m && DAY=date +%d
echo "* */1 * * * tar cvzfP $7 $8/$9_$DAY_$MONTH_$YEAR.tar.gz " >> /var/spool/cron/crontabs/vagrant
echo "15 4 * * * find $8 -name "*.tar.gz" -type f -mtime +7 -exec rm -f {} +" >> /var/spool/cron/crontabs/vagrant
EOF
}

#Mise en place du montage automatique avec autofs sur le serveur web et planification de la sauvegarde 1x par Heure et retention sur 7j
FXAUTOFS_BACKUPCRON $LOGINUSER $SRVWEB $BACKUPDIR $BACKUP_WEB_DIR $SRVNFS $NFSWEB_MOUNTDIR $SOURCE_WEB_DIR $DESTINATION_WEB_BACKUP $BACKUPWEB_FILENAME

#Mise en place du montage automatique sur le serveur d'integration et planification de la sauvegarde 1x par Heure et retention sur 7j
FXAUTOFS_BACKUPCRON $LOGINUSER $SRVINTEGRATION $BACKUPDIR $BACKUP_JENKINS_DIR $SRVNFS $NFSJENKINS_MOUNTDIR $SOURCE_JENKINS_DIR $DESTINATION_JENKINS_BACKUP $BACKUPJENKINS_FILENAME

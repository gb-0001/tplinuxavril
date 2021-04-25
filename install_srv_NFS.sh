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
sudo chown -R nobody:nogroup /web
sudo chmod 777 /web
sudo mkdir /server_ic
sudo chown -R nobody:nogroup /server_ic
sudo chmod 777 /server_ic

#configuration du server NFS pour les 2 points de montage
sudo sh -c "echo '/web  $SRVWEB(rw,sync,no_subtree_check)' >> /etc/exports"
sudo sh -c "echo '/server_ic  $SRVINTEGRATION(rw,sync,no_subtree_check)' >> /etc/exports"

#prise en compte des modifications nfs
sudo sudo exportfs -a
sudo service nfs-kernel-server restart

#generation de la cle ssh
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

#install sshpass pour le bypass du password et copie de la cle sur la machine distante
sudo apt -y install sshpass
/usr/bin/sshpass -p $PASSUSER ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $LOGINUSER@$SRVINTEGRATION
/usr/bin/sshpass -p $PASSUSER ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $LOGINUSER@$SRVWEB

#Mise en place du montage automatique avec autofs sur le serveur et planification de la sauvegarde 1x par Heure et retention sur 7j
ssh $LOGINUSER@$SRVWEB 'bash -s' < install_srv_NFS_pass_remotecmd.sh
ssh $LOGINUSER@$SRVINTEGRATION 'bash -s' < install_srv_NFS_pass_remotecmd.sh
#!/bin/bash

#MAJ de la liste des packages et installation du serveur web
sudo apt -y update
sudo apt -y install apache2

#chemin du site web
HTMLPATH=/var/www/html
#GROUPE WEB
GROUPEWEB=www-data

#sources
INDEXPATH=sources
sudo cp $INDEXPATH/index.html $HTMLPATH/index.html

#Positionnement du groupe en recursif pour $HTMLPATH et des droits lecture/ecriture proprietaire + groupe
sudo chown -R $GROUPEWEB $HTMLPATH
sudo chmod -R 770 $HTMLPATH

#Demarrage du service apache2 si non demarre
sudo service apache2 restart

#installation et configuration du firewall iptables-persistent sinon les regles ne sont pas positionne au reboot os
sudo apt -y install iptables iptables-persistent
#configuration de l'acces ssh
sudo iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 22 -j ACCEPT
#configuration de l'acces web
sudo iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 443 -j ACCEPT
#DROP de tous les autres flux entrant
sudo iptables -P INPUT DROP
#sauvegarde des regles
sudo mkdir -p /etc/iptables/
sudo /sbin/iptables-save | sudo tee /etc/iptables/rules.v4






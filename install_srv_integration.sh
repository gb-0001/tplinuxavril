#!/bin/bash
#script d'installation du serveur d'integration

dpkg -l | grep jenkins
if [ $? = 0 ]; then
    echo "Serveur intégration déjà installé"
    exit 0
fi

#creation de la partition sdb en ext4
(echo n
echo p
echo
echo
echo
echo t
echo
echo 83
echo w)| sudo fdisk /dev/sdb
sudo mkfs.ext4 /dev/sdb1

#creation du point de montage duf
sudo mkdir /duf
sudo mount /dev/sdb1 /duf

#mise en place du mot de passe pour vagrant
echo 'vagrant:vagrant' | sudo chpasswd

## Install des pré-requis Java
sudo apt -y update
sudo apt -y install gnupg
sudo apt -y install openjdk-11-jdk
## Install de la version stable de Jenkins et ses prérequis en suivant la documentation officielle : https://www.jenkins.io/doc/book/installing/linux
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

#install jenkins
sudo apt -y update
sudo apt -y install jenkins

## Démarre le service Jenkins
sudo service start jenkins

#creation user userjob et son password
echo -e "\n" |sudo useradd -s /bin/bash -d /duf/userjob -m -G sudo userjob
echo 'userjob:userjob' | sudo chpasswd

#positionnement dans le sudoers pour l'utilisation d'apt pour userjob
echo 'userjob ALL=(ALL:ALL) /usr/bin/apt' | sudo EDITOR='tee -a' visudo

#installation et configuration du firewall
sudo apt -y install iptables

#pour le bypass de la fenetre de dialogue iptables-persistent
sudo debconf-set-selections <<EOF
iptables-persistent iptables-persistent/autosave_v4 boolean true
iptables-persistent iptables-persistent/autosave_v6 boolean true
EOF

#installation et configuration du firewall iptables-persistent sinon les regles ne sont pas positionne au reboot os
sudo apt -y install iptables-persistent
#reglage de la police par defaut
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD DROP

# pour autoriser tous les paquets de données entrants ou sortants appartenant à une connexion existante ou s’y référant
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
#configuration de l'acces ssh
sudo iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
#configuration de l'acces web
sudo iptables -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT

#sauvegarde des regles
sudo mkdir -p /etc/iptables/
sudo /sbin/iptables-save | sudo tee /etc/iptables/rules.v4

#Preparation pour l'echange de clé ssh et restart du service pour prise en compte
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart

#Temporisation le temps que le mot de passe soit généré
echo "Génération de la clé dans 1min:"
sleep 1m
#Affiche le password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#!/bin/bash
#script d'installation d'un poste devellopeur

#Parametre
SRVINTEGRATION=192.168.0.19
LOGINUSER=userjob
PASSUSER=userjob

#mise en place du mot de passe pour vagrant
echo 'vagrant:vagrant' | sudo chpasswd

## Install des pkg python3, python3-pip, python3-dev, git
sudo apt -y update
sudo apt -y install python3 python3-pip python3-dev git

#installation de vscode
sudo apt -y install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt -y update
sudo apt -y install code

#generation de la cle ssh
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

#install sshpass pour le password et copie de la cle sur la machine distante
sudo apt -y install sshpass
/usr/bin/sshpass -p $PASSUSER ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $LOGINUSER@$SRVINTEGRATION

#install virtualbox
#ajout des clés repo
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
#ajout des repos virtualbox
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
#install virtualbox + extension pack
sudo apt -y update
sudo apt -y install linux-headers-$(uname -r) dkms
sudo apt -y install virtualbox-6.1

#install vagrant
cd /tmp && curl -O https://releases.hashicorp.com/vagrant/2.2.15/vagrant_2.2.15_x86_64.deb
cd /tmp && sudo apt -y install ./vagrant_2.2.15_x86_64.deb

#clone du git
cd ~ && git clone https://github.com/vanessakovalsky/example-python.git

#install du package corbeille.deb
sudo dpkg -i /tmp/corbeille_1.0.0.deb
sudo rm -f /tmp/corbeille_1.0.0.deb


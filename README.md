**1 - Faire un git clone**
```shell
Créer un dossier et se positionner avec git bash dedans puis:
git clone https://github.com/gb-0001/tplinuxavril.git
puis se positionner dans tplinuxavril/vagrant/*MAVM* à remplacer avec le bon nom ci-dessous pour faire le vagrant up:

```

*Prérequis:*
- Avoir installé git bash et vagrant
- Ne pas avoir de vm vagrant déjà installé avec les mêmes ports en forward(8080,8081,8082) virtualbox sinon changer celle des vm virtualbox des autres vm déjà présente le temps de la vérification.

Dans le dossier vagrant faire un vagrant up pour tous les hosts ci-dessous puis sont à démarrer et suivre l'ordre d'installation ci-dessous:

L'utilisateur utilisé est vagrant et sont password vagrant.

*Plan d'adressage IP préconfiguré dans les vagrantfile du git clone et ordre d'installation suivant:*
1. serveur web 192.168.0.17             ==> remplacer *MAVM* par: srvweb
2. serveur integration 192.168.0.19     ==> remplacer *MAVM* par: srvintegration
3. serveur NFS 192.168.0.18             ==> remplacer *MAVM* par: srvnfs
4. pc dev 1 192.168.0.20                ==> remplacer *MAVM* par: pcdev1
5. pc dev 2 192.168.0.21                ==> remplacer *MAVM* par: pcdev2
6. pc dev 3 192.168.0.22                ==> remplacer *MAVM* par: pcdev3


- Une fois positionner dans le chemin du git clone au niveau tplinuxavril/vagrant/*MAVM*, ADAPTER LE CHEMIN POUR CHAQUE VM.
- faire clic droit git bash here ou se situ le vagrantfile exemple tplinuxavril/vagrant/*MAVM*/vagrantfile
- git bash ouvert, faire sur les 6 hosts ci-dessus:
```shell
vagrant up
```



**Installation pour chaque type de machine:**

**2 - A partir du git clone pour le serveur web avec vagrant ssh faire:**
```shell
Dans le git bash du /tplinuxavril/vagrant/srvweb préalablement ouvert faire:
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
Executer la ligne de commande suivante une fois connecté en vagrant ssh:
cd /tmp && wget -O install_srv_web.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_web.sh && /bin/bash install_srv_web.sh
```

TEST DE FONCTIONNEMENT:
```shell
Dans le git bash du /tplinuxavril/vagrant/srvweb préalablement ouvert faire:
vagrant ssh
Vérification si le package est installé un ii doit etre présent en début de ligne:
dpkg -l | grep apache2
Retour atendu:
ii  apache2                       2.4.38-3+deb10u4             amd64        Apache HTTP Server

Vérifier les droits:
sudo ls -l /var/www/html
Attendu pour les droits et www-data pour le groupe:
-rwxrwx--- 1 www-data root 657 Apr 25 15:40 index.html

```
- Vérifier le fonctionnement ouvrir le navigateur et saisir http://127.0.0.1:8080/ vérifier si la page du site apparait.


**3 - A partir du git clone pour le serveur d'integration avec vagrant ssh faire:**
```shell
Dans le git bash du /tplinuxavril/vagrant/srvintegration préalablement ouvert faire pour vérifier la connexion:
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
Executer la ligne de commande suivante une fois connecté en vagrant ssh:
cd /tmp && wget -O install_srv_integration.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_integration.sh && /bin/bash install_srv_integration.sh
```
TEST DE FONCTIONNEMENT:
- Vérifier le fonctionnement jenkins ouvrir le navigateur: et saisir http://127.0.0.1:8081/
- Vérifier le mot de passe sur l'url qui est affiché en fin d'installation exemple a699fb3219944147a39bbdaa7a80da8f ce mot passe peut etre saisi pour vérifier le fonctionnement

**4 - A partir du git clone pour le serveur NFS avec vagrant ssh faire:**
```shell
Dans le git bash du /tplinuxavril/vagrant/srvnfs préalablement ouvert faire:
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
Executer la ligne de commande suivante une fois connecté en vagrant ssh:
cd /tmp && wget -O install_srv_NFS.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS.sh && /bin/bash install_srv_NFS.sh
```

TEST DE FONCTIONNEMENT:
Dans le git bash, vagrant ssh du serveur web préalablement ouvert.
Vérifier si les 2 lignes sont présentes dans la crontab faire:
```shell
crontab -l
Lignes attendus:
* */1 * * * tar cvzfP /var/www/html /backup/web/serveur_web_2021.tar.gz
15 4 * * * find /backup/web -name *.tar.gz -type f -mtime +7 -exec rm -f {} +
```

Puis vérification sur le fonctionnemnt de l'acces au partage à partir du serveur web faire:
```shell
touch /backup/web/test.txt
```

Se connecter avec git bash vagrant ssh sur le serveur nfs et vérifier si le fichier créé est présent dans /web
```shell
ls -l /web
```

Dans le git bash, vagrant ssh du serveur d'intégration préalablement ouvert.
Vérification si les 2 lignes sont présentes dans la crontab faire:
```shell
crontab -l
Lignes attendus:
* */1 * * * tar cvzfP /usr/local/jenkins /backup/server_ic/serveur_ic_2021.tar.gz
15 4 * * * find /backup/server_ic -name *.tar.gz -type f -mtime +7 -exec rm -f {} +
```
Puis vérification sur le fonctionnemnt de l'acces au partage à partir du serveur d'integration faire:
```shell
touch /backup/server_ic/test.txt
```

Se connecter avec vagrant ssh sur le serveur nfs et vérifier dans /server_ic
```shell
ls -l /server_ic
```


**5 - A partir du git clone pour chacune des machines de DEV avec vagrant ssh et faire pour chacune l'install ci-dessous:**
```shell
Dans le git bash du  /tplinuxavril/vagrant/pcdev(1/2/3)  préalablement ouvert faire:
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
Executer la ligne de commande suivante une fois connecté en vagrant ssh:
cd /tmp && wget -O install_dev.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_dev.sh && /bin/bash install_dev.sh
```

TEST DE FONCTIONNEMENT:
Puis vérification sur le fonctionnemnt des outils à partir du pcdev1 faire:
```shell
Les commandes suivantes après \"vagrant@dev01:~/example-python$\" doivent retourner les versions:
vagrant@dev01:~/example-python$ python --version
Python 2.7.16

vagrant@dev01:~/example-python$ pip3 --version
pip 18.1 from /usr/lib/python3/dist-packages/pip (python 3.7)

vagrant@dev01:~/example-python$ git --version
git version 2.20.1

vagrant@dev01:~/example-python$ code --version
1.55.2
3c4e3df9e89829dce27b7b5c24508306b151f30d
x64

vagrant@dev01:~/example-python$ vagrant --version
Vagrant 2.2.15

Test de connexion ssh sans mot de passe vers le serveur integration le prompt doit retourner son nom srvintegration:
ssh 192.168.0.18
Faire exit pour revenir sur le pcdev1


Vérification si le package est installé un ii doit etre présent en début de ligne:
dpkg -l | grep corbeille
Retour atendu:
ii  corbeille                      1.0.0                        all          simuler les fonctionnements d\'une corbeille

Test de fonctionnement corbeille.sh et vérification du package corbeille.deb :
cd ~/
touch test1.txt test2.txt
Verifie la liste des fichiers dans la corbeille doit etre vide
/bin/bash corbeille.sh TRASH
/bin/bash corbeille.sh RM test1.txt

Verifie la liste des fichiers dans la corbeille doit avoir test1.txt et repérer le numero de ligne pour la restauration
/bin/bash corbeille.sh TRASH
et le fichier a été déplacé de ~/test1.txt ver ~/corbeille/test1.txt
ls -l ~/
ls -l ~/corbeille
Restauration du fichier dans ~/
/bin/bash corbeille.sh RESTORE
ls -l ~/
ls -l ~/corbeille

Test du vagrant up :
cd ~/example-python
vagrant plugin install vagrant-libvirt && vagrant plugin install vagrant-mutate
vagrant up --provider=libvirt
vagrant ssh
Faire:
python main.py

Message attendu avec Bien joué

```

**1 - Faire un git clone**
```shell
git clone https://github.com/gb-0001/tplinuxavril.git
```

Dans le dossier vagrant faire un vagrant up pour tous les hosts ci-dessous puis sont à démarrer et suivre l'ordre d'installation ci-dessous:

L'utilisateur utilisé est vagrant et sont password vagrant.

*Plan d'adressage IP préconfiguré dans les vagrantfile du git clone et ordre d'installation suivant:*
1. serveur web 192.168.0.17
2. serveur integration 192.168.0.19
3. serveur NFS 192.168.0.18
4. pc dev 1 192.168.0.20
5. pc dev 2 192.168.0.21
6. pc dev 3 192.168.0.22

*Prérequis:*
- Avoir installé git bash et vagrant


Exemple se connecter sur les machines *SERVEUR* remplacer par srvweb, srvintegration, srvnfs...:
- Dans l'explorateur se positionner dans le chemin du git clone au niveau tplinuxavril/vagrant/*SERVEUR*
- faire clic droit git bash here ou se situ le vagrantfile exemple tplinuxavril/vagrant/*SERVEUR*/vagrantfile
- une fois le git bash ouvert faire sur les 6 hosts ci-dessus:
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
cd /tmp && mkdir sources && cd sources && wget -O index.html https://github.com/gb-0001/tplinuxavril/raw/master/sources/index.html && cd /tmp && wget -O install_srv_web.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_web.sh && /bin/bash install_srv_web.sh
```

TEST DE FONCTIONNEMENT:
- Vérifier le fonctionnement ouvrir le navigateur et saisir http://127.0.0.1:8080/ vérifier si la page du site apparait.


**3 - A partir du git clone pour le serveur d'integration avec vagrant ssh faire:**
```shell
Dans le git bash du /tplinuxavril/vagrant/srvintegration préalablement ouvert faire:
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
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
cd /tmp && wget -O install_srv_NFS_pass_remotecmd.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS_pass_remotecmd.sh && wget -O install_srv_NFS.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS.sh && /bin/bash install_srv_NFS.sh
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
cd /tmp && wget -O corbeille_1.0.0.deb https://github.com/gb-0001/tplinuxavril/raw/master/sources/corbeille_1.0.0.deb && wget -O install_dev.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_dev.sh && /bin/bash install_dev.sh
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

Test de fonctionnement corbeille.sh et vérification du package corbeille.deb :
Vérification si le package est installé un ii doit etre présent en début de ligne:
dpkg -l | grep corbeille
cd ~/
touch test1.txt test2.txt
Verifie la liste des fichiers dans la corbeille doit etre vide
/bin/bash corbeille.sh TRASH
/bin/bash corbeille.sh RM test1.txt
Verifie la liste des fichiers dans la corbeille doit avoir test1.txt et repérer le numero de ligne pour la restauration
/bin/bash corbeille.sh TRASH
et le fichier a été déplacer de ~/test1.txt ver ~/corbeille/test1.txt
ls -l ~/
ls -l ~/corbeille
Restauration du fichier dans ~/
/bin/bash corbeille.sh RESTORE
ls -l ~/
ls -l ~/corbeille

Test du vagrant up (NE fonctionnera pas nécessite une configuration windows 10 soft et hardware particulière lié au vt-x et le nested + hyperv + config dans le vagrantfile sous windows du nested-hw-virt = on cf erreur VT-x ci-dessous):
cd ~/exemple-python
vagrant up
vagrant ssh
Faire:
python main.py


ERREUR VT-X:
Stderr: VBoxManage: error: Cannot enable nested VT-x/AMD-V without nested-paging and unresricted guest execution!
```


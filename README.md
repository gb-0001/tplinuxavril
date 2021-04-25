**1 - Faire un git clone**
```shell
git clone https://github.com/gb-0001/tplinuxavril.git
```

Dans le dossier vagrant faire un vagrant up pour tous les hosts ci-dessous puis sont à démarrer et suivre l'ordre d'installation ci-dessous:

Faire le vagrant up à partir du git clone dans le sous dossier vagrant/leserveur les ip sont préconfigurés
*Plan d'adressage IP et ordre de démarrage suivant:*
1. serveur web 192.168.0.17
2. serveur integration 192.168.0.19
3. serveur NFS 192.168.0.18
4. pc dev 1 192.168.0.20
5. pc dev 2 192.168.0.21
6. pc dev 3 192.168.0.22

Se connecter sur les machines avec vagrant ssh en se positionnant sur le dossier de l'arborescence du git clone exemple tplinuxavril/vagrant/*SERVEUR* respectif où se situ le vagrantfile des hosts.

```shell
cd /tplinuxavril/vagrant/srvweb
vagrant up
```


**Installation pour chaque type de machine:**

**2 - A partir du git clone pour le serveur web avec vagrant ssh faire:**
```shell
cd /tplinuxavril/vagrant/srvweb
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && mkdir sources && cd sources && wget -O index.html https://github.com/gb-0001/tplinuxavril/raw/master/sources/index.html && cd /tmp && wget -O install_srv_web.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_web.sh && /bin/bash install_srv_web.sh
```

Vérifier le fonctionnement ouvrir le navigateur et saisir http://127.0.0.1:8080/


**3 - A partir du git clone pour le serveur d'integration avec vagrant ssh faire:**
```shell
cd /tplinuxavril/vagrant/srvintegration
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && wget -O install_srv_integration.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_integration.sh && /bin/bash install_srv_integration.sh
```

Vérifier le fonctionnement jenkins ouvrir le navigateur: et saisir http://127.0.0.1:8081/
Vérifier le mot de passe affiché en fin d'installation ex a699fb3219944147a39bbdaa7a80da8f

**4 - A partir du git clone pour le serveur NFS avec vagrant ssh faire:**
```shell
cd /tplinuxavril/vagrant/srvnfs
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && wget -O install_srv_NFS_pass_remotecmd.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS_pass_remotecmd.sh && wget -O install_srv_NFS.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS.sh && /bin/bash install_srv_NFS.sh
```

**5 - A partir du git clone pour chacune des machines de DEV avec vagrant ssh et faire pour chacune l'install ci-dessous:**
```shell
cd /tplinuxavril/vagrant/pcdev(1)
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && wget -O install_dev.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_dev.sh && /bin/bash install_dev.sh
```

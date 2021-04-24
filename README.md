**1 - Faire un git clone**
```shell
git clone https://github.com/gb-0001/tplinuxavril.git
```

Dans le dossier vagrant faire un vagrant up pour tous les hosts ci-dessous puis sont à démarrer et suivre l'ordre d'installation ci-dessous:

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

Exemple:
**tplinuxavril**
	|-----**vagrant**
			|-----------**srvweb**
			|-----------srvintegration
			|-----------srvnfs
			|-----------pcdev1
			|-----------pcdev2
			|-----------pcdev3


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

**3 - A partir du git clone pour le serveur d'integration avec vagrant ssh faire:**
```shell
cd /tplinuxavril/vagrant/srvintegration
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && wget -O install_srv_integration.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_integration.sh && /bin/bash install_srv_integration.sh
```

**4 - A partir du git clone pour le serveur NFS avec vagrant ssh faire:**
```shell
cd /tplinuxavril/vagrant/srvnfs
vagrant ssh
```
puis recupération depuis le github et execution de l'installation en console de la vm vagrant:
```shell
cd /tmp && wget -O install_srv_NFS.sh https://github.com/gb-0001/tplinuxavril/raw/master/install_srv_NFS.sh && /bin/bash install_srv_NFS.sh
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

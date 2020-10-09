# Services systemd

## 1. Intro

afficher le nombre de services systemd dispos sur la machine :

```
systemctl list-units --all --type=service | grep "units listed"| cut -d' ' -f1
```

afficher le nombre de services systemd actifs ("running") sur la machine :

```
systemctl list-units --all --type=service --state=running | grep "units listed" | cut -d' ' -f1"
```

afficher le nombre de services systemd qui ont échoué ("failed") ou qui sont inactifs ("exited") sur la machine :

```
systemctl list-units --all --type=service --state=exited --state=failed | grep "units listed" | c
ut -d' ' -f1
```

afficher la liste des services systemd qui démarrent automatiquement au boot ("enabled") :

```
systemctl list-unit-files --all --type=service | grep "enabled"
```

## 2. Analyse d'un service

path nginx.service : /usr/lib/systemd/system/nginx.service

```
[vagrant@localhost ~]$ systemctl cat nginx.service
# /usr/lib/systemd/system/nginx.service
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

ExecStart : permet d'indiquer la commande à exécuter au lancement du service. Ce paramètre est obligatoire pour tout les types de service.

ExecStartPre : c'est la commande qui sera exécutée avant ExecStart.

PIDFile : il est recommandé d’utiliser l’option PIDFile= pour que systemd puisse identifier le processus principal du démon.

Type : défini comment le processus va se lancer. Trois types existent, le type simple (lance un processus principal), le type forking (lance un processus parent et un processus fils, puis arrête le processus parent apèrs démarrage, type courant dans les système UNIX), et le type oneshot.

ExecReaload : commande à executer lorsqu'on demande au service de se recharger avec un reload.

Description : permet de donner une description du service qui apparaîtra lors de l'utilisation de la commande systemctl status <nom_du_service>.

After : permet d'indiquer quel pré-requis est nécessaire pour le fonctionnement du service.

Liste de tous les services qui contiennent la ligne WantedBy=multi-user.target :

```
[vagrant@localhost system]$ sudo find / -type f -name '*service' -exec grep -H 'WantedBy=multi-user.target' {} \; 2> /dev/null | cut -d ':' -f1
/etc/systemd/system/tp3.service
/usr/lib/systemd/system/rpcbind.service
/usr/lib/systemd/system/rdisc.service
/usr/lib/systemd/system/tcsd.service
/usr/lib/systemd/system/sshd.service
/usr/lib/systemd/system/rhel-configure.service
/usr/lib/systemd/system/rsyslog.service
/usr/lib/systemd/system/irqbalance.service
/usr/lib/systemd/system/cpupower.service
/usr/lib/systemd/system/crond.service
/usr/lib/systemd/system/rpc-rquotad.service
/usr/lib/systemd/system/wpa_supplicant.service
/usr/lib/systemd/system/chrony-wait.service
/usr/lib/systemd/system/chronyd.service
/usr/lib/systemd/system/NetworkManager.service
/usr/lib/systemd/system/ebtables.service
/usr/lib/systemd/system/gssproxy.service
/usr/lib/systemd/system/tuned.service
/usr/lib/systemd/system/firewalld.service
/usr/lib/systemd/system/nfs-server.service
/usr/lib/systemd/system/rsyncd.service
/usr/lib/systemd/system/nginx.service
/usr/lib/systemd/system/vmtoolsd.service
/usr/lib/systemd/system/postfix.service
/usr/lib/systemd/system/auditd.service
```

## 3. Création d'un service

### A. server web

Voici mon fichier de configuration mon mon unité systemd :

```

[Unit]
Description= server web in function

[Service]
Type=simple
Environment=PORT=50

ExecStartPre= /usr/bin/sudo iptables -A INPUT -p tcp -i eth1 --dport $PORT -j ACCEPT
ExecStart= /usr/bin/sudo python2 -m SimpleHTTPServer 50
ExecStopPost= /usr/bin/sudo iptables -D INPUT -p tcp -i eth1 --dport $PORT -j ACCEPT

User=tp3
Group=tp3

[Install]
WantedBy=multi-user.target
```

Le service est fonctionnel :

```
[tp3@localhost system]$ sudo systemctl status tp3
● tp3.service - server web in function
   Loaded: loaded (/etc/systemd/system/tp3.service; static; vendor preset: disabled)
   Active: active (running) since Mon 2020-10-05 17:20:50 UTC; 4s ago
  Process: 23941 ExecStartPre=/usr/bin/sudo iptables -A INPUT -p tcp -i eth0 --dport $PORT -j ACCEPT (code=exited, status=0/SUCCESS)
 Main PID: 23945 (sudo)
   CGroup: /system.slice/tp3.service
           ‣ 23945 /usr/bin/sudo python2 -m SimpleHTTPServer 50

Oct 05 17:20:50 localhost.localdomain systemd[1]: Starting server web in function...
Oct 05 17:20:50 localhost.localdomain sudo[23941]:      tp3 : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/sbin/iptables -A INPUT -p tcp -i eth0 --dport 50 -j ACCEPT
Oct 05 17:20:50 localhost.localdomain systemd[1]: Started server web in function.
Oct 05 17:20:50 localhost.localdomain sudo[23945]:      tp3 : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/bin/python2 -m SimpleHTTPServer 50
```

Et il sert sur le port indiqué :

```
[tp3@localhost system]$ curl -L 192.168.3.11:50
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><html>
<title>Directory listing for /</title>
<body>
<h2>Directory listing for /</h2>
<hr>
<ul>
<li><a href="bin/">bin@</a>
<li><a href="boot/">boot/</a>
<li><a href="dev/">dev/</a>
<li><a href="etc/">etc/</a>
<li><a href="home/">home/</a>
<li><a href="lib/">lib@</a>
<li><a href="lib64/">lib64@</a>
<li><a href="media/">media/</a>
<li><a href="mnt/">mnt/</a>
<li><a href="opt/">opt/</a>
<li><a href="proc/">proc/</a>
<li><a href="root/">root/</a>
<li><a href="run/">run/</a>
<li><a href="sbin/">sbin@</a>
<li><a href="srv/">srv/</a>
<li><a href="swapfile">swapfile</a>
<li><a href="sys/">sys/</a>
<li><a href="tmp/">tmp/</a>
<li><a href="usr/">usr/</a>
<li><a href="vagrant/">vagrant/</a>
<li><a href="var/">var/</a>
</ul>
<hr>
</body>
</html>
```

Enfin, j'ai enable le fichier .service pour qu'il démarre au boot.

```
PS C:\Users\Dayot\OneDrive\Desktop\cours_reseaux\Tp_Linux\tp3> vagrant ssh
Last login: Wed Oct  7 10:01:43 2020 from 10.0.2.2
Last login: Wed Oct  7 10:01:43 2020 from 10.0.2.2
[vagrant@localhost ~]$ sudo systemctl status tp3.service
● tp3.service - server web in function
   Loaded: loaded (/etc/systemd/system/tp3.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 10:26:19 UTC; 26s ago
  Process: 371 ExecStartPre=/usr/bin/sudo iptables -A INPUT -p tcp -i eth1 --dport $PORT -j ACCEPT (code=exited, status=0/SUCCESS)
 Main PID: 423 (sudo)
   CGroup: /system.slice/tp3.service
           ‣ 423 /usr/bin/sudo python2 -m SimpleHTTPServer 50

Oct 07 10:26:17 localhost.localdomain systemd[1]: Starting server web in function...
Oct 07 10:26:18 localhost.localdomain sudo[371]:      tp3 : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/sbin/iptables -A INPUT -p tcp -i eth1 --dport 50 -j ACCEPT
Oct 07 10:26:19 localhost.localdomain systemd[1]: Started server web in function.
Oct 07 10:26:19 localhost.localdomain sudo[423]:      tp3 : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/bin/python2 -m SimpleHTTPServer 50
```

### B. Sauvegarde

Le but ici est de faire fonctionner notre script de sauvegarde grâce à systemd.

Le file de service :

```
[vagrant@localhost srv]$ cat ../etc/systemd/system/backup_tp3.service
[Unit]
Description=Lancement des sauvegardes
ConditionPathExists=/srv

[Service]
PIDFile=/var/run/backup/tp3.pid
ExecStartPre=/usr/bin/sh /srv/script_check.sh
ExecStart=/usr/bin/sh /srv/script_save.sh
ExecStopPost=/usr/bin/sh /srv/script_max_save.sh

User=backup

[Install]
WantedBy=multi-user.target
```

Et les scripts nécessaires :

```
[vagrant@localhost srv]$ cat script_check.sh
#!/bin/bash
# Nicolas Dayot
# 08/10/2020
# Script de vérification avant sauvegarde

REP_SAVE="/srv/save"


# vérification de l'existance du dossier
if [[ ! -d "${REP_SAVE}" ]]
then
        echo "No save directory existing" >&2
        exit 1
else
        echo "repo check ok!"
fi
```

```
[vagrant@localhost srv]$ cat script_save.sh
#!/bin/bash
#Nicolas Dayot
# 09/10/2020
# script de sauvegarde de site1 et site2

echo $$ > /var/run/backup/tp3.pid

# répertoire de sauvegarde
REP_SAVE="/srv/save"

#répertoires à sauvegarder
REP_SITE1="/srv/site1"
REP_SITE2="/srv/site2"

#noms des sites

SITE1=${REP_SITE1:5}
SITE2=${REP_SITE2:5}

#récupération de la date
DATE=$(date +%Y%m%d%H%M)

#noms des archives

NAME_TAR1=${SITE1}_${DATE}
NAME_TAR2=${SITE2}_${DATE}

save(){
        tar zcvf "${REP_SAVE}/${NAME_TAR1}.tar.gz" "${SITE1}"
        tar zcvf "${REP_SAVE}/${NAME_TAR2}.tar.gz" "${SITE2}"
}

save
```

```
[vagrant@localhost srv]$ cat script_max_save.sh
#!/bin/bash
#Nicolas Dayot
# 09/10/2020
# script de suppression des saves anciennes

#répertoire de sauvegarde
REP_SAVE="/srv/save"


#plus vieille sauvegarde
OLD_F=$(ls -t "${REP_SAVE}" | tail -1)

check(){
        find "${REP_SAVE}" -maxdepth 1 -type f | wc -l | awk '{print $1}'
}

#nombre de sauvegardes précédentes
NBR_SAVE=$(check)

#limite du nombre de sauvegardes
LIMIT="8"

if [ "$NBR_SAVE" -lt "$LIMIT" ]
 then
        echo "Nombre de sauvegardes limité"
else
        rm  "${REP_SAVE}/${OLD_F}"
        echo "suppression des anciennes sauvegardes"
fi
```

Afin de l'executer toutes les heures, on réalise un timer.

```
[vagrant@localhost system]$ cat backup_tp3.timer
[Unit]
Description=sauvegarde horaire
Requires=backup_tp3.service

[Timer]

Unit=backup_tp3.service
OnCalendar=0/1:00:00

[Install]
WantedBy=timers.target
```

J'ai effectué ensuite la commande enable.

```
[vagrant@localhost srv]$ sudo systemctl status backup_tp3.timer
● backup_tp3.timer - sauvegarde horaire
   Loaded: loaded (/etc/systemd/system/backup_tp3.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Thu 2020-10-08 01:29:25 UTC; 18min ago

Oct 08 01:29:25 localhost.localdomain systemd[1]: Started sauvegarde horaire.
```

## Autres features

### Gestion de boot

J'ai édité tp3.svg pour que tu puisses vérifier mais les trois plus lents sont :

- NetworkManager-wait-online.service (6.502s)
- swapfile.swap (2.383s)
- systemd-vconsole-setup.service (2.344s)

### Gestion de l'heure

Mon fuseau horaire correspond à Time zone (UTC).
Et je ne suis pas synchronisé avec un serveur NTP (NTP synchronized: no).

```
[vagrant@localhost ~]$ timedatectl
      Local time: Thu 2020-10-08 02:26:10 UTC
  Universal time: Thu 2020-10-08 02:26:10 UTC
        RTC time: Thu 2020-10-08 01:16:45
       Time zone: UTC (UTC, +0000)
     NTP enabled: yes
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
```

Pour paramétrer le fuseau horaire, j'utilise :

```
[vagrant@localhost ~]$ timedatectl set-timezone America/Barbados
```

### Gestion des noms et de la résolution de noms

Mon hostname est listé ci-dessous, a Static hostname.

```
[vagrant@localhost ~]$ hostnamectl
   Static hostname: localhost.localdomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: d5c5547ff3294254b7db71bde210bbe4
           Boot ID: 0016d229348146e2b76aaeb83835c0f3
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.19.1.el7.x86_64
      Architecture: x86-64
```

On peut changer le hostname à partir de hostnamectl comme ceci :

```
[vagrant@localhost ~]$ hostnamectl set-hostname yolo
==== AUTHENTICATING FOR org.freedesktop.hostname1.set-static-hostname ===
Authentication is required to set the statically configured local host name, as well as the pretty host name.
Authenticating as: root
Password:
==== AUTHENTICATION COMPLETE ===
[vagrant@localhost ~]$ cat /etc/hostname
yolo
```

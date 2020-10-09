# TP1 : Déploiement classique

## Prérequis : setup des deux machines CentOs7

- Accès internet

node1 :

L'interface dédiée au NAT est l'enp0s3

```
[root@node1 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:54:28:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic enp0s3
       valid_lft 84165sec preferred_lft 84165sec
    inet6 fe80::392a:8461:9fac:296d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:be:c3:e3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.11/24 brd 192.168.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::3256:4ee4:96b6:3897/64 scope link tentative noprefixroute dadfailed
       valid_lft forever preferred_lft forever
    inet6 fe80::762c:b5ce:5591:2345/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Et elle joint internet.

```
[root@node1 ~]# curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

node2 :

L'interface dédiée est, ici aussi, enp0s3

```
[root@node2 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:54:28:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic enp0s3
       valid_lft 83891sec preferred_lft 83891sec
    inet6 fe80::392a:8461:9fac:296d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e4:f1:4e brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.12/24 brd 192.168.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::3256:4ee4:96b6:3897/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Et elle joint internet .

```
[root@node2 ~]# curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

- Accès à un réseau local

Sur les deux commandes ip a décritent précédemment, les interfaces dédiées au réseaux local sont les deux interfaces enp0s8 (des deux machines). Toutes les deux présentes dans le réseaux 192.168.1.0.

ping node1 --> node2 :

```
[root@node1 ~]# ping 192.168.1.12
PING 192.168.1.12 (192.168.1.12) 56(84) bytes of data.
64 bytes from 192.168.1.12: icmp_seq=1 ttl=64 time=0.350 ms
64 bytes from 192.168.1.12: icmp_seq=2 ttl=64 time=0.807 ms
^C
--- 192.168.1.12 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.350/0.578/0.807/0.229 ms
```

ping node2-->node1 (pour la forme) :

```
[root@node2 ~]# ping 192.168.1.11
PING 192.168.1.11 (192.168.1.11) 56(84) bytes of data.
64 bytes from 192.168.1.11: icmp_seq=1 ttl=64 time=0.342 ms
64 bytes from 192.168.1.11: icmp_seq=2 ttl=64 time=0.428 ms
^C
--- 192.168.1.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.342/0.385/0.428/0.043 ms
[root@node2 ~]#
```

- Les machines ont un nom

On change le hostname en modifiant le fichier /etc/hostname sur chaque machine.

node1:

```
[root@node1 ~]# hostname
node1.tp1.b2
```

node2:

```
[root@node2 ~]# hostname
node2.tp1.b2
```

- Les machines se joignent par leurs noms

Pour ce faire, on édit le fichier /etc/hosts en associant l'ip voulue au nom voulu.
Les deux machines peuvent maintenant se joindre en résolvant les noms d'hôte.

node1:

```
[root@node1 ~]# ping node2.tp1.b2
PING node2.tp1.b2 (192.168.1.12) 56(84) bytes of data.
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=1 ttl=64 time=0.428 ms
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=2 ttl=64 time=0.357 ms
^C
--- node2.tp1.b2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.357/0.392/0.428/0.040 ms
```

node2:

```
[root@node2 ~]# ping node1.tp1.b2
PING node1.tp1.b2 (192.168.1.11) 56(84) bytes of data.
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=1 ttl=64 time=0.445 ms
^C
--- node1.tp1.b2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.445/0.445/0.445/0.000 ms
```

- utilisateur admin sur les deux machines

J'ai créée un utilisateur admin1 (sur node1) et admin2 (sur node2) avec la commande "useradd nomUtilisateur"

Puis je leurs donne des droits en ajoutant une ligne au fichier sudoers (avec visudo).

```
admin1 ALL= (root) ALL
```

```
admin2 ALL= (root) ALL
```

- par-feu configurés pour ne laisser passer que les connexions nécessaires

Pour configurer les par-feux, j'ai utilisé iptables.

j'ai d'abord ajouté des règles pour le passage port 22 et 80 sur mon interface enp0s8:

```
sudo iptables -A INPUT -p tcp -i enp0s8 --dport ssh -j ACCEPT (accepter les co sur le port 22, ssh)
```

```
sudo iptables -A INPUT -p tcp -i enp0s8 --dport 80 -j ACCEPT (port 80 pour le server web)
```

Ainsi qu'une règle pour les connections déjà établies :

```
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
```

Enfin, comme la politique de base de iptable était réglée sur ACCEPT, il m'a fallu changer pour DROP (pour que seuls les paquets respectants les règles précédentes soient acceptés) :

```
iptables -P INPUT DROP
```

Voici les iptables INPUT de mes deux machines à la fin de mon paramétrage :

node1:

```
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
  197 13952 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
    0     0 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate ESTABLISHED

```

node2:

```
Chain INPUT (policy DROP 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination
1      473 31636 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate ESTABLISHED
2        0     0 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
3        0     0 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
```

- Partitionnement :

Le but de cette partie est de créer des nouvelles partitions et de les monter sur nos vm.

Les commandes et résultats étant les mêmes sur les deux machines, je n'ai mis comme preuve qu'un seul des deux paramétrages (m'en veux pas...).

En premier, on associe notre nouveau disque à un volume physique.

```
[admin1@node1 ~]$ sudo pvcreate /dev/sdb
[sudo] password for admin1:
  Physical volume "/dev/sdb" successfully created.
```

```
  "/dev/sdb" is a new physical volume of "5.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name
  PV Size               5.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               WSP99i-fpLL-yOQw-h1JD-dr3w-IMid-2PZOsG
```

Ensuite, on créer un "Volume Group" qui intégre le (ou les) volume(s) physique(s).

```
[admin1@node1 ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created
```

Enfin, on peut découper ce "volume group" qui regroupe tous nos volumes physiques en volumes logiques (les partitions voulues).

```
[admin1@node1 ~]$ sudo lvcreate -L 2G data -n data1
  Logical volume "data1" created.
```

```
[admin1@node1 ~]$ sudo lvcreate -l 100%FREE data -n data2
  Logical volume "data2" created.
```

On vérifie que tout a bien marché :

```
[admin1@node1 ~]$ sudo lvs
  LV    VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root  centos -wi-ao----  <6.20g
  swap  centos -wi-ao---- 820.00m
  data1 data   -wi-a-----   2.00g
  data2 data   -wi-a-----  <3.00g
```

Ensuite, il nous faut attribuer un système de fichier à nos partitions, puis créer un point de montage sur le disque (un simple dossier dans /mnt). Et enfin, on monte nos partitions sur les points de montage.

Attribution du système de fichier :

```
[admin1@node1 ~]$ sudo mkfs -t ext4 /dev/data/data1
[sudo] password for admin1:
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

```

Pour data2 aussi :

```
[admin1@node1 ~]$ sudo mkfs -t ext4 /dev/data/data2
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
196608 inodes, 785408 blocks
39270 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=805306368
24 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

```

Création du point de montage :

```
[admin1@node1 ~]$ sudo mkdir /mnt/data1
```

Puis montage :

```
[admin1@node1 ~]$ sudo mount /dev/data/data1 /mnt/data1
```

Une fois que cela a été fait, on va s'assurer que le montage s'effectue bien au boot de la machine.

Pour ce faire, on indique dans le fichier /etc/fstab un ligne expliquant quelle partition monter sur quel point de montage, avec quel système de fichier (puis des règles que nous gardons par défault).

```
#
# /etc/fstab
# Created by anaconda on Thu Jan 30 12:00:48 2020
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root /                       xfs     defaults        0 0
UUID=acd0255b-3d20-4990-a9a3-8961c0f8dea6 /boot                   xfs     defaults        0 0
/dev/mapper/centos-swap swap                    swap    defaults        0 0
/dev/data/data1 /mnt/data1 ext4 defaults 0 0                                                               /dev/data/data2 /mnt/data2 ext4 defaults 0 0
```

On vérifie en démontant une partition et en demandant à la machine de la remonter à partir de son fichiet fstab :

```
[admin1@node1 ~]$ sudo umount /mnt/data1
[admin1@node1 ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
swap                     : ignored
mount: /mnt/data1 does not contain SELinux labels.
       You just mounted an file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/mnt/data1               : successfully mounted
/mnt/data2               : already mounted
```

## Setup server Web

Tout d'abord, j'installe Nginx sur node 1 :

```
[admin1@node1 ~]$ sudo yum install nginx
[sudo] password for admin1:
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.pasteur.fr
 * epel: ftp-stud.hs-esslingen.de
 * extras: miroir.univ-paris13.fr
 * updates: centos.mirror.fr.planethoster.net
Package 1:nginx-1.16.1-1.el7.x86_64 already installed and latest version
Nothing to do
```

Voici mes deux dossier contenant les .html de mes sites, avec les restrictions voulue (chmod 744, seul le propriétaire du dossier peut écrire et executer) :

```
[admin1@node1 srv]$ ls -al
total 0
drwxr-xr-x.  4 root root  32 Sep 24 14:18 .
dr-xr-xr-x. 17 root root 224 Jan 30  2020 ..
drwxr--r--.  2 web  web   47 Sep 24 14:22 site1
drwxr--r--.  2 web  web   24 Sep 24 14:23 site2
```

chmod 644 sur les .hmtl, car personne n'a besoin de les executer.

```
[admin1@node1 site1]$ ls -al
total 8
drwxr-xr-x. 2 web  web    47 Sep 24 14:22 .
drwxr-xr-x. 4 root root   32 Sep 24 14:18 ..
-rw-r--r--. 1 web web   54 Sep 24 14:22 index.html
```

```
[admin1@node1 site2]$ ls -al
total 4
dr-x--x--x. 2 web  web  24 Sep 24 14:23 .
drwxr-xr-x. 4 root root 32 Sep 24 14:18 ..
-rw-r--r--. 1 web  web  54 Sep 24 14:23 index.html
```

Voici mon fichier de configuration nginx.conf :

```
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user web;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  node1.tp1.b2;
        root         /srv;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location /site1 {
                alias /srv/site1;
        }

        location /site2 {
                alias /srv/site2;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.

    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  node1.tp1.b2;
        root         /srv;

        ssl_certificate "/etc/pki/nginx/server.crt";
        ssl_certificate_key "/etc/pki/nginx/private/server.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location /site1 {
                alias /srv/site1;
        }

        location /site2 {
                alias /srv/site2;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
```

Je n'oublie pas d'ouvrir une règle firewall pour le port 443 :

```
[admin1@node1 nginx]$ sudo iptables -vnL
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
 8416  543K ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate ESTABLISHED
    8   520 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
    4   240 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
    0     0 ACCEPT     tcp  --  enp0s8 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:443
```

Enfin, les résultats sur la machine node2 :

```
[admin2@node2 ~]$ curl -L node1.tp1.b2/site1/index.html
<html>
<body>
<p>hello from site1</p>
</body>
</html>
```

```
[admin2@node2 ~]$ curl -L node1.tp1.b2/site2/index.html
<html>
<body>
<p>hello from site2</p>
</body>
</html>
```

Même chose pour le https :

```
[admin2@node2 ~]$ curl -kL https://node1.tp1.b2:443/site1/index.html
<html>
<body>
<p>hello from site1</p>
</body>
</html>
```

## Script de sauvegarde

Voici mon script de sauvegarde :

```
#!/bin/bash
# Nicolas Dayot
# 28/09/2020
# Backup max 7 saves.


#répertoire de sauvegarde
REP_SAVE="/srv/save"
#répertoire à sauvegarder
REP_SITE="$1"
#nom du site
SITE=${REP_SITE:5}
#récupération de la date
DATE=$(date +%Y%m%d%H%M)
#nom de l'archive
NAME_TAR=${SITE}_${DATE}
#ID de backup
USER="backup"
USER_ID=1003

save(){
        tar zcvf "${REP_SAVE}/${NAME_TAR}.tar.gz" "${SITE}"
}

check(){
        find "${REP_SAVE}" -maxdepth 1 -type f | wc -l | awk '{print $1}'
}

#nombre de sauvegardes précédentes
NBR_SAVE=$(check)

#plus vieille sauvegarde
OLD_F=$(ls -t "${REP_SAVE}" | tail -1)

#limite du nombre de sauvegardes
LIMIT="8"
if [[ ${EUID} -ne ${USER_ID} ]]
then
        echo "This script must be run as "${USER}" user. Exiting" >&2
        exit 1
elif [[ ! -d "${REP_SAVE}" ]]
then
        echo "No save directory existing" >&2
        exit 1
else
 if [ "$NBR_SAVE" -lt "$LIMIT" ]
 then
        echo "Sauvegarde..."
        save
        echo "Sauvegarde effectuée"
 else
        echo "sauvegarde + suppression..."
        rm  "${REP_SAVE}/${OLD_F}"
        save
        echo "Sauvegarde effectuée"
 fi
fi
```

Il s'execute avec l'utilisateur "backup". Deux cas de figures, l'un ou il y a peu de sauvegardes présentes dans save :

```
[backup@node1 srv]$ sh tp1_backup.sh /srv/site1
Sauvegarde...
tar: Removing leading `/' from member names
/srv/site1/
/srv/site1/.index.html.swp
/srv/site1/index.html
Sauvegarde effectuée
```

Et le cas ou il y besoin de supprimer la version la moins récente pour ne pas surcharger le dossier save :

```
[backup@node1 srv]$ sh tp1_backup.sh /srv/site2
sauvegarde + suppression...
tar: Removing leading `/' from member names
/srv/site2/
/srv/site2/index.html
Sauvegarde effectuée
```

J'utilise ensuite la crontab de l'utilisateur backup pour lancer des sauvegardes des deux sites une fois par heure (à chaque fois que les minutes sont à 00).

```
[backup@node1 srv]$ crontab -l
00 * * * * sh /srv/tp1_backup.sh /srv/site1
00 * * * * sh /srv/tp1_backup.sh /srv/site2
```

Pour rétablir une précédente sauvegarde, il suffit de retourner chercher une des archives, de la décomprésser et de remplacer le dossier du site corrompu par le dossier nouvellement acquis.

Une petite preuve du fonctionnement :

- Je sauvegarde mon dossier site1 avec le fichier prout dedans.
- je supprime prout par erreur.
- je me rends donc dans le dossier save, sélectionne l'une des sauvegardes, et y effectue la commande

```
sudo tar -xzvf nom_archive.tar.gz -C /srv/
```

- je me rends à nouveau dans site1 pour voir que prout a été rétabli.

```
[backup@node1 site1]$ ls
index.html  prout
[backup@node1 site1]$ cd ..
[backup@node1 srv]$ sh tp1_backup.sh /srv/site1
Sauvegarde...
site1/
site1/prout
site1/index.html
Sauvegarde effectuée
[backup@node1 srv]$ cd site1
[backup@node1 site1]$ rm prout
[backup@node1 site1]$ ls
index.html
[backup@node1 site1]$ cd ?
bash: cd: ?: No such file or directory
[backup@node1 site1]$ cd ..
[backup@node1 srv]$ cd save
[backup@node1 save]$ ls
site1_202009280516.tar.gz  site1_202009280521.tar.gz  site1_202009280524.tar.gz
[backup@node1 save]$ sudo tar -xzvf site1_202009280524.tar.gz -C /srv/
site1/
site1/prout
site1/index.html
[backup@node1 save]$ cd ..
[backup@node1 srv]$ cd site1
[backup@node1 site1]$ ls
index.html  prout
[backup@node1 site1]$
```

## Monitoring, alerting

Tout d'abord, j'installe NetData avec la commande suivante :

```
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

Ensuite, on edit un fichier de configuration :

```
sudo /etc/netdata/edit-config health_alarm_notify.conf
```

En lui indiquant l'url du bot créé sur discord.

```
# discord (discordapp.com) global notification options

# multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discordapp.com/api/webhooks/760166159986196480/UKo9bkGPF-dGiwzmvuqdnjs-jsZV_B6wwa46vMqNAth8DtGDMJxw-6DHt8OR4ysZskCi"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alarm"

```

On réalise enfin un test :

```
su -s /bin/bash netdata
export NETDATA_ALARM_NOTIFY_DEBUG=1
/usr/libexec/netdata/plugins.d/alarm-notify.sh test
```

![](https://i.imgur.com/PZ4HztK.png)

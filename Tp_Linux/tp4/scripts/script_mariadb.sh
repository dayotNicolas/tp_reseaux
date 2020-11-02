#!/bin/bash
# Dayot Nicolas
# 29/10/2020
# script config VM mariadb

iptables -A INPUT -p tcp -i eth1 --dport 3306 -j ACCEPT
service iptables save
systemctl enable iptables

yum install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

echo "
[mysqld]

bind-address = 192.168.4.11
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld_safe]

log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid
#
# include all files from the config directory
#
!includedir /etc/my.cnf.d" > /etc/my.cnf

systemctl restart mariadb.service

mysql -h "localhost" "--user=root" "--password=" -e \
	"SET old_passwords=0;" -e \
	"CREATE USER 'gitea'@'192.168.4.11' IDENTIFIED BY 'gitea';" -e \
	"SET PASSWORD FOR 'gitea'@'192.168.4.11' = PASSWORD('gitea');" -e \
	"CREATE DATABASE giteadb CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';" -e \
	"grant all privileges on giteadb.* to 'gitea'@'192.168.4.%' identified by 'gitea' with grant option;" -e \
	"FLUSH PRIVILEGES;"


yum install -y nfs-utils nfs-utils-lib

mkdir /nfs
mkdir /nfs/mariadb
mount -t nfs4 192.168.4.14:/nfs/mariadb /nfs/mariadb

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
sed -i "/DISCORD_WEBHOOK_URL=/c\DISCORD_WEBHOOK_URL='https://discord.com/channels/760165742036516866/760165742620180502'" /usr/lib/netdata/conf.d/health_alarm_notify.conf

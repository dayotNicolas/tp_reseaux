#!/bin/bash
# Dayot Nicolas
# 01/11/2020

iptables -A INPUT -p tcp -i eth1 --dport 80 -j ACCEPT
iptables -P INPUT DROP
service iptables save
systemctl enable iptables

yum install -y epel-release
yum install -y nginx

echo "
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
events {
    worker_connections 1024;
}
http {
    server {
        listen 80;
        server_name node1.gitea;
        location / {
                proxy_pass http://gitea:3000;
        }
    }
}" > /etc/nginx/nginx.conf

systemctl restart nginx

# yum install -y nfs-utils nfs-utils-lib

mkdir /nfs
mkdir /nfs/nginx
mount -t nfs4 192.168.4.14:/nfs/nginx /nfs/nginx

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
sed -i "/DISCORD_WEBHOOK_URL=/c\DISCORD_WEBHOOK_URL='https://discord.com/channels/760165742036516866/760165742620180502'" /usr/lib/netdata/conf.d/health_alarm_notify.conf


echo "#!/bin/sh
# Dayot Nicolas
# 02/11/2020
# script sauvegarde nginx conf
cp /etc/nginx/nginx.conf /mnt/nginx" > /mnt/nginx/backup_nginx.sh

echo "0 * * * * /mnt/nginx/backup_nginx.sh" > /var/spool/cron/vagrant
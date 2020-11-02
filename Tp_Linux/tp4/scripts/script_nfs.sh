#!/bin/bash
# Dayot Nicolas
# 01/11/2020

yum install -y nfs-utils

systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind

mkdir /nfs
chmod 777 /nfs
mkdir /nfs/gitea
mkdir /nfs/mariadb
mkdir /nfs/nginx

echo "
/nfs/gitea   192.168.4.11(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/nfs/mariadb   192.168.4.12(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/nfs/nginx   192.168.4.13(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
" > /etc/exports

exportfs -r

iptables -A INPUT -p tcp -i eth1 --dport mountd -j ACCEPT
iptables -A INPUT -p tcp -i eth1 --dport nfs -j ACCEPT

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
sed -i "/DISCORD_WEBHOOK_URL=/c\DISCORD_WEBHOOK_URL='https://discord.com/channels/760165742036516866/760165742620180502'" /usr/lib/netdata/conf.d/health_alarm_notify.conf
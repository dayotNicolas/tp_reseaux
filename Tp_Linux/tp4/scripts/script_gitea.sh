#!/bin/bash
# Dayot Nicolas
# 13/10/2020
# script install et conf gitea

iptables -A INPUT -p tcp -i eth0 --dport 3000 -j ACCEPT
service iptables save
systemctl enable iptables

yum install -y git

curl -SLs https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64 -o gitea
chmod +x gitea

useradd git

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

export GITEA_WORK_DIR=/var/lib/gitea/

cp gitea /usr/local/bin/gitea
chmod +x /usr/local/bin/gitea

echo "[Unit]
Description=Gitea service
After=syslog.target
After=network.target
[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
# If using Unix socket: tells systemd to create the /run/gitea folder, which will contain the gitea.sock file
# (manually creating /run/gitea doesn't work, because it would not persist across reboots)
#RuntimeDirectory=gitea
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
# If you want to bind Gitea to a port below 1024, uncomment
# the two values below, or use socket activation to pass Gitea its ports as above
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE
###
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/gitea.service

systemctl daemon-reload
systemctl enable gitea
systemctl start gitea

yum install -y nfs-utils nfs-utils-lib

mkdir /nfs
mkdir /nfs/gitea
mount -t nfs4 192.168.4.14:/nfs/gitea /nfs/gitea

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
sed -i "/DISCORD_WEBHOOK_URL=/c\DISCORD_WEBHOOK_URL='https://discord.com/channels/760165742036516866/760165742620180502'" /usr/lib/netdata/conf.d/health_alarm_notify.conf


echo "#!/bin/sh
# Dayot Nicolas
# 02/11/2020
# script sauvegarde gitea

tar -czf backup_gitea.tar.gz /etc/gitea/
cp ./backup_gitea.tar.gz /mnt/gitea" > /mnt/gitea/backup_gitea.sh
echo "00 * * * * /mnt/gitea/backup.sh" > /var/spool/cron/vagrant



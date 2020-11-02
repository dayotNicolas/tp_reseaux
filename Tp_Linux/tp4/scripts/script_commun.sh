#!/bin/bash
# Dayot Nicolas
# 13/10/2020
# script commun aux vms pour pré-paramétrer

yum remove -y firewalld

yum install -y iptables iptables-services

iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp -i eth0 --dport ssh -j ACCEPT

iptables -P INPUT DROP

service iptables save

systemctl enable iptables

echo "192.168.4.11 node1.tp4.b2" >> /etc/hosts
echo "192.168.4.12 node2.tp4.b2" >> /etc/hosts
echo "192.168.4.13 node3.tp4.b2" >> /etc/hosts
echo "192.168.4.14 node4.tp4.b2" >> /etc/hosts
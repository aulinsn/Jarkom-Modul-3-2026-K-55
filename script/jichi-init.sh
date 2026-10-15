#!/bin/bash

echo "nameserver 192.168.122.1" > /etc/resolv.conf

sysctl -w net.ipv4.ip_forward=1
grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf 2>/dev/null || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

apt-get update -y
apt-get install -y iptables
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE



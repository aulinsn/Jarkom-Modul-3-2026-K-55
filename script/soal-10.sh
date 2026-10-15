#!/bin/bash
# Soal 10: autostart dan pemulihan setelah restart

# di tengen
systemctl enable isc-dhcp-server 2>/dev/null || update-rc.d isc-dhcp-server defaults
ls /etc/rc2.d | grep dhcp

cat > /root/startup.sh <<'EOF'
#!/bin/bash
# === tengen: pulihkan DHCP server setelah restart ===
sleep 5
echo "nameserver 192.168.122.1" > /etc/resolv.conf
which dhcpd >/dev/null 2>&1 || { apt-get update; apt-get install isc-dhcp-server -y; }
cp /root/dhcpd.conf.soal7 /etc/dhcp/dhcpd.conf
echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server
update-rc.d isc-dhcp-server defaults
service isc-dhcp-server restart
EOF
chmod +x /root/startup.sh

# tambah baris di /etc/network/interfaces (blok eth0 tengen):
#     post-up /root/startup.sh > /root/startup.log 2>&1 &

# di jichi
systemctl enable isc-dhcp-relay 2>/dev/null || update-rc.d isc-dhcp-relay defaults
ls /etc/rc2.d | grep relay
cp /etc/default/isc-dhcp-relay /root/isc-dhcp-relay.soal3

cat > /root/startup.sh <<'EOF'
#!/bin/bash
# === jichi: pulihkan NAT dan relay setelah restart ===
sleep 5
echo "nameserver 192.168.122.1" > /etc/resolv.conf
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
which dhcrelay >/dev/null 2>&1 || { apt-get update; apt-get install isc-dhcp-relay -y; }
cp /root/isc-dhcp-relay.soal3 /etc/default/isc-dhcp-relay
update-rc.d isc-dhcp-relay defaults
service isc-dhcp-relay restart
EOF
chmod +x /root/startup.sh

# tambah baris di /etc/network/interfaces (blok eth0 jichi):
#     post-up /root/startup.sh > /root/startup.log 2>&1 &

# restart dan verifikasi
# tengen: 
service isc-dhcp-server status 
dhcpd -t
# jichi : 
ps aux | grep dhcrelay 
sysctl net.ipv4.ip_forward 
iptables -t nat -L POSTROUTING -n -v
# klien : 
ip addr flush dev eth0 
udhcpc -i eth0 
ip a 
ip route
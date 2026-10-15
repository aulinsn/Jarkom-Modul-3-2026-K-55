#!/bin/bash
# di jichi
apt-get update
apt-get install isc-dhcp-relay -y

cat > /etc/default/isc-dhcp-relay <<EOF
SERVERS="10.91.4.10"
INTERFACES="eth2 eth3 eth4"
OPTIONS=""
EOF

service isc-dhcp-relay restart

# di itadori dan ino (klien)
cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet dhcp
EOF
ifdown eth0 2>/dev/null
ifup eth0
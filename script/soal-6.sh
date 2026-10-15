#!/bin/bash
# di tengen
cat >> /etc/dhcp/dhcpd.conf <<'EOF'

host kugisaki {
    hardware ethernet MAC-KUGISAKI;
    fixed-address 10.91.3.99;
}
EOF

dhcpd -t
service isc-dhcp-server restart

# di kugisaki
# ip addr flush dev eth0
# udhcpc -i eth0
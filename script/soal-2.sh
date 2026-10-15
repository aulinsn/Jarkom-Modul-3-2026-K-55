#!/bin/bash
# di tengen
apt-get update
apt-get install isc-dhcp-server -y

cat > /etc/default/isc-dhcp-server <<EOF
INTERFACESv4="eth0"
EOF

cat > /etc/dhcp/dhcpd.conf <<EOF
subnet 10.91.4.0 netmask 255.255.255.0 {
}

subnet 10.91.2.0 netmask 255.255.255.0 {
    range 10.91.2.100 10.91.2.200;
    option routers 10.91.2.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 10.91.2.255;
    option domain-name-servers 8.8.8.8;

    default-lease-time 600;
    max-lease-time 3600;
}

subnet 10.91.3.0 netmask 255.255.255.0 {
    range 10.91.3.100 10.91.3.200;
    option routers 10.91.3.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 10.91.3.255;
    option domain-name-servers 8.8.8.8;

    default-lease-time 600;
    max-lease-time 3600;
}
EOF

dhcpd -t
service isc-dhcp-server restart
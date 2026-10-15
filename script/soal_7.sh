#!/bin/bash
# di tengen
# Samakan DNS dan domain-search Network 2 dengan Network 3
sed -i 's/option domain-name-servers 8.8.8.8;/option domain-name-servers 10.91.1.2, 10.91.1.3;\n    option domain-search "K55.com";/' /etc/dhcp/dhcpd.conf
dhcpd -t
service isc-dhcp-server restart

# seluruh klien Divisi A dan B 
# ip addr flush dev eth0
# udhcpc -i eth0
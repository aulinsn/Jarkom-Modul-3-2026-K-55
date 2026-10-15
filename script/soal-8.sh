#!/bin/bash
# di tengen
tcpdump -i eth0 -n -vvv -c 4 -w /root/dhcp-dora.pcap 'udp port 67 or udp port 68'

#di itadori (dijalankan setelah tcpdump menunggu) 
# ip addr flush dev eth0
# udhcpc -i eth0

# di tengen (baca hasil) 
# tcpdump -n -vvv -r /root/dhcp-dora.pcap
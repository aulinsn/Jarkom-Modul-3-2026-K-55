#!/bin/bash
#simulasi gangguan di jichi
service isc-dhcp-relay stop

# gejala di itadori
# ip addr flush dev eth0
# udhcpc -i eth0 -n -q    # gagal, tidak ada lease

#pemulihan gangguan di jichi
service isc-dhcp-relay start

#bukti pulih di itadori
# udhcpc -i eth0
# ip a show eth0 ; ip route
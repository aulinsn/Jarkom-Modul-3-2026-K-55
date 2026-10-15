#!/bin/bash
# di tengen
# Soal 5: short lease (ino, kusakabe) dan long lease (miwa) di Network 3

cat > /etc/dhcp/dhcpd.conf <<'EOF'
subnet 10.91.4.0 netmask 255.255.255.0 {
}

class "pool1" {
    match if (substring(hardware, 1, 6) = 02:42:5f:80:97:00)
          or (substring(hardware, 1, 6) = 02:42:3b:91:0d:00);
}

class "pool2" {
    match if (substring(hardware, 1, 6) = 02:42:c2:f6:78:00)
          or (substring(hardware, 1, 6) = 02:42:e4:7b:a8:00);
}

subnet 10.91.2.0 netmask 255.255.255.0 {
    option routers 10.91.2.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 10.91.2.255;
    option domain-name-servers 8.8.8.8;

    default-lease-time 600;
    max-lease-time 3600;

    pool {
        allow members of "pool1";
        range 10.91.2.10 10.91.2.35;
    }

    pool {
        allow members of "pool2";
        range 10.91.2.70 10.91.2.95;
    }
}

class "short" {
    match if (substring(hardware, 1, 6) = 02:42:3a:cb:48:00)
          or (substring(hardware, 1, 6) = 02:42:34:fd:cc:00);
}

class "long" {
    match if (substring(hardware, 1, 6) = 02:42:f7:ab:22:00);
}

subnet 10.91.3.0 netmask 255.255.255.0 {
    option routers 10.91.3.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 10.91.3.255;
    option domain-name-servers 10.91.1.2, 10.91.1.3;
    option domain-search "K55.com";

    pool {
        allow members of "short";
        range 10.91.3.10 10.91.3.89;
        default-lease-time 1800;
        max-lease-time 1800;
    }

    pool {
        allow members of "long";
        range 10.91.3.100 10.91.3.199;
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

dhcpd -t
service isc-dhcp-server stop
echo 'authoring-byte-order little-endian;' > /var/lib/dhcp/dhcpd.leases
service isc-dhcp-server start
cp /etc/dhcp/dhcpd.conf /root/dhcpd.conf.soal5

# di ino, kusakabe, miwa (klien)
# ip addr flush dev eth0
# udhcpc -i eth0
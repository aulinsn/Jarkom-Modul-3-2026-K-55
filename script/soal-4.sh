#!/bin/bash
# di tengen

cat > /etc/default/isc-dhcp-server <<'EOF'
INTERFACESv4="eth0"
EOF

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
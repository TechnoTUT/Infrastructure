#!/bin/bash
cd "$(dirname "$0")"
dnf update -y
dnf install -y bind bind-utils firewalld
sed -i '1iacl intra-network { \n 192.168.8.0/24; \n 192.168.10.0/24; \n 192.168.20.0/24 \n 192.168.11.0/24 \n 192.168.99.0/24; \n 192.168.16.0/30 \n 10.244.0.0/16; \n};' /etc/named.conf
cat /etc/named.conf | sed 's/allow-query    { localhost;};/allow-query     { localhost; intra-network; };' > /etc/named.conf
cat <<EOF > /etc/named.conf
forwarders {
    1.1.1.3;
};
zone "intra.technotut.net" IN {
    type master;
    file "intra.technotut.net.zone";
    allow-update { none; };
};
zone "16.168.192.in-addr.arpa" IN {
    type master;
    file "16.168.192.in-addr.arpa.zone";
    allow-update { none; };
};
zone "20.168.192.in-addr.arpa" IN {
    type master;
    file "20.168.192.in-addr.arpa.zone";
    allow-update { none; };
};
zone "11.168.192.in-addr.arpa" IN {
    type master;
    file "11.168.192.in-addr.arpa.zone";
    allow-update { none; };
};
zone "99.168.192.in-addr.arpa" IN {
    type master;
    file "99.168.192.in-addr.arpa.zone";
    allow-update { none; };
};
EOF
cat <<EOF >> /etc/sysconfig/named
OPTIONS="-4"
EOF
cp ./intra.technotut.net.zone /var/named/intra.technotut.net.zone
cp ./16.168.192.in-addr.arpa.zone /var/named/16.168.192.in-addr.arpa.zone
cp ./20.168.192.in-addr.arpa.zone /var/named/20.168.192.in-addr.arpa.zone
cp ./11.168.192.in-addr.arpa.zone /var/named/11.168.192.in-addr.arpa.zone
cp ./99.168.192.in-addr.arpa.zone /var/named/99.168.192.in-addr.arpa.zone
systemctl enable -now named
firewall-cmd --add-service=dns --permanent
firewall-cmd --reload
#!/bin/bash
cd "$(dirname "$0")"
dnf update -y
git fetch
git reset --hard origin/main
git merge origin/main
\cp -f ./named.conf /etc/named.conf
\cp -f ./intra.technotut.net.zone /var/named/intra.technotut.net.zone
\cp -f ./16.168.192.in-addr.arpa.zone /var/named/16.168.192.in-addr.arpa.zone
\cp -f ./20.168.192.in-addr.arpa.zone /var/named/20.168.192.in-addr.arpa.zone
\cp -f ./11.168.192.in-addr.arpa.zone /var/named/11.168.192.in-addr.arpa.zone
\cp -f ./99.168.192.in-addr.arpa.zone /var/named/99.168.192.in-addr.arpa.zone
systemctl restart named
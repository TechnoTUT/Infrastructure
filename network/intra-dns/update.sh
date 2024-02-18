#!/bin/bash
cd "$(dirname "$0")"
dnf update -y
git pull
cp ./intra.technotut.net.zone /var/named/intra.technotut.net.zone
cp ./16.168.192.in-addr.arpa.zone /var/named/16.168.192.in-addr.arpa.zone
cp ./20.168.192.in-addr.arpa.zone /var/named/20.168.192.in-addr.arpa.zone
cp ./11.168.192.in-addr.arpa.zone /var/named/11.168.192.in-addr.arpa.zone
cp ./99.168.192.in-addr.arpa.zone /var/named/99.168.192.in-addr.arpa.zone
systemctl restart named
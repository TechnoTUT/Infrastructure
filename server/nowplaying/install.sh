#!/bin/bash
cd ~
dnf update -y && dnf install -y nginx firewalld
systemctl enable --now nginx firewalld
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
git clone https://github.com/technotut/nowplaying_dj.git
\cp -f ./nowplaying_dj/* /usr/share/nginx/html/
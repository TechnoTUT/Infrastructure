#!/bin/bash
cd "$(dirname "$0")"
dnf update -y
git pull
\cp -f ./prometheus.yml /etc/prometheus/prometheus.yml
\cp -f ./snmp.yml /etc/prometheus/snmp.yml
systemctl restart prometheus
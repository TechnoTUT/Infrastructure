#!/bin/bash
cd "$(dirname "$0")"
dnf update -y
git pull
\cp -f ./prometheus/prometheus.yml /etc/prometheus/prometheus.yml
\cp -f ./snmp-exporter/snmp.yml /etc/prometheus/snmp.yml
systemctl restart prometheus
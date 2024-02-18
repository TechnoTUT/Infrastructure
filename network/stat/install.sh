#!/bin/bash

cd "$(dirname "$0")"
dnf update -y
cat > /etc/yum.repos.d/prometheus.repo <<'EOF'
[prometheus]
name=Prometheus
baseurl=https://packagecloud.io/prometheus-rpm/release/el/$releasever/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/prometheus-rpm/release/gpgkey
sslverify=1
metadata_expire=300
EOF

dnf update -y
dnf install -y net-snmp net-snmp-utils net-snmp-libs net-snmp-devel prometheus grafana firewalld
dnf install -y snmp_exporter-0.22.0-1.el9.x86_64
systemctl enable --now prometheus snmp_exporter grafana-server
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
\cp -f ./snmp-exporter/snmp.yml /etc/prometheus/snmp.yml
\cp -f ./prometheus/prometheus.yml /etc/prometheus/prometheus.yml
systemctl restart prometheus snmp_exporter

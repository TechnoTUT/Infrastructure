#!/bin/bash

cd "$(dirname "$0")"
sudo dnf update -y
sudo cat > /etc/yum.repos.d/prometheus.repo <<'EOF'
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

sudo dnf update -y
sudo dnf install -y net-snmp net-snmp-utils net-snmp-libs net-snmp-devel prometheus grafana
sudo dnf install -y snmp_exporter-0.22.0-1.el9.x86_64
sudo systemctl enable --now prometheus snmp_exporter grafana-server
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
sudo cp ./snmp.yml /etc/prometheus/snmp.yml
sudo cp ./prometheus.yml /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus snmp_exporter

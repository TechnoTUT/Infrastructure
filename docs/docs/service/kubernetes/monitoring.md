---
title: 監視サーバ
sidebar_position: 1
---
PrometheusとGrafanaを使用して、Proxmox VE、ネットワーク機器、NDI機器、VJ機器を監視しています。  
http://stat.kube.technotut.net/ にアクセスすることで、Grafanaのダッシュボードを閲覧することができます。
![Grafana](/img/service/kubernetes_monitoring.jpg)
  
## 構築
マニフェストは以下で管理しています。  
[![TechnoTUT/k3s - GitHub](https://gh-card.dev/repos/TechnoTUT/k3s.svg?fullname=)](https://github.com/TechnoTUT/k3s/tree/main/manifest/stat/)  
Kubernetes上で動作しており、ArgoCDによってGitHubリポジトリのマニフェストを自動適用します。  
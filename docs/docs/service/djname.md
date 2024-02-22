---
title: DJ名表示
sidebar_position: 3
---
時刻に応じてDJ名を表示します。インターネット向けには、https://program.technotut.net/ で提供しています。 
## 使い方
### インターネット接続環境がある場合
ブラウザでhttps://program.technotut.net/ にアクセスしてください。
### [TechnoTUT Network](/) 網内の場合
ブラウザでhttp://np.intra.technotut.net/ または http://192.168.99.52/ にアクセスしてください。

## Githubリポジトリ
DJ名表示のソースコードはこちらで管理しています。  
[![TechnoTUT/Nowplaying_DJ - GitHub](https://gh-card.dev/repos/TechnoTUT/Nowplaying_DJ.svg?fullname=)](https://github.com/TechnoTUT/Nowplaying_DJ)  
網内向けに配信するサーバを構築する場合は、以下の手順でnginx等のWebサーバを構築し、ファイルを配置します。
```bash
dnf update
dnf install -y nginx firewalld git
systemctl enable --now nginx firewalld
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
cd ~
git clone https://github.com/TechnoTUT/Nowplaying_DJ.git
cp -r Nowplaying_DJ/* /usr/share/nginx/html/
```
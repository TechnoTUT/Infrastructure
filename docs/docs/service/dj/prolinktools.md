---
title: prolink-tools
sidebar_position: 3
---
## prolink-tools について
[prolink-tools](https://https://prolink.tools/) は、AlphaTheta(Pioneer DJ)のDJ機器と連携するためのツールです。  
[PRO DJ LINK](/service/dj/prodjlink)を用いて情報を取得し、美しいWebオーバーレイを作成することができます。
[![evanpurkhiser/prolink-tools - GitHub](https://gh-card.dev/repos/evanpurkhiser/prolink-tools.svg?fullname=)](https://github.com/evanpurkhiser/prolink-tools)  

## 使用方法
1. [TechnoTUT Network](/)に接続します。  
2. Debian GUI環境に接続します。  
   `prolink.intra.technotut.net`または`192.168.99.12`へリモートデスクトップ接続します。
3. デスクトップの`start.sh`を実行してprolink-toolsを起動します。  
    起動すると、自動で曲情報・波形情報が表示されます。  

何らかの不具合が発生した場合は、一度ウィンドウを閉じて再度`start.sh`を実行してください。  

## 環境構築
新たにDebian GUI環境を構築し、prolink-toolsを利用する場合は、以下の手順に従います。  
事前にDebianのテンプレートでLXCを作成します。  
```bash  
# rootに入る
su -
cd ~
# パッケージの更新・インストール
apt update -y && apt upgrade -y
apt install -y task-xfce-desktop dbus-x11 tigervnc-standalone-server xrdp
# xrdpの設定
vi /etc/xrdp/xrdp.ini
```
```ini
[Xvnc]
name=Xvnc
lib=libvnc.so
username=root
password=<your-password>
ip=127.0.0.1
port=5901
```
```bash
# xrdpの自動起動設定
systemctl enable xrdp
# VNCのパスワード設定
vncpasswd
# prolink-toolsのインストール
apt install -y tar
cd ~ && https://github.com/evanpurkhiser/prolink-tools/releases/download/main-build/prolink-tools-dev-a7e78b9-linux.tar.gz && tar -xvf prolink-tools-dev-a7e78b9-linux.tar.gz && mv prolink-tools-dev-a7e78b9-linux prolink-tools && rm -f prolink-tools-dev-a7e78b9-linux.tar.gz
# 自動起動設定
crontab -e
```
```crontab
@reboot sleep 45 && tigervncserver -xstartup /usr/bin/xfce4-session -localhost no :1 
```
設定が完了したら、Proxmox VEのWebUIからLXCを再起動します。
```bash
# 開始スクリプトの作成
cat << 'EOF' > /root/Desktop/start.sh
#!/bin/bash
/root/prolink-tools/prolink-tools
EOF
# 実行権限の付与
chmod +x /root/Desktop/start.sh
```
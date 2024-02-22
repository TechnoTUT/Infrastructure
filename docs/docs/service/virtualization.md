---
title: 仮想基盤
slug: /service/virtualization
sidebar_position: 7
---
網内では、Proxmox VEを使用した仮想基盤を提供しています。  
仮想マシン(VM)や、Linuxコンテナ(LXC)を利用することができます。  

## 利用方法
1. https://192.168.99.99:8006/ にアクセスしてください。
2. ログイン画面が表示されますので、ユーザ名とパスワードを入力してください。  
ユーザ名とパスワードは、管理者に問い合わせていただければ発行いたします。  
3. ログイン後、左側のメニューから、新規作成や既存のVM/LXCの操作を行います。  
### 仮想マシン(VM)の利用
仮想マシン(VM)は、KVMでの提供となります。  
:::info
仮想マシン(VM)の作成には、ISOイメージが必要です。  
OSのインストールイメージは各自準備をお願いします。
:::
:::warning
Linuxコンテナ対応OSを利用する場合は、Linuxコンテナ(LXC)の利用を推奨します。  
軽量でホストマシンのリソースを節約できる上、高速起動が可能です。  
:::
### Linuxコンテナ(LXC)の利用
Linuxコンテナ(LXC)は、ホストOSのカーネルを共有して動作するため、軽量で高速な仮想化が可能です。  
作成・起動を数秒で行うことができます。  
:::info
Linuxコンテナ(LXC)で提供しているOSは、以下の通りです。  
提供を行っていないOSを利用する必要がある場合は、仮想マシン(VM)を利用してください。  
- Debian 12 (Bookwarm)
- Ubuntu 22.04 LTS (Jammy)
- Alma Linux 9
- CentOS 9 Stream
:::
:::warning
Linuxコンテナ(LXC)は、権限の制約上、一部の機能が利用できない場合があります。  
特権が必要な場合は、仮想マシン(VM)を利用してください。
:::

## ネットワーク
仮想マシン(VM)やLinuxコンテナ(LXC)は、網内の任意のVLANに接続することができます。  
IPアドレスは、管理者が指定しますので、必要な場合は問い合わせてください。

## SSH接続
仮想マシン(VM)やLinuxコンテナ(LXC)にSSH接続を行い、Proxmox VEの管理画面を開くことなく遠隔操作を行うことができます。  
SSH接続を行うには、仮想マシン(VM)やLinuxコンテナ(LXC)にSSHサーバがインストールされている必要があります。インストールされていない場合は、以下の手順でインストールしてください。  
  
Debian/Ubuntu
```bash
sudo apt update && sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```
  
RHEL/CentOS/Alma Linux
```bash
sudo dnf update && sudo dnf install -y openssh-server
sudo systemctl enable --now sshd
```
SSH接続を行うには、手元のコンピュータでターミナルを開き、以下のコマンドを実行します。  
```bash
ssh <ユーザ名>@<IPアドレス>
```
### 公開鍵認証
公開鍵認証を利用する場合は、以下のコマンドを実行します。  
まずは、手元のコンピュータで鍵生成を行います。  
```bash
ssh-keygen -t ed25519
# 公開鍵の中身を表示
cat ~/.ssh/id_ed25519.pub
```
次に、公開鍵を仮想マシン(VM)やLinuxコンテナ(LXC)に登録します。  
```bash
mkdir ~/.ssh
echo "<公開鍵>" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
登録が完了したら、SSH接続を行います。  
```bash
ssh -i ~/.ssh/id_ed25519 <ユーザ名>@<IPアドレス>
```

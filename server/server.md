## 概要
Proxmox VE (ハイパーバイザ) を用いた仮想環境を構築しています.  
サービスごとに仮想マシンまたはLXC (Linux Container) を作成し, 構築を行っています.  
各仮想マシン・LXCはタグVLANで任意のVLANに所属させることができます.  
![server](/server/server.drawio.svg)

## 管理画面にアクセス
部室の管理VLANに接続し, https://192.168.99.99:8006 にアクセスします.
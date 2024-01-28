TechnoTUTのオンプレ環境のうち、公開可能なものをまとめたものです。  
概要図はdraw.ioで作成しています。 これらの編集には draw.io VS Code Integration の利用を推奨します。

## 概要図
イベント時  
![概要図](/network/event.drawio.svg)  
部室運用時  
![概要図](/network/clubroom.drawio.svg)

## 機材一覧
NEC UNIVERGE IX3110 (ルータ)  
Allied Telesis AT-x600-48Ts (L3スイッチ, 48ポート)  
Allied Telesis AT-x210-24GT (L2スイッチ, 24ポート)
Allied Telesis GS924M V2 (L2スイッチ, 24ポート)  
Allied Telesis GS924M V2 (L2スイッチ, 24ポート)  
Cisco Catalyst 2960 Plus 24TC-L (L2スイッチ, 24ポート)  
Cisco 891FJ-K9 (ルータ)
Cisco Aironet 2700 (無線LANアクセスポイント)
TP-Link Archer A2600 (無線LANアクセスポイント)
GL.iNet GL-AR300M1G-EXT (無線LANアクセスポイント)

## VLAN
各VLANは以下のように設定しています。  
各VLANはルータ(イベント時はNEC UNIVERGE IX3110、部室運用時はCisco 891FJ-K9)でルーティングしています。  

### VLAN10
DJ用VLAN  
192.168.10.0/24  
DHCP: 192.168.10.101 - 192.168.10.200  
Gateway: 192.168.10.1  
DNS: 192.168.10.1  
lease-time: 10800  
備考: インターネット接続不可(ACLで遮断), L2スイッチ(CIsco Catalyst 2960 Plus 24TC-L)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  

### VLAN20
VJ用VLAN  
192.168.20.0/24
DHCP: 192.168.20.101 - 192.168.20.200  
Gateway: 192.168.20.1  
DNS: 192.168.20.1  
lease-time: 86400  
備考: インターネット接続不可(ACLで遮断), L3スイッチ(Allied Telesis AT-x600-48Ts)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  

### VLAN30
LED制御用VLAN
192.168.11.0/24  
DHCP: 無効
Gateway: 192.168.11.1  
DNS: 192.168.11.1  
lease-time: 3600  
備考: IGMP Snooping無効, アクセスポートのSTP Portfast有効  

### VLAN99
管理用VLAN  
192.168.99.0/24  
DHCP: 192.168.99.101 - 192.168.99.200  
Gateway: 192.168.99.1  
DNS: 192.168.99.1  
lease-time: 3600  
備考: IGMP Snooping無効, アクセスポートのSTP Portfast有効    

## サーバ
Proxmox VE (ハイパーバイザ) を用いた仮想環境を構築しています.  
サービスごとに仮想マシンまたはLXC (Linux Container) を作成し、構築を行っています.  
各仮想マシン・LXCはタグVLANで任意のVLANに所属させることができます.
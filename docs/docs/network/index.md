---
title: Network
slug: /
sidebar_position: 1
---
## 概要
網内では以下のサービスを提供しています。  
[こちら](/service)を選択すると、各サービスの詳細を確認できます。
- NTP
- 網内DNSサーバ
- DJ名表示
- DJ Network
    - PRO DJ LINK
    - Beat-Link-Trigger
- VJ Network
    - Ableton Link
    - NDI動作環境
    - OSC
    - ディスクレスシステム
- LED通信設備
- 仮想基盤
- コンテナ実行基盤
    - 監視サーバ

このページ及び図・コードは、TechnoTUTの[GitHubリポジトリ](https://github.com/TechnoTUT/Infrastructure)で管理されています。  
[![TechnoTUT/Infrastructure - GitHub](https://gh-card.dev/repos/TechnoTUT/Infrastructure.svg?fullname=)](https://github.com/TechnoTUT/Infrastructure)

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

## ネットワーク設計
### 物理構成
イベント運用時  
![物理構成図_イベント](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/utone.drawio.svg)  
部室運用時  
![物理構成図_部室](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/clubroom.drawio.svg)

### 論理構成
![論理構成図_イベント](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/utone.logic.drawio.svg)
![論理構成図_部室](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/clubroom.logic.drawio.svg)

### VLAN
DJ, VJ, LED制御, サーバ用の4つのVLANを設定しています。  
VLANを設定することで、各機能ごとに仮想的にネットワークを分割しています。 
各VLANは、イベント時はAllied Telesis AT-x600-48Ts、部室運用時はCisco 891FJ-K9でルーティングしています。  
各VLANの設定は以下の通りです。  
#### VLAN10 (DJ)  
CIDR: 192.168.10.0/24  
DHCP: 192.168.10.101 - 192.168.10.200  
Gateway: 192.168.10.1  
DNS: 192.168.16.1  
#### VLAN20 (VJ)
CIDR: 192.168.20.0/24
DHCP: 192.168.20.101 - 192.168.20.200  
Gateway: 192.168.20.1  
DNS: 192.168.16.1  
#### VLAN30 (LED)
CIDR: 192.168.11.0/24  
DHCP: 無効
#### VLAN99 (Server)
CIDR: 192.168.99.0/24  
DHCP: 192.168.99.101 - 192.168.99.200  
Gateway: 192.168.99.1  
DNS: 192.168.16.1  

### ルーティング
IX3110 - AT-x600-48Ts間はOSPFを、IX3110 - Kubernetes間はBGPを使用して経路情報を交換しています。  
OSPFからBGPへ、BGPからOSPFへの経路再配信も行っています。

### DNS
BINDを使用して、内部DNSサーバが構築されており、NEC IX3110がキャッシュDNSサーバとして機能しています。  
内部DNSサーバにないものの問い合わせは、`1.1.1.1`に転送されます。 内部DNSサーバが何らかの理由で停止している場合は、NEC IX3110が`1.1.1.1`に代理で問い合わせを行います。  
FQDNとIPアドレスの対応は[こちら](/network/dns)を参照してください。
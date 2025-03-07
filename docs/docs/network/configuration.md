---
title: 設計
sidebar_position: 2
---
## イベント運用時  
![物理構成図_イベント](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/utone.drawio.svg)  
![論理構成図_イベント](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/utone.logic.drawio.svg)

### 経路制御
IX3110 - AT-x600-48Ts間でOSPFを、IX3110 - Kubernetesクラスタネットワーク間でBGPを使用して経路情報を交換しています。  
L3機器間で経路情報を交換し、手動での経路設定を削減することで、運用負荷を軽減します。

### リンクアグリゲーション
コアスイッチであるAT-x600-48TsとDJブース、およびMOCとの間ではリンクアグリゲーションを構成しています。リンクアグリゲーションによって、LANケーブル切断時の冗長性を確保しながら帯域幅を拡張し、高速で安定したネットワークを提供します。

## 部室運用時  
![物理構成図_部室](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/clubroom.drawio.svg)
![論理構成図_部室](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/network/design/clubroom.logic.drawio.svg)

### 静音性
部室運用時は、ファンレスで静音性の高いCisco 891FJ-K9をルーターとして使用します。ファンレス機器を採用することで、部室内のノイズを抑え、快適な環境を維持します。

### 互換性
イベント運用時と同様にVLANを分割することで、部室内でもイベントと同様の環境でテストを実施できる開発環境を提供します。

## イベント・部室共通
### VLAN
DJ(PRO DJ LINK)、VJ(NDI・Ableton Link)、照明制御(Art-Net)、撮影機材(RTMP)、PA(HTTP)、計算機クラスタ用に各機能ごとに仮想的にネットワークを分割しています。 
各VLANは、イベント時はNEC IX3110とAllied Telesis AT-x600-48Ts、部室運用時はCisco 891FJ-K9でルーティングしています。各VLANの設定は以下の通りです。  
#### VLAN10 (DJ, PRO DJ LINK)  
CIDR: 10.10.0.0/16  
DHCP: 10.10.254.0 - 10.10.254.254  
Gateway: 10.10.0.1  
DNS: 192.168.16.1  
#### VLAN20 (VJ, NDI・Ableton Link)
CIDR: 10.20.0.0/16  
DHCP: 10.20.254.0 - 10.20.254.254  
Gateway: 10.20.0.1  
DNS: 192.168.16.1  
#### VLAN30 (Lightning, Art-Net)
CIDR: 192.168.11.0/24  
DHCP: 無効
#### VLAN40 (Cam1, RTMP)
CIDR: 192.168.71.0/24
DHCP: 192.168.71.101 - 192.168.71.200
Gateway: 192.168.71.1
DNS: 10.33.71.11
#### VLAN50 (Cam2, RTMP)
CIDR: 192.168.72.0/24
DHCP: 192.168.72.101 - 192.168.72.200
Gateway: 192.168.72.1
DNS: 10.33.71.12
#### VLAN60 (PA)
CIDR: 192.168.60.0/24
DHCP: 192.168.60.101 - 192.168.60.200
Gateway: 192.168.60.1
DNS: 192.168.16.1
#### VLAN99 (Server)
CIDR: 192.168.99.0/24  
DHCP: 192.168.99.101 - 192.168.99.200  
Gateway: 192.168.99.1  
DNS: 192.168.16.1  
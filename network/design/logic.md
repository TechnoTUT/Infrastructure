# 論理設計
## 論理構成図
![論理構成図](./logic.drawio.svg)

## 機器設定
### ルータ (NEC UNIVERGE IX3110)
#### device
- GE0: no shutdown
- GE1: shutdown
- GE2: shutdown
- GE3: connecter-type sfp, no shutdown
#### interface ip address
- GE0.0: ip address 192.168.8.99/24
- GE3.0: ip address 192.168.16.1/30
- GE3.1: ip address 192.168.99.1/24
#### ACL
- 192.168.99.0/24, 10.244.0.0/16, 192.168.20.100/32　のWAN通信を許可, それ以外は拒否
https://changineer.info/network/nec_ix/nec_ix_firewall_basic.html
```shell-session
Router(config)# ip access-list permit-wan-in permit ip src any dest 192.168.99.0/24
Router(config)# ip access-list permit-wan-in permit ip src any dest 10.244.0.0/16
Router(config)# ip access-list permit-wan-in permit ip src any dest 192.168.20.100/32
Router(config)# ip access-list permit-wan-out permit ip src 192.168.99.0/24 dest any
Router(config)# ip access-list permit-wan-out permit ip src 10.244.0.0/16 dest any
Router(config)# ip access-list permit-wan-out permit ip src 192.168.20.100/32 dest any
Router(config)# ip access-list implicit-deny deny ip src any dest any
Router(config)# interface GigaEthernet0.0
Router(config-if)# ip access-list permit-wan-in 1 in
Router(config-if)# ip access-list implicit-deny 2 in
Router(config-if)# ip access-list permit-wan-out 1 out
Router(config-if)# ip access-list permit-wan-out 2 out
```
#### ルーティング
- OSPFでL3スイッチと経路情報を交換  
  https://changineer.info/network/nec_ix/nec_ix_routing_ospf.html
- BGPでKubernetesクラスタと経路情報を交換  
  https://changineer.info/network/nec_ix/nec_ix_routing_bgp.html  
  https://github.com/TechnoTUT/k3s/blob/main/setup/setup.md
  - AS番号: 65000 (iBGP)
  - neighbor: 192.168.99.33
- OSPF→BGP, BGP→OSPFの経路再配信を設定  
  https://changineer.info/network/nec_ix/nec_ix_routing_redistribute.html
#### その他
- SSHサーバを有効化
- NTPサーバを有効化
- snmpサーバを有効化, コミュニティ名: univerge
- HTTPサーバを有効化
- DNSプロキシを有効化

### L3スイッチ (Allied Telesis AT-x600-48Ts)
#### ルーティング
- OSPFでルータと経路情報を交換  
  https://www.allied-telesis.co.jp/support/list/switch/x600/doc/001070d/overview-5.html#sec8
- HelloパケットがVLAN10, 20, 30, 99に送信されないように設定 (passive-interfaceを設定)  
  https://www.allied-telesis.co.jp/support/list/switch/x600/doc/docs/docs/passive-interface@136OSPF.html
- 直結経路(connected)→OSPFの経路再配信を設定  
  https://www.allied-telesis.co.jp/support/list/switch/x600/doc/001070d/overview-5.html#sec22
- port1.0.48をルーテッドポートに設定, IPアドレスは 192.168.16.2/30
#### VLAN
##### VLAN10
DJ用VLAN  
192.168.10.0/24  
DHCP: 192.168.10.101 - 192.168.10.200  
Gateway: 192.168.10.1  
DNS: 192.168.16.1  
備考: L2スイッチ(CIsco Catalyst 2960 Plus 24TC-L)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  
##### VLAN20
VJ用VLAN  
192.168.20.0/24
DHCP: 192.168.20.101 - 192.168.20.200  
Gateway: 192.168.20.1  
DNS: 192.168.16.1  
備考: L3スイッチ(Allied Telesis AT-x600-48Ts)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  
##### VLAN30
LED制御用VLAN
192.168.11.0/24  
DHCP: 無効
備考: IGMP Snooping無効, アクセスポートのSTP Portfast有効  
##### VLAN70
GoPro用VLAN
192.168.70.0/29
DHCP: 192.168.70.2 - 192.168.70.6
Gateway: 192.168.70.1
DNS: 192.168.70.1
備考: スイッチにはVLANとDHCPサーバのみ作成
##### VLAN71
Sony製カメラ用VLAN #1
192.168.70.8/29
DHCP: 192.168.70.10 - 192.168.70.14
Gateway: 192.168.70.9
DNS: 192.168.70.9
備考: スイッチにはVLANとDHCPサーバのみ作成
##### VLAN72
Sony製カメラ用VLAN #2
192.168.70.16/29
DHCP: 192.168.70.18 - 192.168.70.22
Gateway: 192.168.70.17
DNS: 192.168.70.17
備考: スイッチにはVLANとDHCPサーバのみ作成
##### VLAN99
管理用VLAN (DHCPサーバはIXを使用)
192.168.99.0/24  
DHCP: 192.168.99.101 - 192.168.99.200  
Gateway: 192.168.99.1  
DNS: 192.168.16.1  
備考: L3スイッチ(Allied Telesis AT-x600-48Ts)をIGMP Snooping Querierに設定, アクセスポートのSTP Portfast有効  
#### ポート
- port1.0.1-27はシャットダウン (未使用)
- port1.0.28-29をアクセスポート, VLAN IDを99に設定
- port1.0.30をアクセスポート, VLAN IDを30に設定
- port1.0.33-36, port1.0.37-44をLAGに設定
- port1.0.31-47をトランクポートに設定
- port1.0.48はルーテッドポート

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | shut | - | - | - | |
| 2 | shut | - | - | - | |
| 3 | shut | - | - | - | |
| 4 | shut | - | - | - | |
| 5 | shut | - | - | - | |
| 6 | shut | - | - | - | |
| 7 | shut | - | - | - | |
| 8 | shut | - | - | - | |
| 9 | shut | - | - | - | |
| 10 | shut | - | - | - | |
| 11 | shut | - | - | - | |
| 12 | shut | - | - | - | |
| 13 | shut | - | - | - | |
| 14 | shut | - | - | - | |
| 15 | shut | - | - | - | |
| 16 | shut | - | - | - | |
| 17 | shut | - | - | - | |
| 18 | shut | - | - | - | |
| 19 | shut | - | - | - | |
| 20 | shut | - | - | - | |
| 21 | shut | - | - | - | |
| 22 | shut | - | - | - | |
| 23 | shut | - | - | - | |
| 24 | shut | - | - | - | |
| 25 | shut | - | - | - | |
| 26 | shut | - | - | - | |
| 27 | shut | - | - | - | |
| 28 | no shut | 99 | access | enable | |
| 29 | no shut | 99 | access | enable | |
| 30 | no shut | 30 | access | enable | |
| 31 | no shut | all | trunk | disable | |
| 32 | no shut | all | trunk | disable | |
| 33 | no shut | all | trunk | disable | LAG 1 |
| 34 | no shut | all | trunk | disable | LAG 1 |
| 35 | no shut | all | trunk | disable | LAG 1 |
| 36 | no shut | all | trunk | disable | LAG 1 |
| 37 | no shut | all | trunk | disable | LAG 2 |
| 38 | no shut | all | trunk | disable | LAG 2 |
| 39 | no shut | all | trunk | disable | LAG 2 |
| 40 | no shut | all | trunk | disable | LAG 2 |
| 41 | no shut | all | trunk | disable | LAG 2 |
| 42 | no shut | all | trunk | disable | LAG 2 |
| 43 | no shut | all | trunk | disable | LAG 2 |
| 44 | no shut | all | trunk | disable | LAG 2 |
| 45 | no shut | all | trunk | disable | |
| 46 | no shut | all | trunk | disable | |
| 47 | no shut | all | trunk | disable | |
| 48 | no shut | 16 | access | enable | ルーテッドポート |

#### その他
- SSHサーバを有効化
- HTTPサーバを無効化
- snmpサーバを有効化, コミュニティ名: univerge

### L2スイッチ (Cisco Catalyst 2960 Plus 24TC-L)
- VLAN10, 20, 30, 70, 71, 72, 99を設定
- SSHサーバを有効化
- HTTPサーバを無効化
- IPアドレス1: 192.168.99.2/24, VLAN ID: 99
- IPアドレス2: 192.168.10.2/24, VLAN ID: 10
#### ポート
- Gi0/1-2をトランクポートに設定
- Gi0/2はNative VLANを99に設定
- Fa0/1-24をアクセスポート, VLAN IDを10に設定

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| Fa0/1 | no shut | 10 | access | enable | |
| Fa0/2 | no shut | 10 | access | enable | |
| Fa0/3 | no shut | 10 | access | enable | |
| Fa0/4 | no shut | 10 | access | enable | |
| Fa0/5 | no shut | 10 | access | enable | |
| Fa0/6 | no shut | 10 | access | enable | |
| Fa0/7 | no shut | 10 | access | enable | |
| Fa0/8 | no shut | 10 | access | enable | |
| Fa0/9 | no shut | 10 | access | enable | |
| Fa0/10 | no shut | 10 | access | enable | |
| Fa0/11 | no shut | 10 | access | enable | |
| Fa0/12 | no shut | 10 | access | enable | |
| Fa0/13 | no shut | 10 | access | enable | |
| Fa0/14 | no shut | 10 | access | enable | |
| Fa0/15 | no shut | 10 | access | enable | |
| Fa0/16 | no shut | 10 | access | enable | |
| Fa0/17 | no shut | 10 | access | enable | |
| Fa0/18 | no shut | 10 | access | enable | |
| Fa0/19 | no shut | 10 | access | enable | |
| Fa0/20 | no shut | 10 | access | enable | |
| Fa0/21 | no shut | 10 | access | enable | |
| Fa0/22 | no shut | 10 | access | enable | |
| Fa0/23 | no shut | 10 | access | enable | |
| Fa0/24 | no shut | 10 | access | enable | |
| Gi0/1 | no shut | all | trunk | disable | |
| Gi0/2 | no shut | all | trunk | disable | Native VLAN: 99 |

### L2スイッチ (Allied Telesis AT-x210-24GT)
- VLAN10, 20, 30, 70, 71, 72, 99を設定
- SSHサーバを有効化
- HTTPサーバを無効化
#### ポート
- port1.0.17-24をLAGに設定
- port1.0.15-24をトランクポートに設定
- port1.0.13-14をアクセスポート, VLAN IDを99に設定
- port1.0.5-12をアクセスポート, VLAN IDを20に設定
- port1.0.1-4をアクセスポート, VLAN IDを30に設定

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| port1.0.1 | no shut | 30 | access | enable | |
| port1.0.2 | no shut | 30 | access | enable | |
| port1.0.3 | no shut | 30 | access | enable | |
| port1.0.4 | no shut | 30 | access | enable | |
| port1.0.5 | no shut | 20 | access | enable | |
| port1.0.6 | no shut | 20 | access | enable | |
| port1.0.7 | no shut | 20 | access | enable | |
| port1.0.8 | no shut | 20 | access | enable | |
| port1.0.9 | no shut | 20 | access | enable | |
| port1.0.10 | no shut | 20 | access | enable | |
| port1.0.11 | no shut | 20 | access | enable | |
| port1.0.12 | no shut | 20 | access | enable | |
| port1.0.13 | no shut | 99 | access | enable | |
| port1.0.14 | no shut | 99 | access | enable | |
| port1.0.15 | no shut | all | trunk | disable | |
| port1.0.16 | no shut | all | trunk | disable | |
| port1.0.17 | no shut | all | trunk | disable | LAG |
| port1.0.18 | no shut | all | trunk | disable | LAG |
| port1.0.19 | no shut | all | trunk | disable | LAG |
| port1.0.20 | no shut | all | trunk | disable | LAG |
| port1.0.21 | no shut | all | trunk | disable | LAG |
| port1.0.22 | no shut | all | trunk | disable | LAG |
| port1.0.23 | no shut | all | trunk | disable | LAG |
| port1.0.24 | no shut | all | trunk | disable | LAG |

### L2スイッチ (Allied Telesis GS924M V2) #5
- VLAN10, 20, 30, 70, 71, 72, 99を設定
- HTTPサーバを有効化
- IPアドレス: 192.168.99.5/24, VLAN ID: 99
#### ポート
- port21-24をLAGに設定
- port15-16, 21-24をトランクポートに設定
- port19-20をアクセスポート, VLAN IDを99に設定
- port17-18をアクセスポート, VLAN IDを30に設定
- port1-14をアクセスポート, VLAN IDを20に設定

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | no shut | 20 | access | enable | |
| 2 | no shut | 20 | access | enable | |
| 3 | no shut | 20 | access | enable | |
| 4 | no shut | 20 | access | enable | |
| 5 | no shut | 20 | access | enable | |
| 6 | no shut | 20 | access | enable | |
| 7 | no shut | 20 | access | enable | |
| 8 | no shut | 20 | access | enable | |
| 9 | no shut | 20 | access | enable | |
| 10 | no shut | 20 | access | enable | |
| 11 | no shut | 20 | access | enable | |
| 12 | no shut | 20 | access | enable | |
| 13 | no shut | 20 | access | enable | |
| 14 | no shut | 20 | access | enable | |
| 15 | no shut | all | trunk | disable | |
| 16 | no shut | all | trunk | disable | |
| 17 | no shut | 30 | access | enable | |
| 18 | no shut | 30 | access | enable | |
| 19 | no shut | 99 | access | enable | |
| 20 | no shut | 99 | access | enable | |
| 21 | no shut | all | trunk | disable | LAG |
| 22 | no shut | all | trunk | disable | LAG |
| 23 | no shut | all | trunk | disable | LAG |
| 24 | no shut | all | trunk | disable | LAG |

### L2スイッチ (Allied Telesis GS924M V2) #6
- VLAN10, 20, 30, 70, 71, 72, 99を設定
- HTTPサーバを有効化
- IPアドレス: 192.168.99.6/24, VLAN ID: 99
#### ポート
- port15, 16, 23, 24をトランクポートに設定
- port1-14をアクセスポート, VLAN IDを20に設定
- port17-20をアクセスポート, VLAN IDを30に設定
- port21, 22をアクセスポート, VLAN IDを99に設定

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | no shut | 20 | access | enable | |
| 2 | no shut | 20 | access | enable | |
| 3 | no shut | 20 | access | enable | |
| 4 | no shut | 20 | access | enable | |
| 5 | no shut | 20 | access | enable | |
| 6 | no shut | 20 | access | enable | |
| 7 | no shut | 20 | access | enable | |
| 8 | no shut | 20 | access | enable | |
| 9 | no shut | 20 | access | enable | |
| 10 | no shut | 20 | access | enable | |
| 11 | no shut | 20 | access | enable | |
| 12 | no shut | 20 | access | enable | |
| 13 | no shut | 20 | access | enable | |
| 14 | no shut | 20 | access | enable | |
| 15 | no shut | all | trunk | disable | |
| 16 | no shut | all | trunk | disable | |
| 17 | no shut | 30 | access | enable | |
| 18 | no shut | 30 | access | enable | |
| 19 | no shut | 30 | access | enable | |
| 20 | no shut | 30 | access | enable | |
| 21 | no shut | 99 | access | enable | |
| 22 | no shut | 99 | access | enable | |
| 23 | no shut | all | trunk | disable | |
| 24 | no shut | all | trunk | disable | |

### Wi-Fiアクセスポイント (Cisco Aironet 2700)
- VLAN10, 20, 30, 99を設定
- SSHサーバを有効化
- HTTPサーバを無効化
- IPアドレス: 192.168.99.254/24, VLAN ID: 99
- SSIDとVLAN IDの対応は以下の通り

| SSID | VLAN ID |
| ------- | --- |
| TechnoTUT_DJ | 10 |
| TechnoTUT_VJ | 20 |
| TechnoTUT_LED | 30 |
| TechnoTUT_GoPro | 70 |
| TechnoTUT_Cam1 | 71 |
| TechnoTUT_Cam2 | 72 |

- Native VLANは99に設定
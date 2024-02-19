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
- GE0.0: ip address dhcp receive-default
- GE3.0: ip address 192.168.16.1/30
#### ACL
- 192.168.99.0/24, 10.244.0.0/16, 192.168.20.100/32　のWAN通信を許可, それ以外は拒否
https://changineer.info/network/nec_ix/nec_ix_firewall_basic.html
```shell-session
Router(config)# ip access-list permit-wan-in permit ip src 192.168.8.1 dest <dest-ip-addr> 
Router(config)# ip access-list permit-wan-out permit ip src <source-ip-addr> dest 192.168.8.1
Router(config)# ip access-list implicit-deny deny ip src any dest any
Router(config)# interface GigaEthernet 0.0
Router(config-if)# ip access-list <acl-name> 1 in
Router(config-if)# ip access-list <acl-name> 2 in
Router(config-if)# ip access-list <acl-name> 1 out
Router(config-if)# ip access-list <acl-name> 2 out
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
DNS: 192.168.10.1  
lease-time: 10800  
備考: L2スイッチ(CIsco Catalyst 2960 Plus 24TC-L)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  
##### VLAN20
VJ用VLAN  
192.168.20.0/24
DHCP: 192.168.20.101 - 192.168.20.200  
Gateway: 192.168.20.1  
DNS: 192.168.20.1  
lease-time: 86400  
備考: L3スイッチ(Allied Telesis AT-x600-48Ts)をIGMP Snooping Querierに設定, IGMP Snooping有効, アクセスポートのSTP Portfast有効  
##### VLAN30
LED制御用VLAN
192.168.11.0/24  
DHCP: 無効
Gateway: 192.168.11.1  
DNS: 192.168.11.1  
備考: IGMP Snooping無効, アクセスポートのSTP Portfast有効  
##### VLAN99
管理用VLAN  
192.168.99.0/24  
DHCP: 192.168.99.101 - 192.168.99.200  
Gateway: 192.168.99.1  
DNS: 192.168.99.1  
lease-time: 3600  
備考: IGMP Snooping無効, アクセスポートのSTP Portfast有効  
#### ポート
- port1.0.1-36はシャットダウン (未使用)
- port1.0.37, 38をアクセスポート, VLAN IDを99に設定
- port1.0.43, port1.0.44をLAGに設定
- port1.0.39-47をトランクポートに設定
- port1.0.48はルーテッドポート

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| port1.0.1 | shut | - | - | - | 未使用 |
| port1.0.2 | shut | - | - | - | 未使用 |
| port1.0.3 | shut | - | - | - | 未使用 |
| port1.0.4 | shut | - | - | - | 未使用 |
| port1.0.5 | shut | - | - | - | 未使用 |
| port1.0.6 | shut | - | - | - | 未使用 |
| port1.0.7 | shut | - | - | - | 未使用 |
| port1.0.8 | shut | - | - | - | 未使用 |
| port1.0.9 | shut | - | - | - | 未使用 |
| port1.0.10 | shut | - | - | - | 未使用 |
| port1.0.11 | shut | - | - | - | 未使用 |
| port1.0.12 | shut | - | - | - | 未使用 |
| port1.0.13 | shut | - | - | - | 未使用 |
| port1.0.14 | shut | - | - | - | 未使用 |
| port1.0.15 | shut | - | - | - | 未使用 |
| port1.0.16 | shut | - | - | - | 未使用 |
| port1.0.17 | shut | - | - | - | 未使用 |
| port1.0.18 | shut | - | - | - | 未使用 |
| port1.0.19 | shut | - | - | - | 未使用 |
| port1.0.20 | shut | - | - | - | 未使用 |
| port1.0.21 | shut | - | - | - | 未使用 |
| port1.0.22 | shut | - | - | - | 未使用 |
| port1.0.23 | shut | - | - | - | 未使用 |
| port1.0.24 | shut | - | - | - | 未使用 |
| port1.0.25 | shut | - | - | - | 未使用 |
| port1.0.26 | shut | - | - | - | 未使用 |
| port1.0.27 | shut | - | - | - | 未使用 |
| port1.0.28 | shut | - | - | - | 未使用 |
| port1.0.29 | shut | - | - | - | 未使用 |
| port1.0.30 | shut | - | - | - | 未使用 |
| port1.0.31 | shut | - | - | - | 未使用 |
| port1.0.32 | shut | - | - | - | 未使用 |
| port1.0.33 | shut | - | - | - | 未使用 |
| port1.0.34 | shut | - | - | - | 未使用 |
| port1.0.35 | shut | - | - | - | 未使用 |
| port1.0.36 | shut | - | - | - | 未使用 |
| port1.0.37 | no shut | 99 | access | enable | |
| port1.0.38 | no shut | 99 | access | enable | |
| port1.0.39 | no shut | all | trunk | disable | |
| port1.0.40 | no shut | all | trunk | disable | |
| port1.0.41 | no shut | all | trunk | disable | |
| port1.0.42 | no shut | all | trunk | disable | |
| port1.0.43 | no shut | all | trunk | disable | LAGに設定 |
| port1.0.44 | no shut | all | trunk | disable | LAGに設定 |
| port1.0.45 | no shut | all | trunk | disable | |
| port1.0.46 | no shut | all | trunk | disable | |
| port1.0.47 | no shut | all | trunk | disable | |
| port1.0.48 | no shut | none | routed | - | ルーテッドポート |

#### その他
- SSHサーバを有効化
- HTTPサーバを無効化
- snmpサーバを有効化, コミュニティ名: univerge

### L2スイッチ (Cisco Catalyst 2960 Plus 24TC-L)
- VLAN10, 20, 30, 99を設定
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
- VLAN10, 20, 30, 99を設定
- SSHサーバを有効化
- HTTPサーバを無効化
#### ポート
- port1.0.15-16をLAGに設定
- port1.0.15-16, port1.0.23-24をトランクポートに設定
- port1.0.1-14, port1.0.17-20をアクセスポート, VLAN IDを20に設定
- port1.0.21-22をアクセスポート, VLAN IDを99に設定

| IF | shut/no shut | VLAN ID | mode | portfast | 備考 |
| --- | --- | --- | --- | --- | --- |
| port1.0.1 | no shut | 20 | access | enable | |
| port1.0.2 | no shut | 20 | access | enable | |
| port1.0.3 | no shut | 20 | access | enable | |
| port1.0.4 | no shut | 20 | access | enable | |
| port1.0.5 | no shut | 20 | access | enable | |
| port1.0.6 | no shut | 20 | access | enable | |
| port1.0.7 | no shut | 20 | access | enable | |
| port1.0.8 | no shut | 20 | access | enable | |
| port1.0.9 | no shut | 20 | access | enable | |
| port1.0.10 | no shut | 20 | access | enable | |
| port1.0.11 | no shut | 20 | access | enable | |
| port1.0.12 | no shut | 20 | access | enable | |
| port1.0.13 | no shut | 20 | access | enable | |
| port1.0.14 | no shut | 20 | access | enable | |
| port1.0.15 | no shut | all | trunk | disable | port1.0.16とLAGに設定 |
| port1.0.16 | no shut | all | trunk | disable | port1.0.15とLAGに設定 |
| port1.0.17 | no shut | 20 | access | enable | |
| port1.0.18 | no shut | 20 | access | enable | |
| port1.0.19 | no shut | 20 | access | enable | |
| port1.0.20 | no shut | 20 | access | enable | |
| port1.0.21 | no shut | 99 | access | enable | |
| port1.0.22 | no shut | 99 | access | enable | |
| port1.0.23 | no shut | all | trunk | disable | |
| port1.0.24 | no shut | all | trunk | disable | |

### L2スイッチ (Allied Telesis GS924M V2) #5
- VLAN10, 20, 30, 99を設定
- HTTPサーバを有効化
- IPアドレス: 192.168.99.5/24, VLAN ID: 99
#### ポート
- port15, 16, 23, 24をトランクポートに設定
- port1-14, 17-20をアクセスポート, VLAN IDを20に設定
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
| 17 | no shut | 20 | access | enable | |
| 18 | no shut | 20 | access | enable | |
| 19 | no shut | 20 | access | enable | |
| 20 | no shut | 20 | access | enable | |
| 21 | no shut | 99 | access | enable | |
| 22 | no shut | 99 | access | enable | |
| 23 | no shut | all | trunk | disable | |
| 24 | no shut | all | trunk | disable | |

### L2スイッチ (Allied Telesis GS924M V2) #6
- VLAN10, 20, 30, 99を設定
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

- Native VLANは99に設定
---
title: 仮想基盤
sidebar_position: 1
---
# Virtual Environment
[Proxmox VE](https://www.proxmox.com/proxmox-ve) を使用して、仮想基盤を構築します。DVDまたはUSBメモリからインストールします。  
インストール後、Webブラウザからアクセスし、設定を行います。  
https://192.168.99.99:8006/

#### ネットワーク
サーバは、L3スイッチにトランク接続されています。  
サーバ内の仮想マシン・コンテナは、任意のVLANに所属させることができます。
サーバをトランク接続する際は、以下の手順で`openvswitch`を設定します。  
```bash
apt update
apt install openvswitch-switch
```

Web UIの [対象ノード] > システム > ネットワーク を開きます。  
| 名前 | 種別 | ブリッジポート | VLAN ID |
| --- | --- | --- | --- |
| [NIC] | OVS Port | vmbr0 | - |
| vmbr0 | OVS Bridge | [NIC] [vlan99] | - |
| vlan99 | OVS IntPort | vmbr0 | 99 | 

#### リポジトリ
Web UIの [対象ノード] > アップデート > リポジトリ を開きます。  
`enterprise` と `pve-enterprise` を削除し、`no-subscription` を追加します。  

## 物理構成図
イベント時  
![](/network/design/utone.drawio.svg)  
部室運用時  
![](/network/design/clubroom.drawio.svg)

## 論理設計
![](/network/design/utone.logic.drawio.svg)
![](/network/design/clubroom.logic.drawio.svg)

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
DJ, VJ, LED制御, サーバ用の4つのVLANを設定しています。  
各VLANはルータ(イベント時はAllied Telesis AT-x600-48Ts、部室運用時はCisco 891FJ-K9)でルーティングしています。  
---
title: 概要
slug: /
sidebar_position: 1
---
# About
TechnoTUT Networkは、部室及びThe Utopia Tone(学内DJイベント)で利用可能なIP(インターネットプロトコル)ネットワークです。  
音声・映像等のメディアの伝送や会場内に設置された機器のコントロールなど、あらゆる情報を送ることができます。一部のネットワーク機器はPoE(Power over Ethernet)に対応し、機器への電源供給が可能です。  

TechnoTUT NOCでは、DJ機器との通信に用いるPRO DJ LINKや、映像伝送プロトコルであるNDI・RTMP、複数デバイスで拍・テンポを同期するAbleton Link、照明制御用のプロトコルであるArt-Net、PAの要であるデジタルミキサーの制御通信などを流すためのネットワークを、ネットワーク仮想化技術であるVLANを用いて統合したシステムを構築しています。また、スパニングツリープロトコルやリンクアグリゲーションといったL2冗長化技術を取り入れることで、機器故障やケーブルの断線時にもサービスへの影響を最小限に抑える取り組みも行っています。

この章ではTechnoTUT Networkそのものについて記述します。  
TechnoTUT Network網内で提供している計算機環境については[Computing](/computing)を、サービスについては[Service](/service)をご覧ください。


このページ及び図・コードは、TechnoTUTの[GitHubリポジトリ](https://github.com/TechnoTUT/Infrastructure)で管理されています。  
[![TechnoTUT/Infrastructure - GitHub](https://gh-card.dev/repos/TechnoTUT/Infrastructure.svg?fullname=)](https://github.com/TechnoTUT/Infrastructure)

## Our Mission
### 1. 安定したネットワークの提供
TechnoTUT Networkは、学内DJイベントであるThe Utopia Toneを運営する上での重要なインフラです。ネットワークサービスの停止は、DJ・VJ・照明・PA・映像配信に大きな影響を与えます。障害時にもサービスを継続し、演出への影響を最小限に抑えることができるような堅牢で安定したネットワークの構築を目指します。リアルタイムでの監視・ログ解析も行い、イベントの安全な運営を支えます。
### 2. 演出支援・自動制御
PRO DJ LINKやAbleton Linkによって、DJ・VJ・照明システムの拍・テンポを同期することができます。このように異なる役割のシステムを連携させることで、演出の一体感を向上させ、より没入感のある音楽体験を提供します。また、OSC（Open Sound Control）を活用し、照明や映像の自動制御を可能にすることで、リアルタイムのパフォーマンスを支援します。
### 3. 会場内映像配信システムの提供
NDI（Network Device Interface）やRTMPを活用した高品質な映像の伝送環境を提供します。IPネットワークによるデータ転送によって、撮影機材の映像ケーブルを削減し、ケーブル長に縛られない自由な機材配置と安価な配信システムの構築を実現します。
### 4. 分散処理による高負荷処理の実行
ネットワークを活用することで、複数の計算機に処理を分散し1台の計算機では不可能な処理を実行できます。これにより、大規模な映像処理を可能にし、イベントの演出や技術的な革新を支援します。
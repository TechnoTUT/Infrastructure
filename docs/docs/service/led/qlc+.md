---
title: QLC+
sidebar_position: 2
---
## 環境
- Fedora 41
- Ubuntu 24.04

## 用意するもの
[DSD TECH USB-DMX インターフェイス ケーブル (FTDI チップ付き) - 5.9 フィート](https://amzn.asia/d/9MWJkWo)

## インストール
以下の手順に従います。  
[Download | QLC+ by Massimo Callegari](https://www.qlcplus.org/download)

### Fedora 41

```bash
$ sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:mcallegari79/Fedora_40/home:mcallegari79.repo
$ sudo dnf install qlcplus-qt5
```

### Ubuntu 24.04

```bash
$ echo 'deb http://download.opensuse.org/repositories/home:/mcallegari79/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:mcallegari79.list
$ curl -fsSL https://download.opensuse.org/repositories/home:mcallegari79/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_mcallegari79.gpg > /dev/null
$ sudo apt update
$ sudo apt install qlcplus-qt5
```

## 設定ファイルの取得

```bash
$ git clone https://github.com/TechnoTUT/dotqlcplus.git
$ mv dotqlcplus/fixtures/* .qlcplus/fixtures/
$ mv dotqlcplus/TheUtopiaTone.qxw .qlcplus/
```

これで、qlcplusを起動し、 `~/.qlcplus/TheUtopiaTone.qxw` を開けば準備は完了です！
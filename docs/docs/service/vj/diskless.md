---
title: ディスクレスシステム
sidebar_position: 4
---
:::caution
このサービスは廃止されました。
:::
網内では、ネットワーク起動によるディスクレスシステムを提供していました。  
クライアントコンピュータには、HDDを搭載する必要がない上、OSのインストール・アップデートも不要です。  
アプリケーションの追加やOSのインストール・アップデートは、ディスクレスシステムサーバを操作するだけですべてのコンピュータに適用されます。  

## 使用方法
1. コンピュータにLANケーブルと電源ケーブルを接続します。
2. 電源を投入します。自動でネットワークブートが開始され、OSが起動します。　　
:::info
コンピュータを追加する場合は、BIOS/UEFIの設定で、ネットワークブートを有効かつ最優先に設定してください。
:::
:::tip
ディスクレスシステムを利用するためには、PXEに対応したコンピュータが必要です。  
MacやPXEに対応していないコンピュータは、iPXEを利用することで利用できる可能性があります。
:::

## アプリケーションの追加・アップデート
ディスクレスシステムサーバにログインし、アプリケーションの追加やアップデートを行います。
1. ブラウザで https://192.168.99.99:8006 にアクセスし、[仮想基盤](/service/virtualization)にログインします。
2. `VM901 (ltsp)` を選択し、`コンソール` をクリックします。  
3. CLIからGUI起動に切り替えます。  
```bash
systemctl set-default graphical.target
reboot
```
4. アプリケーションの追加やアップデートを行います。
5. 起動イメージの更新を行います。  
```bash
ltsp image /
ltsp ipxe
ltsp nfs
ltsp initrd
```
6. GUIからCLI起動に切り替えます。  
```bash
systemctl set-default multi-user.target
reboot
```

## 構築
構築には、[Linux Terminal Server Project (LTSP)](https://ltsp.org/) を利用します。  
OSは、[Ubuntu](https://ubuntu.com/) を利用します。これは、LTSPと[OBS Studio](https://obsproject.com/) が利用できるためです。  
[![ltsp/ltsp - GitHub](https://gh-card.dev/repos/ltsp/ltsp.svg?fullname=)](https://github.com/ltsp/ltsp)  
1. [仮想基盤](/service/virtualization)にログインして、VMを作成します。
2. Ubuntuをインストールします。デスクトップ環境を導入します。
3. Snapを削除します。以下のスクリプトを実行します。  
```bash
re() {
    if ! "$@"; then
        echo "Command failed: $*" >&2
        exit 1
    fi
}

remove_snap() {
    local packages

    if [ -x /usr/bin/mate-session ]; then
        packages=$(dpkg-query -W -f='${Package} ${Version}\n' arctica-greeter-guest-session ayatana-indicator-application evolution-common indicator-application mate-hud 2>/dev/null | awk '$2 { print $1 }') || true
        if [ -n "$packages" ]; then
            echo "Removing some MATE cruft: $packages"
            re apt-get purge --yes --auto-remove $packages
        fi
    fi
    if [ -x /usr/bin/snap ]; then
        if [ -f /var/lib/snapd/desktop/applications/firefox_firefox.desktop ] &&
            [ ! -L /var/lib/snapd/desktop/applications/firefox_firefox.desktop ]; then
            echo "Replacing Firefox snap with deb using MozillaTeam PPA"
            # Remove firefox before snapd to work around LP: #1998710
            snap remove firefox 2>/dev/null || true
            re add-apt-repository --yes ppa:mozillateam/ppa
            echo 'Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001' >/etc/apt/preferences.d/60mozillateam-ppa
            # If you need more locales e.g. firefox-locale-el add them in this line
            re apt-get install --yes firefox firefox-locale-en
            if [ -f /usr/share/mate/applications/firefox.desktop ]; then
                re dpkg-divert --package sch-scripts --divert \
                    /usr/share/mate/applications/firefox-desktop.diverted \
                    --rename /usr/share/mate/applications/firefox.desktop
            fi
        fi
        # Remove snapd, THEN provide a symlink to deb firefox for panels etc
        re apt-get purge --yes --auto-remove snapd
        if [ ! -e /var/lib/snapd/desktop/applications/firefox_firefox.desktop ]; then
            re mkdir -p /var/lib/snapd/desktop/applications
            re ln -s /usr/share/applications/firefox.desktop /var/lib/snapd/desktop/applications/firefox_firefox.desktop
        fi
    fi
}

remove_snap
```
4. LTSP PPAを追加します。  
```bash
add-apt-repository ppa:ltsp
apt update
```
5. LTSPをインストールします。  
```bash
apt install --install-recommends ltsp ltsp-binaries dnsmasq nfs-kernel-server openssh-server squashfs-tools ethtool net-tools epoptes
gpasswd -a administrator epoptes
```
6. 2つ以上のNICが存在する場合は、nmtuiでLTSPを有効にするNICのIPアドレスを`192.168.67.1`に設定します。
```bash
nmtui
ltsp dnsmasq --proxy-dhcp=0
```
7. LTSPを設定します。  
```bash
ltsp image /
ltsp ipxe
ltsp nfs
ltsp initrd
```
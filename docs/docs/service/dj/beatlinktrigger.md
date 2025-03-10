---
title: Beat Link Trigger
sidebar_position: 2
---
## Beat Link Trigger とは
Beat Link Trigger は、AlphaTheta(Pioneer DJ)のDJ機器と連携し、曲情報を取得するためのツールです。  
コンピュータで仮想的なCDJを作成し、[PRO DJ LINK](/service/dj/prodjlink)を用いて情報を取得します。  
[![Deep-Symmetry/beat-link-trigger - GitHub](https://gh-card.dev/repos/Deep-Symmetry/beat-link-trigger.svg?fullname=)](https://github.com/Deep-Symmetry/beat-link-trigger)  
[TechnoTUT Network](/)では、[Linux Container](/service/virtualization)を利用したDebian GUI環境を提供しており、その環境でBeat Link Triggerを利用することができます。  

## 機能
Beat Link Trigger は以下の機能を提供します。  
- 曲情報・波形情報の取得・表示
- [Ableton Linkによる対応外部機器とのBPM情報の共有](/service/vj/abletonlink)
- [OSCによる対応外部機器との取得情報の共有](/service/vj/osc)
- httpによる取得情報の共有

## 使用方法
1. [TechnoTUT Network](/)に接続します。  
2. Debian GUI環境に接続します。  
   `blt.intra.technotut.net`へリモートデスクトップ接続するか、`blt.intra.technotut.net:5901`へVNC接続またはブラウザで https://blt.intra.technotut.net/ にアクセスします。
3. デスクトップの`start.sh`を実行してBeat Link Triggerを起動します。  
    起動すると、自動で曲情報・波形情報が表示されます。  
   ![Beat Link Trigger](/img/service/beat-link-trigger_trackinfo.jpg)

何らかの不具合が発生した場合は、一度ウィンドウを閉じて再度`start.sh`を実行してください。  

## 開発者向け情報

### 各種機能の起動自動化

[Triggers Global Expressions :: Beat Link Trigger User Guide](https://blt-guide.deepsymmetry.org/beat-link-trigger/0.6.3/Expressions_TriggerGlobal.html)

Global Setup Expression

```clojure
(set-overlay-background-color (Color. 0 0 0 0))
(swap! globals assoc :player-status-always-on-top true)
(swap! globals assoc :player-status-columns 2)
(when (.isRunning (VirtualCdj/getInstance))
  (beat-link-trigger.triggers/show-player-status))
```

Came Online Expression

```clojure
(triggers/show-player-status)
(overlay/run-server)
(beat-link-trigger.carabiner/show-window nil)  
(beat-link-trigger.carabiner/connect)  
(beat-link-trigger.carabiner/sync-mode :passive)  
(beat-link-trigger.carabiner/sync-link true)  
(beat-link-trigger.carabiner/align-bars true)
```

### OSCによるBPM情報の取得

[Example: Send OSC message on each beat](https://github.com/Deep-Symmetry/beat-link-trigger/wiki/Example:-Send-OSC-message-on-each-beat)

Master PlayerのExpressionを設定します.

Setup Expression

```clojure
(swap! locals assoc :restap (osc/osc-client "<IP>" <PORT>))
```

Beat Expression

```clojure
(when trigger-active?
  (osc/osc-send (:restap @locals) "/osc/path" 1.0))
```

Shutdown Expression

```clojure
(osc/osc-close (:restap @locals))
```

### OSCによる曲名情報の取得

Master PlayerのExpressionを設定します.

Setup Expression

```clojure
(swap! locals assoc :oscblt (osc/osc-client "<IP>" <PORT>)) 
```

Tracked Update Expression

```clojure
(let [metadata track-metadata]
	(swap! locals update-in [:oscmetadata]
		(fn [old-metadata]
			(when (not= metadata old-metadata)
				(osc/osc-send (:oscblt @locals) "/osc/path" track-artist track-title))
			metadata)))
```

Shutdown Expression

```clojure
(osc/osc-close (:oscblt @locals))
```

## 環境構築
新たにDebian GUI環境を構築し、Beat Link Triggerを利用する場合は、以下の手順に従います。  
事前にDebianのテンプレートでLXCを作成します。  
```bash  
# rootに入る
su -
cd ~
# パッケージの更新・インストール
apt update -y && apt upgrade -y
apt install -y task-xfce-desktop dbus-x11 tigervnc-standalone-server xrdp novnc python3-websockify
# xrdpの設定
vi /etc/xrdp/xrdp.ini
```
```ini
[Xvnc]
name=Xvnc
lib=libvnc.so
username=root
password=<your-password>
ip=127.0.0.1
port=5901
```
```bash
# xrdpの自動起動設定
systemctl enable xrdp
# VNCのパスワード設定
vncpasswd
# Javaのインストール
apt-get install -y openjdk-21-jdk
# noVNC用の証明書作成
mkdir .blt && cd ~/.blt && openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout novnc.pem -out novnc.pem -days 3650 -subj "/C=JP/ST=Aichi/L=Toyohashi/O=TechnoTUT/OU=Network/CN=blt.intra.technotut.net"
# Beat Link Triggerのインストール
cd ~ && wget https://github.com/Deep-Symmetry/beat-link-trigger/releases/download/v7.3.0/beat-link-trigger-7.3.0.jar
cd ~/.blt && wget https://gist.githubusercontent.com/brunchboy/223f99e39d832e0ca94c09eab3b04134/raw/3f0cec096e09a0dbe7b5f3010cb061fdcbcd774f/overlay.html && wget https://raw.githubusercontent.com/TechnoTUT/Infrastructure/main/server/beat-link-trigger/config.blt
# 自動起動設定
crontab -e
```
```crontab
@reboot sleep 45 && tigervncserver -xstartup /usr/bin/xfce4-session -localhost no :1 && websockify -D --web /usr/share/novnc/ --cert /root/.blt/novnc.pem 443 localhost:5901
```
設定が完了したら、Proxmox VEのWebUIからLXCを再起動します。
```bash
# 開始スクリプトの作成
cat << 'EOF' > /root/Desktop/start.sh
#!/bin/bash
java -jar /root/beat-link-trigger-7.3.0.jar --config /root/.blt/config.blt
EOF
# 実行権限の付与
chmod +x /root/Desktop/start.sh
```
---
title: 録画・配信
sidebar_position: 5
---
## RTMP

部室のSONY製カメラ, GoProからのカメラ映像の転送にはRTMPを利用可能.

### RTMP (**Real Time Messaging Protocol**) とは

[Real Time Messaging Protocol](https://ja.wikipedia.org/wiki/Real_Time_Messaging_Protocol)

> RTMP (RTMFP を除く) は [TCP](https://ja.wikipedia.org/wiki/Transmission_Control_Protocol) 上のプロトコルで、持続的接続を使い、（[HTTP](https://ja.wikipedia.org/wiki/HTTP)との比較で）低レイテンシ通信を実現する。ストリームをスムーズに配信し、できるだけ多くの情報を送れるようにするために、ストリームをフラグメントに分割し、そのサイズはクライアントとサーバーの間で動的に交渉する。
> 

### RTMP配信サーバー

TechnoTUTでは, Nginx(ｴﾝｼﾞﾝｴｯｸｽ)というWebサーバーソフトウェアを利用したRTMPサーバーをKubernetes上で運用している.

[GitHub - TechnoTUT/rtmp-live-server: Easily set up a live server with container.](https://github.com/TechnoTUT/rtmp-live-server)

[k3s/manifest/live at main · TechnoTUT/k3s](https://github.com/TechnoTUT/k3s/tree/main/manifest/live)

この配信サーバーを介して映像を取得する.  

各カメラからの配信/受信状況は `http://live.kube.technotut.net/stat` から確認できる.

### SONY製カメラからの配信

> 動画、静止画の撮影画面で、[MENU] →［ワイヤレス］→［ 機能］→［ライブストリーミング］を選ぶ。
> 

> START/STOPボタンを押して配信を開始する。
配信準備中には［接続中］の表示と登録されているSSIDが表示され、配信が開始されると [LIVE] が表示されます。
> 

> 配信を停止するには、もう一度START/STOPボタンを押す。
配信の停止が完了するまでは [LIVE] が点滅表示されます。
> 

[ヘルプガイド | ライブストリーミングを実行する](https://helpguide.sony.net/cam/1610/v1/ja/contents/TP0000949148.html)

映像は, `rtmp://live.kube.technotut.net/live/cam1` 及び 
`rtmp://live.kube.technotut.net/live/cam2` に配信される. 

### GoProからの配信

スマートフォンにGoPro Quikをインストールし, `rtmp://live.kube.technotut.net/live/`, ストリームキー `gopro` に配信する. GoProは Wi-Fi: `TechnoTUT_GoPro` に接続する.

[GoPro Support](https://community.gopro.com/s/article/How-To-Live-Stream-From-Your-GoPro?language=ja)

映像は, `rtmp://live.kube.technotut.net/live/gopro` に配信される.

### OBSでの映像の受信

ソース: `メディアソース` を追加し, `ローカルファイル` のチェックを解除, `入力` に受信したいカメラの映像URLを入力. カメラとURLの対応は以下の通り.

- SONY-1: rtmp://live.kube.technotut.net/live/cam1
- SONY-2: rtmp://live.kube.technotut.net/live/cam2
- GoPro: rtmp://live.kube.technotut.net/live/gopro

### トラブルシューティング

- SONY製カメラがWi-Fi: `TechnoTUT_Cam1` または `TechnoTUT_Cam2` に接続できない
→以下の手順でWi-Fi接続情報を再設定する.

1. Windows PCで Sony-PMCA-REを利用してカメラに以下の資格情報を書き込む.
    
    [Releases · ma1co/Sony-PMCA-RE](https://github.com/ma1co/Sony-PMCA-RE/releases)
    
    ```yaml
    [
        [
            "twitterEnabled",
            0
        ],
        [
            "twitterConsumerKey",
            ""
        ],
        [
            "twitterConsumerSecret",
            ""
        ],
        [
            "twitterAccessToken1",
            ""
        ],
        [
            "twitterAccessTokenSecret",
            ""
        ],
        [
            "twitterMessage",
            "Live Streaming from Handycam by Sony"
        ],
        [
            "facebookEnabled",
            0
        ],
        [
            "facebookAccessToken",
            ""
        ],
        [
            "facebookMessage",
            "Live Streaming from Handycam by Sony"
        ],
        [
            "service",
            0
        ],
        [
            "enabled",
            1
        ],
        [
            "macId",
            "1234567890123456789012345678901234567890"
        ],
        [
            "macSecret",
            "123456789012345678901234567890123467890"
        ],
        [
            "macIssueTime",
    		"a9315a5f00000000"
        ],
        [
            "unknown",
            1
        ],
        [
            "channels",
            [
                12345678
            ]
        ],
        [
            "shortURL",
            "http://ustre.am/1AAAA"
        ],
        [
            "videoFormat",
            3
        ],
        [
            "supportedFormats",
            [
                1,
                3
            ]
        ],
        [
            "enableRecordMode",
            0
        ],
        [
            "videoTitle",
            "Test"
        ],
        [
            "videoDescription",
            "Test"
        ],
        [
            "videoTag",
            "Test"
        ]
    ]
    ```
    
    上の設定情報を `stream.cfg` として保存する. 
    カメラをUSBで接続して, 以下のコマンドで書き込む.
    
    ```powershell
    pmca-console-v0.18-win.exe stream -w stream.cfg
    ```
    
    2. Wi-Fiの設定を書き込む
    
    > [MENU] →［ワイヤレス］→［設定］→［アクセスポイント手動登録］を選び、登録したいアクセスポイントを選ぶ。
    > 
    > 
    > [ヘルプガイド | アクセスポイント手動登録](https://helpguide.sony.net/cam/1610/v1/ja/contents/TP0000933084.html)
    > 
    
    より詳しい内容を知りたい場合, 以下を参照してください.  
    [GitHub - TechnoTUT/sony-camera-rtmp-relay: Receive video via wireless from sony camera and send it to streaming server.](https://github.com/TechnoTUT/sony-camera-rtmp-relay)
    

## NDI

スマートフォンからのカメラ映像の転送にはNDIを利用している.

### NDIについて
[NDI](./ndi.md) を参照してください.

### スマートフォンでのNDI

#### iPhone
LM-Cam for OBS studio (無料)  
[‎LM-Cam for OBS studio](https://apps.apple.com/jp/app/lm-cam-for-obs-studio/id1541086068)

NDI HX Camera (有料)  
[‎NDI HX Camera: Easy Streaming](https://apps.apple.com/us/app/ndi-hx-camera-easy-streaming/id1477266080?ls=1)

#### Android
NDI HX Camera (有料)  
[NDI HX Camera: Easy Streaming - Apps on Google Play](https://play.google.com/store/apps/details?id=com.newtek.ndi.hxcam)

上記のいずれかをインストール. Wi-Fi: `TechnoTUT_Cam` に接続しNDI送信.

## OBSでのNDI

### 環境構築

:::info
TechnoTUTのディスクレスシステムには既にNDIが導入されたOBS環境が準備されています. ネットワークブートを行った場合はこの手順は不要です.  
:::

- Windows
    1. OBS Studioのインストール
        
        [ダウンロード | OBS](https://obsproject.com/ja/download)
        
    2. DistroAV(OBS-NDI)のインストール
        
        [Releases · DistroAV/DistroAV](https://github.com/DistroAV/DistroAV/releases)
        
    3. NDI Runtime (NDI6) のインストール
        
        [ndi.link](http://ndi.link/NDIRedistV6)
        
    
    Wingetを利用したインストールも可能. PowerShellで以下を実行.
    DistroAVは手動でインストールする必要がある.
    
    ```powershell
    winget install OBSProject.OBSStudio
    winget install NDI.NDIRuntime
    ```
    
- MacOS
    1. OBS Studioのインストール (Catalina以降)
        
        [ダウンロード | OBS](https://obsproject.com/ja/download)
        
    2. DistroAV (OBS-NDI) のインストール
        
        [Releases · DistroAV/DistroAV](https://github.com/DistroAV/DistroAV/releases)
        
    3. NDI Runtime (NDI 6)のインストール
        
        [ndi.link](http://ndi.link/NDIRedistV6Apple)
        
    4. libNDI 6.0.0 で”libNDI not found" / "libndi_load_v5: not found” というエラーが表示される場合は, 以下を実行します. (libNDI 6.0.1から修正されました)
        
        ```bash
        sudo chmod 755 /usr/local/lib 
        ```
        
    
    Homebrewを用いる場合は以下を実行
    
    ```bash
    brew install --cask obs
    brew install --cask obs-ndi
    brew install --cask libndi
    ```
    
- Linux (Ubuntu)
    1. OBSのインストール
        
        ```bash
        $ sudo apt-get install ffmpeg
        $ sudo add-apt-repository ppa:obsproject/obs-studio
        $ sudo apt-get update && sudo apt-get install obs-studio
        ```
        
    2. DistroAV(OBS-NDI)とNDI Runtime (NDI 6) のインストール
        
        https://gist.github.com/dodolia907/092a04e675430481abcd91e9e5317e23
        

### 送信

ツールから `DistroAV NDI(R) Settings` を選択し, `Main Output` にチェックを入れます.

### 受信

ソースの `NDI(R) Source` を追加ます.

受信したいNDIソースを `Source name` に設定し, `Latency Mode` を `Lowest (Unbuffered)` に設定します. 
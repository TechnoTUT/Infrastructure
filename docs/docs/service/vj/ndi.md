---
title: NDI
sidebar_position: 2
---
## NDIとは
- IPネットワーク上で伝送するためのプロトコル
- 超低遅延で伝送できることが特徴
- HDMIでは長くても15~20mの伝送が限界であるがNDIではLANケーブル/光ファイバで接続できる限り延長することができる
- HDMIと異なり容易に複数のデバイスで映像を取り込むことが可能である

[NDI Central -NDI｜tricaster.jp](https://tricaster.jp/ndi-central/ndi/)

> NDIとは、IP利用における新しいライブビデオ制作ワークフロー支援プロトコルです。このNDIテクノロジーを活用することで、一般的なギガビットイーサネット環境においても、映像、音声、制御コマンド、メタデータなどを、Vizrt 社**TriCaster**や**3Play**などのシステム間だけでなく、**NDI互換**のさまざまなシステム、デバイス、PCなどとのリアルタイムによる相互伝送を可能とします。
> 

> **IPを利用した伝送と制御、そして、創造性**
> 
> 
> これまでの放送インフラにおける技術的、物理的制約から解放され、IPによる新たな映像制作ワークフローを確立できます。NDI（ネットワーク・デバイス・インターフェイス）プロトコルに対応するシステムやアプリケーションを導入することにより、あなたのビデオ制作ワークフローをビデオ・オーバー・IP環境に簡単に移行させることができます。
> 
> **ルーティングの制約を排除**
> 
> SDIビデオルーターに接続された映像/音声ソースだけでなく、ネットワーク上にある映像/音声ソースも入力素材として利用できるようになるため、番組制作の演出を格段に柔軟、且つ、拡張させることができます。
> 
> NDI®は、ネットワークに接続された映像機器上のソースを、誰もが利用できるようにしたオープンスタンダードなプロトコルです。プロダクションスイッチャーやキャプチャーシステム、メディアサーバーなど、ネットワーク上でNDIに対応している機器であれば、すべての機器間でNDIソースを共有することが可能となるため、これまでよりも多くのソースをライブプロダクションで使用できるようになります。
>

## キャプチャーボードとの違い
キャプチャーボードは、1チャネルの映像をUSB経由でパソコンに送信しますが、NDIでは、1本のLANケーブルに帯域の許す限り無限チャネルの映像を送受信することができます。よって、NDIを利用することで、複数のカメラの映像を1台のコンピュータで同時に受信したり、1台のコンピュータ内の複数のアプリケーションの映像をLANケーブル1本で他のパソコンで受信したりすることができます。  

## NDIを利用する
### 必要なもの
- カテゴリー5e以上のLANケーブル
- ギガビット・イーサネットスイッチ (インテリスイッチを推奨)
- NDI対応のソフトウェア (OBS Studio, Resolume Avenue など)
:::info
- NDIは、1本のLANケーブルに帯域の許す限り無限チャネルの映像を送受信することができますが、送信側の帯域が足りない場合、映像が不安定になることがあります。
- スイッチングファブリックを確認してください。スイッチングファブリックの低いスイッチでは、帯域が不足する可能性があります。
- NDIでは、mDNSを利用してネットワーク上のコンピュータを検索します。よって、コンピュータ同士は同セグメントに属している必要があります。マルチキャストを利用rするため、IGMPスヌーピングが正しく設定されている必要があります。QuerierをVLAN内に1台設定するか、すべてのスイッチのIGMPスヌーピングを無効にしてください。
- NDIでは、コンピュータ同士が通信を行うことによって、映像を送受信します。ファイアウォールによって通信がブロックされていると、機能しません。映像の送受信が上手くいかない場合は、ファイアウォールの設定を確認してください。Windowsの場合は、接続されているネットワークがプライベートネットワークに設定されているか確認してください。
:::
### Resolume Avenueの場合
Resolume Avenueの場合、標準でNDIの送受信ができます。NDI出力を行う場合は、以下を参考にしてVJネットワーク(VLAN20)に接続し`Output` > `Network streaming (NewTek NDI)`を選択してNDI出力を有効にします。  
![](https://raw.githubusercontent.com/TechnoTUT/Infrastructure/refs/heads/main/network/design/event.drawio.svg)
詳細は、[Resolume AvenueのNDIについて](https://resolume.com/support/ja/NDI_inputs_and_outputs)を参照してください。
### OBS Studioの場合
OBS Studioの場合、[NDI Plugin for OBS Studio](https://github.com/DistroAV/DistroAV)をインストールすることで、NDIの送受信ができます。OBSのバージョンと環境にあったものをダウンロードしてください。  
動作しない場合、NDIのランタイムがインストールされていない可能性があります。インストール方法は以下をご覧ください。
https://github.com/DistroAV/DistroAV/wiki/1.-Installation

#### Windows
```powershell
winget install OBSProject.OBSStudio
winget install NDI.NDIRuntime
```
DistroAVを以下からダウンロードし、インストールします。
[Releases · DistroAV/DistroAV](https://github.com/DistroAV/DistroAV/releases)
#### Mac
```zsh
brew install --cask obs
brew install --cask obs-ndi
brew install --cask libndi
```
#### Ubuntu
```bash
sudo apt-get install ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update && sudo apt-get install obs-studio

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y wget tar ufw
sudo systemctl enable --now ufw 
sudo ufw enable && sudo ufw allow 22/tcp
mkdir -p tmp && cd tmp
wget https://github.com/DistroAV/DistroAV/releases/download/6.0.0/distroav-6.0.0-x86_64-linux-gnu.deb
sudo apt install ./distroav-6.0.0-x86_64-linux-gnu.deb
rm -rf distroav-6.0.0-x86_64-linux-gnu.deb
wget https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz
tar xvf Install_NDI_SDK_v6_Linux.tar.gz 
rm -rf Install_NDI_SDK_v6_Linux.tar.gz 
echo "y" | PAGER="cat" bash Install_NDI_SDK_v6_Linux.sh
rm -rf Install_NDI_SDK_v6_Linux.sh 
sudo cp NDI\ SDK\ for\ Linux/lib/x86_64-linux-gnu/* /usr/local/lib/
sudo ln -s /usr/local/lib/libndi.so.6 /usr/local/lib/libndi.so.5
ls -la /usr/local/lib/libndi*
cd .. && rm -r tmp
mkdir -p ~/.ndi
cat <<EOF > ~/.ndi/ndi-config.v1.json
{
  "ndi" : {
    "rudp" : {
      "recv" : {
        "enable" : true
      }
    },
    "tcp" : {
      "recv" : {
        "enable" : false
      }
    },
    "networks" : {
      "ips" : "",
      "discovery" : ""
    },
    "groups" : {
      "recv" : "public",
      "send" : "public"
    },
    "multicast" : {
      "send" : {
        "enable" : false,
        "netprefix" : "239.255.0.0",
        "netmask" : "255.255.0.0"
      }
    },
    "unicast" : {
      "recv" : {
        "enable" : true
      }
    }
  }
}
EOF
sudo apt install avahi-daemon
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
sudo ufw allow 5353/udp
sudo ufw allow 5959:5969/tcp
sudo ufw allow 5959:5969/udp
sudo ufw allow 6960:6970/tcp
sudo ufw allow 6960:6970/udp
sudo ufw allow 7960:7970/tcp
sudo ufw allow 7960:7970/udp
sudo ufw allow 5960/tcp
sudo ufw status
```

#### 送信
- OBS Studioを起動し、`Tools` > `NDI Output Settings`を選択し、`Main Output`を有効にします。
#### 受信
- OBS Studioを起動し、Sourceの追加から`NDI Source`を選択し、`Source Name`を選択します。`Latency Mode`は`Lowest (Unbuffered)`を選択します。
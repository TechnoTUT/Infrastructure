# intra-dns
## About
BINDを用いた内部DNSサーバー構築用のスクリプトです.  
IPアドレスとホスト名の対応表は `/network/design/ipaddress.md` に記載されています.
## Usage
```sh
$ git clone https://github.com/TechnoTUT/Infrastructure.git
$ cd Infrastructure/network/intra-dns
$ sudo ./install.sh
```
自動で定期的にGitHubを確認し, DNS設定を適用するには以下のように設定します.
```sh
$ sudo crontab -e
```
```crontab
@reboot /path/to/Infrastructure/network/intra-dns/update.sh
0 0 * * * /path/to/Infrastructure/network/intra-dns/update.sh
```
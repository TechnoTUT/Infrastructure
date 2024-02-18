# stat
## About
PrometheusとGrafanaを用いた監視システム構築用のスクリプトです.  

## Usage
```sh
$ git clone https://github.com/TechnoTUT/Infrastructure.git
$ cd Infrastructure/network/stat
$ sudo ./install.sh
```
自動で定期的にGitHubを確認し, 設定を適用するには以下のように設定します.
```sh
$ sudo crontab -e
```
```crontab
@reboot /path/to/Infrastructure/network/stat/update.sh
0 0 * * * /path/to/Infrastructure/network/stat/update.sh
```
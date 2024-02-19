# stat
## About
PrometheusとGrafanaを用いた監視システム構築用のスクリプトです.  

## Usage
```sh
$ git clone https://github.com/TechnoTUT/Infrastructure.git
$ cd Infrastructure/server/stat
$ sudo ./install.sh
```
自動で定期的にGitHubを確認し, 設定を適用するには以下のように設定します.
```sh
$ sudo crontab -e
```
```crontab
@reboot /path/to/Infrastructure/server/stat/update.sh
0 0 * * * /path/to/Infrastructure/server/stat/update.sh
```
k3s環境で利用する場合は, 事前に`/server/stat/prometheus/prometheus.yml`と`/server/stat/snmp.yml`を`/etc/prometheus/`にコピーしてください.  
```sh
$ sudo cp ./prometheus/prometheus.yml /etc/prometheus/
$ sudo cp ./prometheus/snmp.yml /etc/prometheus/
``` 
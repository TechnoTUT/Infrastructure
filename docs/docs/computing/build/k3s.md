---
title: コンテナ実行環境
sidebar_position: 2
---
# Kubernetes
[k3s](https://k3s.io/) を使用して、コンテナ実行環境を構築します。  
 k3s は軽量なKubernetesのディストリビューションであり、IoTやエッジコンピューティングなどのリソースが限られた環境に適しています。  
## OSのインストール
任意のLinuxディストリビューションをインストールします。
ネットワークは、`vlan99`に接続し、IPアドレスを`192.168.99.33`に設定します。
## インストール
Podネットワークは、`10.244.0.0/16`に設定します。
ネットワークプラグインは`calico` を使用し、ルータとBGPで接続します。BGPで経路情報を交換することで、KubernetesのPodネットワークとルータのネットワークを接続します。
```bash
sudo su -
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable=traefik --disable=servicelb" sh -
```
## ネットワーク
Kubernetesのネットワークプラグインとして、Calicoをインストールします。
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/technotut/k3s/main/setup/calico-manifest/custom-resources.yaml
```
calicoctlインストールし、設定を行います。
```bash
cd /usr/local/bin
curl -L https://github.com/projectcalico/calico/releases/download/v3.28.1/calicoctl-linux-amd64 -o calicoctl
sudo chmod +x ./calicoctl
ln -s /etc/rancher/k3s/k3s.yaml ~/.kube/config
wget https://raw.githubusercontent.com/technotut/k3s/main/setup/calico-manifest/bgppeer.yaml
wget https://raw.githubusercontent.com/technotut/k3s/main/setup/calico-manifest/bgpconfig.yaml
calicoctl apply -f bgppeer.yaml
calicoctl apply -f bgpconfig.yaml
```
ファイアウォールの設定を行います。
下記のコマンドで、必要なポートを開放するか、`systemctl disable --now firewalld`で無効化します。
```bash
firewall-cmd --add-port=179/tcp --permanent
firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --zone=trusted --add-source=10.43.0.0/16 --permanent
firewall-cmd --zone=trusted --add-source=10.244.0.0/16 --permanent
firewall-cmd --zone=trusted --add-source=<client-cidr> --permanent
firewall-cmd --reload
```
ルータの設定を行います。ルータのAS番号は`65000`、Kubernetes側のAS番号も`65000`とし、iBGPで接続します。
```terminal
router bgp 65000
  neighbor 192.168.99.33 remote-as 65000
  address-family ipv4 unicast
    network 192.168.10.0/24
    network 192.168.11.0/24
    network 192.168.20.0/24
    network 192.168.99.0/24
    exit
  exit
writ memory
```
BGPの設定が適切であるか、経路交換が行われているか確認します。
```terminal
show ip bgp summary
```
"ESTABLISHED"と表示されていれば、BGPの接続が成功しています。ノード側の設定が正しく行われているかも確認します。
```bash
calicoctl get nodes -o wide
calicoctl get bgpPeer -o wide
calicoctl get ippool -o wide
calicoctl get bgpConfiguration -o wide
watch kubectl get pod -A -o wide
ip route
```
## ボリューム
Kubernetesのボリュームとして、NFSを使用します。  
KubernetesはマニフェストのPersistentVolumeClaimに応じて、自動で永続ボリュームを割当てます。  

まずはNFSサーバを構築します。
```bash
mkdir /nfs
dnf install nfs-utils
systemctl enable --now nfs-server
echo "/nfs localhost(rw,no_root_squash)" >> /etc/exports
exportfs -a
exportfs
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
```
KubernetesのパッケージマネージャーであるHelmをインストールします。
```bash
cd /usr/local/bin
wget https://get.helm.sh/helm-v3.13.2-linux-amd64.tar.gz
tar -zxvf helm-v3.13.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm 
rm linux-amd64
rm helm-v3.13.2-linux-amd64.tar.gz
```
Helmを使って、[nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)をインストールします。
```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=localhost --set nfs.path=/nfs
```
#### MetalLB
MetalLBは、Kubernetesのロードバランサーです。インストールすることで、KubernetesのServiceに対して、外部からアクセスできるようになります。  
```bash
kubectl apply -f https://raw.githubusercontent.com/technotut/k3s/main/setup/metallb/metallb.yaml
kubectl apply -f https://raw.githubusercontent.com/technotut/k3s/main/setup/metallb/metallb-ipaddresspool.yaml
```
#### ingress-nginx
ingress-nginxは、KubernetesのIngressコントローラです。インストールすることで、KubernetesのIngressリソースを利用して、HTTP/HTTPSのトラフィックをルーティングできます。  
```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```
#### ArgoCD
ArgoCDは、KubernetesのCDツールです。GitHubのリポジトリに保存されたマニフェストを監視し、変更があれば自動でデプロイします。  
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/technotut/k3s/main/setup/argocd/install.yaml
cd /usr/local/bin
curl -L https://github.com/argoproj/argo-cd/releases/download/v2.11.8/argocd-linux-amd64 -o argocd
chmod +x argocd
firewall-cmd --add-port=30001/tcp --permanent
firewall-cmd --reload
```
ArgoCDのWeb UIは、`https://argocd.kube.technotut,net` でアクセスできます。
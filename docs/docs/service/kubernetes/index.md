---
title: コンテナ実行基盤
slug: /service/kubernetes
sidebar_position: 8
---
コンテナ実行基盤として、Kubernetesの実行環境を提供しています。
## Kubernetes とは
Kubernetesは、コンテナを管理するためのツールです。  
コンテナのデプロイ、スケーリング、管理を行うことができます。  
  
TechnoTUTでは、以下のリポジトリでKubernetesの管理を行っています。  
[![TechnoTUT/k3s - GitHub](https://gh-card.dev/repos/TechnoTUT/k3s.svg?fullname=)](https://github.com/TechnoTUT/k3s)

## 利用方法
KubernetesのPodネットワークは、TechnoTUT内部のネットワークとBGPによる経路交換を行っており、任意のVLANからPodのIPアドレスを指定してアクセスすることができます。  
KubernetesのVMのIPアドレスは`192.168.99.33`です。以下の手順の操作を行う前に、VMにSSHログインします。  
```bash
ssh <your-username>@192.168.99.33
```
ユーザ名・パスワードは、管理者から提供されます。Kubernetesの実行環境が必要な場合は、発行しますのでお問い合わせください。  

### kubectl
1. Kubernetesのマニフェストを作成します。  
2. kubectlコマンドを使用して、マニフェストを適用します。
```bash
kubectl apply -f <your-manifest>.yaml
```
3. マニフェストの適用後、Podの状態を確認します。
```bash
kubectl get pods -o wide
```

Podを削除する場合は、以下のコマンドを使用します。
```bash
kubectl delete -f <your-manifest>.yaml
```

### ArgoCD
ArgoCDを使用すれば、GitHubリポジトリに配置されたマニフェストを自動で適用することができます。  
GitHubリポジトリのマニフェストに更新があれば、自動で適用されます。  
```bash
argocd app create <app-name> --repo <manifest-repo> --path <manifest-path> --dest-server <dest-server> --dest-namespace <dest-namespace>
```
`<app-name>` にはアプリケーション名を指定します。  
`<manifest-repo>` にはGitHubリポジトリのURLを指定します。  
`<manifest-path>` にはマニフェストが配置されているパスを指定します。  
`<dest-server>` には適用先のKubernetesのサーバを指定します。  
`<dest-namespace>` には適用先のKubernetesのネームスペースを指定します。
  
例として、監視サーバのマニフェストを適用する場合のコマンドは以下の通りです。  
`stat` というアプリケーション名で、TechnoTUT/k3sリポジトリの `/manifest/stat` にあるマニフェストを適用します。ネームスペースは `default` です。
```bash
argocd app create stat --repo https://github.com/TechnoTUT/k3s.git --path manifest/stat --dest-server https://kubernetes.default.svc --dest-namespace default
```

GitHubリポジトリの更新を追跡する場合は、以下のコマンドを使用します。
```bash
argocd app sync <app-name>
```
`<app-name>` にはアプリケーション名を指定します。
  
ArgoCDのWebUIにアクセスすることで、マニフェストの適用状況を確認することができます。以下のURLからアクセスできます。  
https://argocd.kube.technotut.net/
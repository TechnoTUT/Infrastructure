---
title: 概要
slug: /computing
sidebar_position: 1
---
# About
[TechnoTUT Network](/) では、計算機を運用し、計算資源を提供しています。
運用中の計算機は仮想化技術を活用し、ソフトウェアとハードウェアの間に抽象化レイヤーを設けることで効率的に利用できるようにしています。  
TechnoTUT Network では、ハイパーバイザー型とコンテナ型の2種類の仮想化手法を採用しています。  

## ハイパーバイザー型
ハイパーバイザー型仮想化は、ハードウェア上にハイパーバイザーと呼ばれる仮想化ソフトウェアを配置し、その上で仮想マシンを実行する方式です。
TechnoTUT Network では、ハイパーバイザーとしてProxmox VE を採用し、KVMによる仮想マシンとLXCによるコンテナを提供しています。

## コンテナ型
コンテナ型仮想化は、Linux カーネルの機能を利用してプロセスを隔離する方式です。Linux カーネルを共有することで、仮想マシンよりも軽量で高速に動作します。  
TechnoTUT Network では、Kubernetes をコンテナオーケストレーションツールとして採用しています。Kubernetes により、Infrastructure as Code (IaC) による運用が可能であり、運用の効率化を実現します。

## How to use
使用方法については、以下のページを参照してください。  
- [仮想基盤](/service/virtualization)
- [コンテナ実行環境](/service/kubernetes)

## Build
構築方法については、[構築](/computing/build) を参照してください。

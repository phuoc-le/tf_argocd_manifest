#!/bin/bash

set -ex

kubectl create namespace argocd || echo "namespace already exists"
rm -f /tmp/argocd-install.yaml
curl https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --output /tmp/argocd-install.yaml
sed -i "s/imagePullPolicy: Always/imagePullPolicy: IfNotPresent/g" /tmp/argocd-install.yaml
kubectl apply -f /tmp/argocd-install.yaml -n argocd


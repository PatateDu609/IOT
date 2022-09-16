#!/bin/bash

# setting up cluster

echo "Creating cluster..."
k3d cluster create cluster-argocd -p "8080:80@loadbalancer" --wait
echo "Cluster created..."

echo "Creating namespaces..."
kubectl create namespace argocd
kubectl create namespace dev
echo "Namespaces created..."

echo "Installing argocd..."
kubectl apply -n argocd -f ../conf/argocd

echo "Waiting for argocd to entirely deploy"
kubectl rollout status -n argocd deploy/argocd-server

echo "Configuring argocd..."
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$H46eP2fOkSVRphN7f1aAN.R21GOuxyOfjKhnmqjF6BJp4oLGyX0T2",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

echo "Adding an application..."
kubectl apply -n argocd -f ../conf/app

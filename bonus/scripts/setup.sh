#!/bin/bash

# setting up cluster

echo "Creating cluster..."
k3d cluster create cluster-gitlab -p "8080:80@loadbalancer" --wait
echo "Cluster created..."

echo "Creating namespaces..."
kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab
echo "Namespaces created..."

echo "Installing argocd..."
kubectl apply -n argocd -f /srv/k3d/conf/argocd.yml
kubectl wait --for=condition=Ready pods -n argocd --all

echo "Installing ingress..."
kubectl apply -n argocd -f /srv/k3d/conf/ingress.yml

echo "Configuring argocd and adding application..."
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$H46eP2fOkSVRphN7f1aAN.R21GOuxyOfjKhnmqjF6BJp4oLGyX0T2",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

kubectl apply -n argocd -f /srv/k3d/conf/project.yml
kubectl apply -n argocd -f /srv/k3d/conf/application.yml

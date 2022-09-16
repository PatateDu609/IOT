#!/bin/bash

# setting up cluster
echo "Creating cluster..."
k3d cluster create cluster-gitlab -p "8080:80@loadbalancer" --wait
echo 'export KUBECONFIG="$(k3d kubeconfig merge cluster-gitlab --kubeconfig-switch-context)"' >> /home/vagrant/.bashrc

echo "Cluster created..."

echo "Creating namespaces..."
kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab
echo "Namespaces created..."

echo "Installing argocd..."
kubectl apply -n argocd -f /srv/k3d/conf/argocd
kubectl rollout status -n argocd deploy/argocd-server

echo "Installing gitlab..."
kubectl apply -n gitlab -f /srv/k3d/conf/gitlab
kubectl rollout status -n gitlab deploy/gitlab-deployment

echo "Configuring argocd and adding application..."
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$H46eP2fOkSVRphN7f1aAN.R21GOuxyOfjKhnmqjF6BJp4oLGyX0T2",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
kubectl apply -n argocd -f /srv/k3d/conf/app

sleep 10
kubectl exec -n gitlab $(kubectl get pods -n gitlab -o name) -- cat /etc/gitlab/initial_root_password

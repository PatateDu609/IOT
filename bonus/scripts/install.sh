#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo apt install -y \
	curl \
	wget \
	ca-certificates \
	curl \
	gnupg \
	lsb-release

echo "Installing docker..."

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

sudo groupadd docker
sudo usermod -aG docker vagrant

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Installing kubectl..."
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubectl

echo "Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# echo "Installing helm..."
# curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

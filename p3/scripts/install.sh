#!/bin/bash

echo "Looking for docker installation..."
if [ ! command -v docker ]; then
	curl https://get.docker.com/ | bash
else
	echo "Docker found!"
fi

echo "Looking for kubectl installation..."
if [ ! command -v kubectl ]; then
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

	echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
	if [ $? -ne 0 ]; then
		echo "Check failed."
		exit 1
	fi

	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
	echo "kubectl found!"
fi

echo "Looking for k3d installation..."
if [ ! command -v k3d ]; then
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
	echo "k3d found!"
fi

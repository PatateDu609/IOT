#!/bin/bash

k3d cluster delete cluster-argocd
docker system prune -a -f --volumes

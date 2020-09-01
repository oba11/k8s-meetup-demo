#!/bin/bash

exe() { 
  echo "\$ $@" ; "$@" ; 
}

export PATH=$PATH:$(pwd)

echo "Downloading minikube to '$(pwd)'"
read -rsn1 -p" "
echo ''
OS_NAME=$(echo `uname -s` | tr '[A-Z]' '[a-z]')
echo "\$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.3/minikube-${OS_NAME}-amd64"

echo "Making minikube executable"
echo "\$ chmod +x minikube"

echo "Downloading kubectl to '$(pwd)'"
read -rsn1 -p" "
echo ''
echo "\$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/${OS_NAME}/amd64/kubectl"

echo "Making kubectl executable"
echo "\$ chmod +x kubectl"

echo ''
echo 'Start minikube'
read -rsn1 -p" "
echo ''
echo "\$ minikube start"
echo "Starting local Kubernetes v1.7.5 cluster..."
echo "Starting VM..."
sleep 2
echo "Getting VM IP address..."
echo "Moving files into cluster..."
echo "Setting up certs..."
echo "Connecting to cluster..."
echo "Setting up kubeconfig..."
echo "Starting cluster components..."
sleep 2
echo "Kubectl is now configured to use the cluster."

echo ''
echo 'Check minikube status'
read -rsn1 -p" "
echo ''
exe minikube status

echo "Lets run nginx container"
read -rsn1 -p" "
echo ''
exe kubectl run nginx --image=nginx --port=80 --hostport=80

echo "Lets check the nginx status"
read -rsn1 -p" "
echo ''
exe kubectl get deployment

echo "What about the pod status"
read -rsn1 -p" "
echo ''
exe kubectl get pod

echo "Kubernetes dashboard?"
read -rsn1 -p" "
echo ''
exec minikube dashboard

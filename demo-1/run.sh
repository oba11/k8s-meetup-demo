#!/bin/bash

exe() { 
  echo "\$ $@" ; "$@" ; 
}

echo "Downloading minikube to '$(pwd)'"
read -rsn1 -p" "
echo ''
OS_NAME=$(echo `uname -s` | tr '[A-Z]' '[a-z]')
exe curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.21.0/minikube-${OS_NAME}-amd64

echo "Making minikube executable"
exe chmod +x minikube

echo "Downloading kubectl to '$(pwd)'"
read -rsn1 -p" "
echo ''
exe curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/${OS_NAME}/amd64/kubectl

echo "Making kubectl executable"
exe chmod +x kubectl

echo 'Start minikube'
read -rsn1 -p" "
echo ''
exe minikube start

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

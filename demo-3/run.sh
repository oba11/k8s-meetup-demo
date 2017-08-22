#!/bin/bash

exe() { 
  echo "\$ $@" ; "$@" ; 
}

ZONE=''
PARENT_ZONE=''
BUCKET_NAME=''

# Source environment variables
. ../demo-env

echo "Downloading kops to '$(pwd)'"
read -rsn1 -p" "
echo ''
OS_NAME=$(echo `uname -s` | tr '[A-Z]' '[a-z]')
exe curl -Lo kops https://github.com/kubernetes/kops/releases/download/1.7.0/kops-${OS_NAME}-amd64

echo "Making kops executable"
exe chmod +x kops

echo 'Create route53 record'
read -rsn1 -p" "
echo ''
echo "You need to create a route53 zone and delegate the newly created zone to the parent domain"
exe python3 ./demo-3/update-r53-zone.py --action create --zone ${ZONE} --parent-zone=${PARENT_ZONE}

echo 'Create s3 bucket for storing state'
read -rsn1 -p" "
echo ''
exe aws s3api create-bucket --bucket ${BUCKET_NAME} --region us-east-1

echo "Now let's create out k8s cluster with kops"
read -rsn1 -p" "
echo ''
ZONE_ID=$(aws route53 list-hosted-zones | jq -r '.HostedZones[] | select(.Name=="${ZONE}.") | .Id' | cut -d '/' -f3)
echo 'zone id: ${ZONE_ID}'
exe kops create cluster \
--dns-zone ${ZONE_ID} \
--zones us-east-1a,us-east-1b \
--state s3://${BUCKET_NAME} \
${ZONE} --yes

# aws route53 list-resource-record-sets --hosted-zone-id ${ZONE_ID}

## Cleanup record
# kops delete cluster --state s3://${BUCKET_NAME} ${ZONE} --yes
# python3 ./demo-3/update-r53-zone.py --action destroy --zone ${ZONE} --parent-zone=${PARENT_ZONE}
# aws s3api delete-bucket --bucket ${BUCKET_NAME} --region us-east-1

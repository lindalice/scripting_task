#!/bin/bash

# Make an IMDSv2 request
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

# Retrieve the instance ID from metadata
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)

# Define and retrieve the instance information
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
AZ_CODE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
INSTANCE_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=Name" --region $REGION --query 'Tags[0].Value' --output text)
ACCOUNT_NUMBER=$(aws sts get-caller-identity --query 'Account' --output text)

# Write the variables information to the output file
cat << EOF >> /opt/shell_output.txt
region-name: $REGION
az-code: $AZ_CODE
private-ip: $PRIVATE_IP
public-ip: $PUBLIC_IP
instance-name: $INSTANCE_NAME
instance-id: $INSTANCE_ID
account-number: $ACCOUNT_NUMBER
EOF

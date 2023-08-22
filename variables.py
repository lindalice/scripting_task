#!/usr/bin/env python3
import requests
import boto3

# Create an EC2 resource object
ec2 = boto3.resource('ec2', region_name='eu-central-1')

# Create an STS client object
sts = boto3.client('sts')

# Get instance ID from metadata
instance_id = requests.get('http://169.254.169.254/latest/meta-data/instance-id').text

# Get the tags for the current instance
tags = ec2.Instance(instance_id).tags

# Extract the 'Name' tag value
instance_name = next((tag['Value'] for tag in tags if tag['Key'] == 'Name'), None)

# Define and retrieve the variables dictionary
variables = {
    'region_name': requests.get('http://169.254.169.254/latest/meta-data/placement/region').text,
    'az_name': requests.get('http://169.254.169.254/latest/meta-data/placement/availability-zone').text,
    'private_ip': requests.get('http://169.254.169.254/latest/meta-data/local-ipv4').text,
    'public_ip': requests.get('http://169.254.169.254/latest/meta-data/public-ipv4').text,
    'instance_id': instance_id,
    'account_number': sts.get_caller_identity()['Account'],
    'instance_name': instance_name
}

# Write variables to a file
with open('/opt/python_output.txt', 'w') as file:
    for key, value in variables.items():
        file.write(f"{key}: {value}\n")

data "aws_ami" "d4ml_ami" {
  filter {
    name   = "name"
    values = ["eks-ami-d4ml*"]
  }
}

resource "aws_instance" "ll-scripting" {
  ami                  = data.aws_ami.d4ml_ami.id
  instance_type        = "t2.micro"
  subnet_id            = "subnet-0212031f1667e03a7"
  iam_instance_profile = "role-d4ml-cloud9-deployment"
  security_groups      = [aws_security_group.LL-Scripting-SG.id]
  user_data            = <<-EOT
            #!/bin/bash
            set -e

            # Install required packages
            sudo apt update
            sudo apt install -y python3-pip
            pip3 install boto3

            # Change directory
            cd /opt/

            # IMDSv2 authorization token
            TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 300" "http://169.254.169.254/latest/api/token")

            # Add execute permissions to scripts
            chmod +x variables2.sh
            chmod +x variables.py

            # Run the scripts
            sh variables2.sh
            python3 variables.py

            # Upload output to S3 bucket
           aws s3 cp /opt/python_output.txt s3://s3statebackend-linda-lice/python_output.txt
           aws s3 cp /opt/shell_output.txt s3://s3statebackend-linda-lice/shell_output.txt
            EOT

  tags = {
    Name = "LL-Scripting"
  }
}

resource "aws_security_group" "LL-Scripting-SG" {
  name   = "LL-Scripting-SG"
  vpc_id = "vpc-0faf1b0abcce85736"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow IMDSv2 for Bash Script"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["213.226.141.118/32"]
  }

  egress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow custom port 9997"
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LL-Scripting-SG"
  }
}

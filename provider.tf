terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region  = "eu-central-1"
  profile = "d4ml-intern"
}
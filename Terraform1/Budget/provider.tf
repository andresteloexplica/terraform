terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.00"
    }
  }
}

provider "aws" {
  region = "eu-south-2"
  access_key = "aws_user_access_key"
	secret_key = "aws_user_secret_key"
}
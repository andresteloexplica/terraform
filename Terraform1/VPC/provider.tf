# provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configura la conexión con AWS usando la región definida en las variables
provider "aws" {
  region = var.aws_region
}
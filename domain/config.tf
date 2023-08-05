terraform {
  required_version = "~> 1.5.2"
  backend "s3" {
    bucket = "backend-tsubasa"
    key    = "domain/terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}
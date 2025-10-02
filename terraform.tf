terraform {
  required_version = ">= 1.0"
  
  cloud {
    organization = "your-company-runners"
    workspaces {
      name = "github-actions-runners"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
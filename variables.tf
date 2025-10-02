variable "runner_module_version" {
  description = "terraform-aws-github-runner module version"
  type        = string
  default     = "5.0.0"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_id" {
  description = "VPC ID for runners"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for runners"
  type        = list(string)
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
}

variable "github_app_private_key" {
  description = "GitHub App private key (base64 encoded)"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
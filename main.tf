provider "aws" {
  region = var.aws_region
}

module "github_runner" {
  source  = "github.com/github-aws-runners/terraform-aws-github-runner"
  version = var.runner_module_version
  
  # GitHub App設定
  github_app_id         = var.github_app_id
  github_app_private_key = var.github_app_private_key
  
  # AWS設定
  aws_region = var.aws_region
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  
  # 自動アップデート無効化（手動制御）
  disable_runner_autoupdate = true
  enable_runner_binaries_syncer = false
  
  # Lambda同時実行数制限対応
  lambda_scale_up_reserved_concurrent_executions = null
  lambda_scale_down_reserved_concurrent_executions = null
  
  # 環境設定
  environment = var.environment
  
  tags = {
    Environment = var.environment
    Module     = "terraform-aws-github-runner"
    Version    = var.runner_module_version
  }
}

# 出力
output "webhook_endpoint" {
  description = "Webhook endpoint URL"
  value       = module.github_runner.webhook_endpoint
}

output "runner_role_arn" {
  description = "Runner IAM role ARN"
  value       = module.github_runner.runner_role_arn
}
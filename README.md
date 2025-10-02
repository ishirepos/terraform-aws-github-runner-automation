# GitHub Actions Self-hosted Runner Automation

## Overview

This repository contains automation for managing terraform-aws-github-runner module versions with Terraform Cloud integration.

## Features

- Automated version detection from GitHub releases
- Multiple update modes: latest_stable, select_version, custom_version
- Terraform Cloud integration
- Pull Request workflow with approval
- Lambda artifacts management

## Directory Structure

```
github-runner-automation/
├── .github/
│   ├── workflows/
│   │   ├── list-available-versions.yml    # Daily version check
│   │   └── update-runner-with-selection.yml # Version update workflow
│   └── data/                              # Version tracking data
├── scripts/
│   └── download_artifacts.sh              # Lambda artifact downloader
├── main.tf                                # Main Terraform configuration
├── variables.tf                           # Variable definitions
├── terraform.tf                           # Terraform Cloud configuration
└── README.md                              # This file
```

## Usage

### Update to Latest Stable Version
```bash
gh workflow run update-runner-with-selection.yml -f update_mode=latest_stable
```

### Update to Custom Version
```bash
gh workflow run update-runner-with-selection.yml -f update_mode=custom_version -f target_version=5.1.1
```

### Interactive Version Selection
```bash
gh workflow run update-runner-with-selection.yml -f update_mode=select_version
```

## Setup

### 1. GitHub Repository Secrets

Configure the following secrets in your GitHub repository:

```
AWS_ACCESS_KEY_ID              # AWS credentials
AWS_SECRET_ACCESS_KEY          # AWS credentials
TF_CLOUD_TOKEN                 # Terraform Cloud API token
TF_VAR_RUNNER_VERSION_ID       # Terraform Cloud variable ID
```

### 2. Terraform Cloud Configuration

Set up workspace variables:

**Environment Variables:**
```
AWS_ACCESS_KEY_ID     = <your-aws-key>
AWS_SECRET_ACCESS_KEY = <your-aws-secret>
```

**Terraform Variables:**
```
runner_module_version = "5.0.0"
aws_region           = "ap-northeast-1"
vpc_id              = "vpc-xxxxxxxxx"
subnet_ids          = ["subnet-xxxxxxxxx"]
environment         = "production"
github_app_id       = "123456"
github_app_private_key = "base64-encoded-key"
```

### 3. Update Configuration

Edit the following files to match your environment:

- `terraform.tf`: Update organization and workspace names
- `.github/workflows/update-runner-with-selection.yml`: Update TF_CLOUD_ORGANIZATION and TF_CLOUD_WORKSPACE

## Workflow Details

### Daily Version Check
- **File**: `.github/workflows/list-available-versions.yml`
- **Schedule**: Daily at midnight UTC
- **Purpose**: Fetches latest available versions from GitHub releases

### Version Update
- **File**: `.github/workflows/update-runner-with-selection.yml`
- **Trigger**: Manual workflow dispatch
- **Process**:
  1. Version selection based on mode
  2. Lambda artifacts download
  3. Terraform Cloud variable update
  4. Pull Request creation
  5. Terraform Plan execution

## Update Modes

1. **latest_stable**: Automatically selects the latest stable release
2. **select_version**: Shows available versions (auto-selects latest for automation)
3. **custom_version**: Allows manual version specification

## Monitoring

The automation provides:
- Pull Request with detailed update information
- Terraform Cloud Plan results
- Progress tracking through GitHub Actions logs
- Version history in `.github/data/` directory

## Security

- All sensitive data stored in GitHub Secrets
- Terraform Cloud API token with minimal permissions
- AWS credentials with least privilege access
- No secrets exposed in logs or code

## Troubleshooting

### Common Issues

1. **Lambda concurrent execution error**: Ensure lambda_*_reserved_concurrent_executions are set to null
2. **S3 bucket creation failure**: Check AWS permissions for S3 operations
3. **Terraform Cloud API errors**: Verify TF_CLOUD_TOKEN permissions

### Debug Mode

Add `debug: true` to workflow inputs for verbose logging.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and test
4. Submit a pull request

## License

This project is licensed under the MIT License.
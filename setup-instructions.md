# Setup Instructions

## Step-by-Step Implementation Guide

### 1. Create GitHub Repository

```bash
# Create new repository on GitHub
# Repository name: terraform-aws-github-runner-automation
```

### 2. Initial Git Setup

```bash
cd github-runner-automation
git init
git add .
git commit -m "Initial automation setup"
git branch -M main
git remote add origin https://github.com/YOUR_ORG/terraform-aws-github-runner-automation.git
git push -u origin main
```

### 3. Configure GitHub Secrets

Go to repository Settings → Secrets and variables → Actions

Add the following Repository secrets:

```
AWS_ACCESS_KEY_ID              = your_aws_access_key
AWS_SECRET_ACCESS_KEY          = your_aws_secret_key
TF_CLOUD_TOKEN                 = your_terraform_cloud_token
TF_VAR_RUNNER_VERSION_ID       = terraform_variable_id
```

### 4. Get Terraform Cloud API Token

1. Log in to [Terraform Cloud](https://app.terraform.io/)
2. Go to User Settings → Tokens
3. Click "Create an API token"
4. Name: `github-actions-automation`
5. Copy the generated token

### 5. Get Terraform Variable ID

```bash
# Use this API call to get the variable ID
curl -H "Authorization: Bearer YOUR_TF_CLOUD_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/YOUR_WORKSPACE_ID/vars" | \
  jq '.data[] | select(.attributes.key == "runner_module_version") | .id'
```

### 6. Update Configuration Files

Edit the following files with your specific values:

**terraform.tf:**
```hcl
cloud {
  organization = "YOUR_ORGANIZATION_NAME"
  workspaces {
    name = "YOUR_WORKSPACE_NAME"
  }
}
```

**Environment variables in workflows:**
```yaml
env:
  TF_CLOUD_ORGANIZATION: "YOUR_ORGANIZATION_NAME"
  TF_CLOUD_WORKSPACE: "YOUR_WORKSPACE_NAME"
```

### 7. Set Up Terraform Cloud Workspace

1. Create workspace in Terraform Cloud
2. Connect to your GitHub repository
3. Set working directory to `/` (root)
4. Configure workspace variables:

**Environment Variables:**
```
AWS_ACCESS_KEY_ID     = your_aws_access_key        # Sensitive
AWS_SECRET_ACCESS_KEY = your_aws_secret_key        # Sensitive
```

**Terraform Variables:**
```
runner_module_version = "5.0.0"                   # String
aws_region           = "ap-northeast-1"            # String
vpc_id              = "vpc-xxxxxxxxx"              # String
subnet_ids          = ["subnet-xxxxxxxxx"]         # List(string)
environment         = "production"                 # String
github_app_id       = "123456"                     # String
github_app_private_key = "base64_encoded_key"      # String, Sensitive
```

### 8. Test the Setup

Run the version check workflow:

```bash
# Manual trigger for testing
gh workflow run list-available-versions.yml
```

Check workflow results in GitHub Actions tab.

### 9. First Version Update

Run the update workflow:

```bash
# Update to latest stable version
gh workflow run update-runner-with-selection.yml -f update_mode=latest_stable
```

### 10. Monitor and Validate

1. Check the created Pull Request
2. Review Terraform Cloud Plan
3. Approve and merge PR if everything looks good
4. Execute Apply in Terraform Cloud

## Troubleshooting

### Issue: Workflow fails with "Resource not accessible by integration"

**Solution**: Ensure repository has correct permissions:
- Settings → Actions → General → Workflow permissions
- Select "Read and write permissions"

### Issue: Terraform Cloud API authentication fails

**Solution**: Verify TF_CLOUD_TOKEN secret:
- Check token has correct permissions
- Ensure organization/workspace names are correct

### Issue: AWS credentials error

**Solution**: Verify AWS IAM permissions:
- Ensure user has necessary EC2, Lambda, S3, IAM permissions
- Check credentials are correctly set in secrets

### Issue: Lambda concurrent execution error

**Solution**: Set reserved_concurrent_executions to null in main.tf:
```hcl
lambda_scale_up_reserved_concurrent_executions = null
lambda_scale_down_reserved_concurrent_executions = null
```

## Next Steps

1. Set up monitoring and alerts
2. Configure backup procedures
3. Document operational procedures
4. Train team members on the workflow
5. Set up staging environment for testing

## Support

For issues and questions:
1. Check GitHub Actions logs
2. Review Terraform Cloud run details
3. Consult the main README.md
4. Create GitHub issue for persistent problems
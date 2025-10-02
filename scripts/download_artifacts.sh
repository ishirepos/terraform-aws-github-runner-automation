#!/bin/bash
set -e

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 5.1.1"
  exit 1
fi

echo "Downloading Lambda artifacts for version $VERSION..."

# S3バケット作成（存在しない場合）
BUCKET_NAME="terraform-lambda-artifacts-$(date +%s)"
aws s3 mb s3://$BUCKET_NAME

# Lambda zipファイルダウンロード
curl -L -o /tmp/webhook.zip \
  "https://github.com/github-aws-runners/terraform-aws-github-runner/releases/download/v$VERSION/webhook.zip"

curl -L -o /tmp/runners.zip \
  "https://github.com/github-aws-runners/terraform-aws-github-runner/releases/download/v$VERSION/runners.zip"

curl -L -o /tmp/runner-binaries-syncer.zip \
  "https://github.com/github-aws-runners/terraform-aws-github-runner/releases/download/v$VERSION/runner-binaries-syncer.zip"

# S3にアップロード
aws s3 cp /tmp/webhook.zip s3://$BUCKET_NAME/v$VERSION/webhook.zip
aws s3 cp /tmp/runners.zip s3://$BUCKET_NAME/v$VERSION/runners.zip
aws s3 cp /tmp/runner-binaries-syncer.zip s3://$BUCKET_NAME/v$VERSION/runner-binaries-syncer.zip

echo "Artifacts uploaded to s3://$BUCKET_NAME/v$VERSION/"
echo "Update your Terraform variables:"
echo "lambda_s3_bucket = \"$BUCKET_NAME\""
echo "lambda_s3_key_prefix = \"v$VERSION/\""
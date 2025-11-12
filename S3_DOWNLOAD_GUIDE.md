# AWS S3 HTML Download Guide

This guide explains how to download HTML files from AWS S3 using the provided curl-based script.

## Overview

The `download_s3_html.sh` script allows you to download HTML files from AWS S3 buckets using curl with AWS Signature Version 4 authentication. This method is useful for automated downloads without requiring the AWS CLI.

## Prerequisites

- `curl` - Command-line tool for transferring data
- `openssl` - For generating AWS signatures
- `file` - For verifying file types (optional)
- AWS credentials with read access to the S3 bucket

## Setup

### 1. Set AWS Credentials

The script requires AWS credentials to be set as environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_REGION="us-east-1"  # Optional, defaults to us-east-1
```

### 2. Configure AWS Region

If your S3 bucket is in a different region, set the `AWS_REGION` environment variable:

```bash
export AWS_REGION="eu-west-1"  # For Europe (Ireland)
export AWS_REGION="ap-southeast-1"  # For Asia Pacific (Singapore)
export AWS_REGION="us-west-2"  # For US West (Oregon)
```

## Usage

### Basic Syntax

```bash
./download_s3_html.sh <s3-bucket> <s3-key> <output-file>
```

**Parameters:**
- `s3-bucket` - Name of your S3 bucket (without s3:// prefix)
- `s3-key` - Path to the HTML file within the bucket
- `output-file` - Local path where the file should be saved

### Examples

#### Example 1: Download a risk analysis report

```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_REGION="us-east-1"

./download_s3_html.sh risk-intelligence-reports analysis/geopolitical-risk-2025.html ./reports/risk-2025.html
```

#### Example 2: Download investment intelligence data

```bash
./download_s3_html.sh investment-data intelligence/market-analysis.html ./data/market.html
```

#### Example 3: Download from a specific region

```bash
export AWS_REGION="eu-central-1"
./download_s3_html.sh eu-risk-reports europe/analysis.html ./eu-analysis.html
```

## Security Best Practices

### 1. Protect Your Credentials

**DO NOT** hardcode credentials in scripts. Always use environment variables or AWS credential files.

**Bad Practice:**
```bash
# Don't do this!
AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE" ./download_s3_html.sh ...
```

**Good Practice:**
```bash
# Use a secure credential file
source ~/.aws/credentials.env
./download_s3_html.sh ...
```

### 2. Use IAM Roles When Possible

When running on EC2 or other AWS services, use IAM roles instead of access keys:

```bash
# IAM role is automatically detected
./download_s3_html.sh my-bucket reports/file.html ./file.html
```

### 3. Restrict S3 Bucket Permissions

Ensure your IAM user/role only has the minimum required permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

### 4. Use Environment Files

Create a `.env` file (add to `.gitignore`):

```bash
# .env
AWS_ACCESS_KEY_ID=your-key-id
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
```

Load it before running:

```bash
source .env
./download_s3_html.sh ...
```

## Troubleshooting

### Error: AWS_ACCESS_KEY_ID environment variable is not set

**Solution:** Set the required environment variables before running the script.

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
./download_s3_html.sh ...
```

### Error: Failed to download file (403 Forbidden)

**Possible causes:**
1. Invalid AWS credentials
2. Insufficient permissions (IAM policy doesn't allow s3:GetObject)
3. Bucket policy denies access
4. Incorrect bucket name or region

**Solution:** Verify your credentials and IAM permissions.

### Error: Failed to download file (404 Not Found)

**Possible causes:**
1. Incorrect S3 key (file path)
2. File doesn't exist in the bucket
3. Wrong bucket name

**Solution:** Verify the bucket name and file path are correct.

### Warning: File may not be HTML format

**Cause:** The downloaded file is not recognized as HTML.

**Solution:** Check if you downloaded the correct file. The script will still save the file, but it may not be HTML format.

## Advanced Usage

### Batch Download Multiple Files

Create a script to download multiple files:

```bash
#!/bin/bash

# Source AWS credentials
source ~/.aws/credentials.env

# Define files to download
declare -A files=(
    ["reports/risk-analysis-2025.html"]="./data/risk-2025.html"
    ["reports/investment-intel-q1.html"]="./data/intel-q1.html"
    ["reports/market-trends.html"]="./data/trends.html"
)

# Download each file
for s3_key in "${!files[@]}"; do
    output_file="${files[$s3_key]}"
    echo "Downloading $s3_key..."
    ./download_s3_html.sh my-bucket "$s3_key" "$output_file"
done
```

### Integrating with Cron Jobs

Schedule automatic downloads:

```bash
# Edit crontab
crontab -e

# Add this line to download daily at 2 AM
0 2 * * * source ~/.aws/credentials.env && /path/to/download_s3_html.sh risk-reports daily-report.html /data/report.html
```

### Verifying Downloaded Content

Check if the downloaded HTML is valid:

```bash
# Download the file
./download_s3_html.sh my-bucket report.html ./report.html

# Verify it's valid HTML
if grep -q "<html" ./report.html; then
    echo "Valid HTML file"
else
    echo "Warning: May not be valid HTML"
fi
```

## How It Works

The script uses AWS Signature Version 4 authentication to make authenticated requests to S3:

1. **Generates timestamp** - Creates ISO 8601 formatted timestamp for the request
2. **Creates canonical request** - Formats the HTTP request in AWS canonical format
3. **Generates signing key** - Derives a signing key from your secret access key
4. **Calculates signature** - Creates HMAC-SHA256 signature of the request
5. **Makes authenticated request** - Uses curl with proper AWS authorization headers

This approach allows downloading from S3 without installing the AWS CLI.

## Alternative Methods

While this script uses curl with AWS Signature V4, consider these alternatives:

### AWS CLI (Recommended for complex operations)
```bash
aws s3 cp s3://bucket-name/file.html ./file.html
```

### Pre-signed URLs (For sharing)
```bash
# Generate a pre-signed URL (requires AWS CLI)
aws s3 presign s3://bucket-name/file.html --expires-in 3600

# Then use curl with the pre-signed URL
curl -o file.html "https://bucket-name.s3.amazonaws.com/file.html?X-Amz-Algorithm=..."
```

## Support

For issues or questions about AWS S3, refer to:
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [AWS Signature V4 Documentation](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html)

## License

This script is provided as-is under the repository license.

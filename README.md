# risk-intelligence
geopolitical risk and investment intelligence

## Features

### AWS S3 HTML File Download

This repository includes a script to download HTML files from AWS S3 using curl with AWS Signature Version 4 authentication.

**Quick Start:**

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"

# Download HTML file from S3
./download_s3_html.sh my-bucket reports/analysis.html ./analysis.html
```

For detailed usage instructions, security best practices, and troubleshooting, see [S3_DOWNLOAD_GUIDE.md](S3_DOWNLOAD_GUIDE.md).

## Documentation

- [S3 Download Guide](S3_DOWNLOAD_GUIDE.md) - Complete guide for downloading HTML files from AWS S3

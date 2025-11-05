#!/bin/bash

#############################################################################
# Script: download_s3_html.sh
# Description: Download HTML files from AWS S3 using curl with AWS Signature V4
# Usage: ./download_s3_html.sh <s3-bucket> <s3-key> <output-file>
#############################################################################

set -e  # Exit on error

# Function to display usage
usage() {
    echo "Usage: $0 <s3-bucket> <s3-key> <output-file>"
    echo ""
    echo "Arguments:"
    echo "  s3-bucket    - Name of the S3 bucket"
    echo "  s3-key       - S3 object key (path to the HTML file)"
    echo "  output-file  - Local path where the file will be saved"
    echo ""
    echo "Environment Variables Required:"
    echo "  AWS_ACCESS_KEY_ID     - AWS access key"
    echo "  AWS_SECRET_ACCESS_KEY - AWS secret key"
    echo "  AWS_REGION            - AWS region (default: us-east-1)"
    echo ""
    echo "Example:"
    echo "  export AWS_ACCESS_KEY_ID='your-access-key'"
    echo "  export AWS_SECRET_ACCESS_KEY='your-secret-key'"
    echo "  export AWS_REGION='us-east-1'"
    echo "  $0 my-bucket reports/analysis.html ./analysis.html"
    exit 1
}

# Check arguments
if [ $# -ne 3 ]; then
    echo "Error: Invalid number of arguments"
    usage
fi

S3_BUCKET="$1"
S3_KEY="$2"
OUTPUT_FILE="$3"

# Check required environment variables
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Error: AWS_ACCESS_KEY_ID environment variable is not set"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Error: AWS_SECRET_ACCESS_KEY environment variable is not set"
    exit 1
fi

# Set default region if not provided
AWS_REGION="${AWS_REGION:-us-east-1}"

# AWS S3 endpoint
S3_HOST="${S3_BUCKET}.s3.${AWS_REGION}.amazonaws.com"
S3_URL="https://${S3_HOST}/${S3_KEY}"

# Generate timestamp
DATE_VALUE=$(date -u +"%Y%m%dT%H%M%SZ")
DATE_STAMP=$(date -u +"%Y%m%d")

# Function to generate HMAC-SHA256
hmac_sha256() {
    key="$1"
    data="$2"
    echo -n "$data" | openssl dgst -sha256 -mac HMAC -macopt "$key" | sed 's/^.* //'
}

# Function to generate SHA256 hash
sha256_hash() {
    echo -n "$1" | openssl dgst -sha256 | sed 's/^.* //'
}

# Generate AWS Signature Version 4
generate_signature() {
    # Create canonical request
    METHOD="GET"
    CANONICAL_URI="/${S3_KEY}"
    CANONICAL_QUERY=""
    CANONICAL_HEADERS="host:${S3_HOST}\nx-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\nx-amz-date:${DATE_VALUE}\n"
    SIGNED_HEADERS="host;x-amz-content-sha256;x-amz-date"
    PAYLOAD_HASH="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"  # SHA256 of empty string
    
    CANONICAL_REQUEST="${METHOD}\n${CANONICAL_URI}\n${CANONICAL_QUERY}\n${CANONICAL_HEADERS}\n${SIGNED_HEADERS}\n${PAYLOAD_HASH}"
    
    # Create string to sign
    ALGORITHM="AWS4-HMAC-SHA256"
    CREDENTIAL_SCOPE="${DATE_STAMP}/${AWS_REGION}/s3/aws4_request"
    CANONICAL_REQUEST_HASH=$(sha256_hash "$CANONICAL_REQUEST")
    STRING_TO_SIGN="${ALGORITHM}\n${DATE_VALUE}\n${CREDENTIAL_SCOPE}\n${CANONICAL_REQUEST_HASH}"
    
    # Calculate signing key
    K_SECRET="AWS4${AWS_SECRET_ACCESS_KEY}"
    K_DATE=$(echo -n "${DATE_STAMP}" | openssl dgst -sha256 -mac HMAC -macopt "key:${K_SECRET}" -binary | xxd -p -c 256)
    K_REGION=$(echo -n "${AWS_REGION}" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:${K_DATE}" -binary | xxd -p -c 256)
    K_SERVICE=$(echo -n "s3" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:${K_REGION}" -binary | xxd -p -c 256)
    K_SIGNING=$(echo -n "aws4_request" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:${K_SERVICE}" -binary | xxd -p -c 256)
    
    # Generate signature
    SIGNATURE=$(echo -n -e "${STRING_TO_SIGN}" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:${K_SIGNING}" | sed 's/^.* //')
    
    echo "$SIGNATURE"
}

# Generate authorization header
SIGNATURE=$(generate_signature)
CREDENTIAL="${AWS_ACCESS_KEY_ID}/${DATE_STAMP}/${AWS_REGION}/s3/aws4_request"
AUTHORIZATION="AWS4-HMAC-SHA256 Credential=${CREDENTIAL}, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=${SIGNATURE}"

echo "Downloading from S3..."
echo "Bucket: ${S3_BUCKET}"
echo "Key: ${S3_KEY}"
echo "Region: ${AWS_REGION}"
echo "Output: ${OUTPUT_FILE}"

# Download the file using curl with AWS Signature V4 authentication
curl -f -S -s \
    -H "Host: ${S3_HOST}" \
    -H "x-amz-content-sha256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" \
    -H "x-amz-date: ${DATE_VALUE}" \
    -H "Authorization: ${AUTHORIZATION}" \
    -o "${OUTPUT_FILE}" \
    "${S3_URL}"

if [ $? -eq 0 ]; then
    echo "✓ Successfully downloaded to ${OUTPUT_FILE}"
    
    # Verify it's an HTML file
    if file "${OUTPUT_FILE}" | grep -q "HTML"; then
        echo "✓ Verified: File is HTML format"
    else
        echo "⚠ Warning: Downloaded file may not be HTML format"
    fi
    
    # Display file size
    FILE_SIZE=$(du -h "${OUTPUT_FILE}" | cut -f1)
    echo "File size: ${FILE_SIZE}"
else
    echo "✗ Error: Failed to download file"
    exit 1
fi

#!/bin/bash

#############################################################################
# Example usage script for download_s3_html.sh
# This demonstrates how to use the S3 HTML download script
#############################################################################

echo "=== AWS S3 HTML Download Example ==="
echo ""
echo "This example demonstrates how to download HTML files from AWS S3"
echo ""

# Example 1: Basic usage
echo "Example 1: Basic Download"
echo "-------------------------"
echo "export AWS_ACCESS_KEY_ID=\"your-access-key-id\""
echo "export AWS_SECRET_ACCESS_KEY=\"your-secret-access-key\""
echo "export AWS_REGION=\"us-east-1\""
echo "./download_s3_html.sh my-bucket reports/risk-analysis.html ./analysis.html"
echo ""

# Example 2: Download from different region
echo "Example 2: Download from EU Region"
echo "-----------------------------------"
echo "export AWS_REGION=\"eu-west-1\""
echo "./download_s3_html.sh eu-bucket reports/europe-analysis.html ./eu-analysis.html"
echo ""

# Example 3: Batch download
echo "Example 3: Batch Download Multiple Files"
echo "-----------------------------------------"
cat << 'EOF'
#!/bin/bash
FILES=(
    "reports/jan-2025.html:./data/jan.html"
    "reports/feb-2025.html:./data/feb.html"
    "reports/mar-2025.html:./data/mar.html"
)

for file_pair in "${FILES[@]}"; do
    s3_key="${file_pair%%:*}"
    output="${file_pair##*:}"
    ./download_s3_html.sh my-bucket "$s3_key" "$output"
done
EOF
echo ""

# Example 4: Using with error handling
echo "Example 4: With Error Handling"
echo "-------------------------------"
cat << 'EOF'
if ./download_s3_html.sh my-bucket report.html ./report.html; then
    echo "Download successful! Processing file..."
    # Process the downloaded file
    cat ./report.html
else
    echo "Download failed! Check your credentials and file path."
    exit 1
fi
EOF
echo ""

echo "For complete documentation, see S3_DOWNLOAD_GUIDE.md"

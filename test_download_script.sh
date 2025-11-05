#!/bin/bash

#############################################################################
# Test script for download_s3_html.sh
# Tests error handling and validation logic
#############################################################################

TEST_SCRIPT="./download_s3_html.sh"
PASS=0
FAIL=0

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=== Testing download_s3_html.sh ==="
echo ""

# Test 1: Script exists and is executable
test_1() {
    echo -n "Test 1: Script exists and is executable... "
    if [ -x "$TEST_SCRIPT" ]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Test 2: Script shows usage when no arguments provided
test_2() {
    echo -n "Test 2: Shows usage without arguments... "
    output=$("$TEST_SCRIPT" 2>&1 || true)
    if echo "$output" | grep -q "Usage:"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Expected usage message not found"
        return 1
    fi
}

# Test 3: Script requires AWS_ACCESS_KEY_ID
test_3() {
    echo -n "Test 3: Requires AWS_ACCESS_KEY_ID... "
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    output=$("$TEST_SCRIPT" test-bucket test-key test-output 2>&1 || true)
    if echo "$output" | grep -q "AWS_ACCESS_KEY_ID"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Expected AWS_ACCESS_KEY_ID error not found"
        return 1
    fi
}

# Test 4: Script requires AWS_SECRET_ACCESS_KEY
test_4() {
    echo -n "Test 4: Requires AWS_SECRET_ACCESS_KEY... "
    export AWS_ACCESS_KEY_ID="test-key"
    unset AWS_SECRET_ACCESS_KEY
    output=$("$TEST_SCRIPT" test-bucket test-key test-output 2>&1 || true)
    if echo "$output" | grep -q "AWS_SECRET_ACCESS_KEY"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Expected AWS_SECRET_ACCESS_KEY error not found"
        return 1
    fi
}

# Test 5: Script has proper shebang
test_5() {
    echo -n "Test 5: Has proper bash shebang... "
    first_line=$(head -n 1 "$TEST_SCRIPT")
    if [ "$first_line" = "#!/bin/bash" ]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Expected #!/bin/bash, got: $first_line"
        return 1
    fi
}

# Test 6: Script contains AWS Signature V4 logic
test_6() {
    echo -n "Test 6: Contains AWS Signature V4 logic... "
    if grep -q "AWS4-HMAC-SHA256" "$TEST_SCRIPT"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "AWS Signature V4 logic not found"
        return 1
    fi
}

# Test 7: Script validates argument count
test_7() {
    echo -n "Test 7: Validates argument count... "
    export AWS_ACCESS_KEY_ID="test"
    export AWS_SECRET_ACCESS_KEY="test"
    # Test with wrong number of arguments
    output=$("$TEST_SCRIPT" only-one-arg 2>&1 || true)
    if echo "$output" | grep -q "Invalid number of arguments"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Argument validation not found"
        return 1
    fi
}

# Test 8: README contains documentation
test_8() {
    echo -n "Test 8: README mentions S3 download feature... "
    if grep -q "download_s3_html.sh" README.md; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "README doesn't mention the script"
        return 1
    fi
}

# Test 9: Documentation file exists
test_9() {
    echo -n "Test 9: S3_DOWNLOAD_GUIDE.md exists... "
    if [ -f "S3_DOWNLOAD_GUIDE.md" ]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Test 10: Example usage script exists
test_10() {
    echo -n "Test 10: example_usage.sh exists and is executable... "
    if [ -x "example_usage.sh" ]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Run all tests
run_tests() {
    for i in {1..10}; do
        if test_$i; then
            ((PASS++))
        else
            ((FAIL++))
        fi
    done
}

# Execute tests
run_tests

# Summary
echo ""
echo "=== Test Summary ==="
echo -e "Passed: ${GREEN}${PASS}/10${NC}"
echo -e "Failed: ${RED}${FAIL}/10${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi

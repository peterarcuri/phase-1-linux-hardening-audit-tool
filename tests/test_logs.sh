#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "======================================="
echo " Running Log Rotation Tests"
echo "======================================="

PASS_COUNT=0
FAIL_COUNT=0

# Test 1 - log_rotation.sh exists
echo "[TEST] Checking if log_rotation.sh exists..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$PROJECT_ROOT/src/log_rotation.sh" ]]; then
    echo "[PASS] log_rotation.sh found"
    ((++PASS_COUNT))
else
    echo "[FAIL] log_rotation.sh missing"
    ((++FAIL_COUNT))
fi


# Test 2 - gzip installed
echo
echo "[TEST] Checking if gzip is installed..."

if command -v gzip >/dev/null 2>&1; then
    echo "[PASS] gzip installed"
    ((++PASS_COUNT))
else
    echo "[FAIL] gzip missing"
    ((++FAIL_COUNT))
fi

# Test 3 - find command available
echo
echo "[TEST] Checking if find command exists..."

if command -v find >/dev/null 2>&1; then
    echo "[PASS] find command available"
    ((++PASS_COUNT))
else
    echo "[FAIL] find command missing"
    ((++FAIL_COUNT))
fi

# Test 4 - Archive directory validation
echo
echo "[TEST] Checking archive directory support..."

if mkdir -p /tmp/log_rotation_test/archive >/dev/null 2>&1; then
    echo "[PASS] Archive directory creation successful"
    ((++PASS_COUNT))

    rm -rf /tmp/log_rotation_test
else
    echo "[FAIL] Unable to create archive directory"
    ((++FAIL_COUNT))
fi

echo
echo "======================================="
echo " Log Rotation Test Summary"
echo "======================================="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"
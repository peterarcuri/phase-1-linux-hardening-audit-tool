#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "======================================"
echo "  Running User Management Tests"
echo "======================================"

PASS_COUNT=0
FAIL_COUNT=0

# Test 1 - useradd exists
echo "[TEST] Checking if useradd exists..."

if command -v useradd >/dev/null 2>&1; then
    echo "[PASS] useradd command available"
    ((++PASS_COUNT))
else
    echo "[FAIL] useadd command missing"
    ((++FAIL_COUNT))
fi 

# Test 2 - users file exists
echo
echo "[TEST] Checking users/users.txt..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$PROJECT_ROOT/users/users.txt" ]]; then
    echo "[PASS] users.txt found"
    ((++PASS_COUNT))
else
    echo "[FAIL] users.txt missing"
    ((++FAIL_COUNT))
fi

# Test 3 groupadd exists
echo
echo "[TEST] Checking if groupadd exists..."

if command -v groupadd >/dev/null 2>&1; then
    echo "[PASS] groupadd command available"
    ((++PASS_COUNT))
else
    echo "[FAIL] groupadd command missing"
    ((++FAIL_COUNT))
fi 

echo
echo "==========================================="
echo " User Management Test Summary"
echo "==========================================="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"



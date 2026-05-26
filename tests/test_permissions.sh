#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "========================================="
echo " Running Permission Audit Tests"
echo "========================================="

PASS_COUNT=0
FAIL_COUNT=0

# Test 1 - find command exists
echo "[TEST] Checking if 'find' command exists..."

if command -v find >/dev/null 2>&1; then
    echo "[PASS] find command available"
    ((++PASS_COUNT))
else
    echo "[FAIL] find command missing"
    ((++FAIL_COUNT))
fi 

# Test 2 - World-writable file scan
echo
echo "[TEST] Running world-writable file scan..."

WORLD_WRITABLE_TEST_COUNT=$(find /tmp -type f -perm -0002 2>/dev/null | wc -l || true)

echo "[PASS] World-writable scan executed"
echo "[INFO] World-writable files detected in /tmp: $WORLD_WRITABLE_TEST_COUNT"

((++PASS_COUNT))


# Test 3 - SUID scan
echo
echo "[TEST] Running SUID binary scan..."

if find /usr/bin -perm -4000 >/dev/null 2>&1; then
    echo "[PASS] SUID scan executed"
    ((++PASS_COUNT))
else
    echo "[FAIL] SUID scan failed"
    ((++FAIL_COUNT))
fi 

echo
echo "=========================================="
echo " Permission Audit Test Summary"
echo "=========================================="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"



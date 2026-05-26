#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "==========================================="
echo " Running Firewall Tests"
echo "==========================================="

PASS_COUNT=0
FAIL_COUNT=0

# Test 1 - UFW installed
echo "[TEST] Checking if UFW is installed..."

if command -v ufw >/dev/null 2>&1; then
    echo "[PASS] UFW installed"
    ((++PASS_COUNT))
else
    echo "[FAIL] UFW not installed"
    ((++FAIL_COUNT))
fi 

# Test 2 - UFW Status
echo
echo "[TEST] Checking UFW status..."

if sudo ufw status >/dev/null 2>&1; then 
    echo "[PASS] UFW status command executed"
    ((++PASS_COUNT))
else    
    echo "[FAIL] Unable to read UFW status"
    ((++FAIL_COUNT))
fi 

# Test 3 - Listening ports
echo 
echo "[TEST] Checking listening ports..."

if ss -tuln >/dev/null 2>&1; then
    echo "[PASS] Listening port scan successful"
    ((++PASS_COUNT))
else
    echo "[FAIL] Listening port scan failed"
    ((++FAIL_COUNT))
fi 

echo
echo "===================================="
echo " Firewall Test Summary"
echo "===================================="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"


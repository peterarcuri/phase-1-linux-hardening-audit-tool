#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "===================================================="
echo " Linux Hardening Audit Tool Test Suite"
echo "===================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$SCRIPT_DIR"/test_*.sh

echo
echo "[+] Running Permission Tests..."
bash "$SCRIPT_DIR/test_permissions.sh"

echo
echo "[+] Running Firewall Tests..."
bash "$SCRIPT_DIR/test_firewall.sh"

echo 
echo "[+] Running User Management Tests..."
bash "$SCRIPT_DIR/test_users.sh"

echo
echo "[+] Running Log Rotation Tests..."
bash "$SCRIPT_DIR/test_logs.sh"

echo
echo "============================================"
echo " All Tests Completed"
echo "============================================"


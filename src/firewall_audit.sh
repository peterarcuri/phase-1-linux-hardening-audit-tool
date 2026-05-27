#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# =======================================
# Linux Hardening Audit Tool
# Firewall Audit Module
# =======================================

check_ufw_installed() {
    echo "[+] Checking if UFW is installed..."

    if command -v ufw >/dev/null 2>&1; then
        echo "[PASS] UFW is installed"
    else
        echo "[WARN] UFW is not installed"
    fi
}

check_ufw_status() {
    echo "[+] Checking UFW status..."

    if command -v ufw >/dev/null 2>&1; then
        sudo ufw status verbose
    else
        echo "[SKIP] Cannot check UFW status because UFW is not installed"
    fi
}

check_iptables_rules() {
    echo "[+] Checking iptables rules..."

    if command -v iptables >/dev/null 2>&1; then
        sudo iptables -L -n -v
    else
        echo "[WARN] iptables is not installed or unavailable"
    fi
}

check_listening_ports() {
    echo "[+] Checking listening network ports..."

    if command -v ss >/dev/null 2>&1; then
        sudo ss -tulnp
    elif command -v netstat >/dev/null 2>&1; then
        sudo netstat -tulnp
    else
        echo "[WARN] Neither ss nor netstat is available"
    fi
}

check_common_risky_ports() {
    echo "[+] Checking for commonly risky open ports..."

    RISKY_PORTS=("21" "23" "25" "3306" "5432" "6379" "27017")

    if command -v ss >/dev/null 2>&1; then
        LISTENING_PORTS=$(sudo ss -tuln || true)

        for port in "${RISKY_PORTS[@]}"; do
            if echo "$LISTENING_PORTS" | grep -q ":$port "; then
                echo "[WARN] Risky port appears to be listening: $port"
            else
                echo "[PASS] Risky port not detected: $port"
            fi
        done
    else
        echo "[SKIP] Cannot check risky ports because ss is unavailable"
    fi
}

run_firewall_audit() {
    echo "======================================="
    echo " Running Firewall Audit"
    echo "======================================="

    check_ufw_installed
    echo

    check_ufw_status
    echo

    check_iptables_rules
    echo

    check_listening_ports
    echo

    check_common_risky_ports

    echo
    echo "======================================="
    echo " Firewall Audit Complete"
    echo "======================================="
}

# Run only when this script is executed directly
# Do not auto-run when sourced by audit.sh
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_firewall_audit
fi
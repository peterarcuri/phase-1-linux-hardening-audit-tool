#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Get the absolute path of the directory where this script lives (the 'src' folder)
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Source the configuration file
source "$SCRIPT_DIR/../config/audit.conf"

# Source the utility and audit modules from the same 'src' folder
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/permission_audit.sh"
source "$SCRIPT_DIR/user_management.sh"
source "$SCRIPT_DIR/firewall_audit.sh"
source "$SCRIPT_DIR/log_rotation.sh"


TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/audit-report-$TIMESTAMP.json"

mkdir -p "$REPORT_DIR"
mkdir -p "$LOG_DIR"

log_info "Starting Linux Hardening Audit..."

WORLD_WRITABLE_COUNT=$(find / -type f -perm -0002 2>/dev/null | wc -l || true)
SUID_COUNT=$(find / -perm -4000 2>/dev/null | wc -l || true)
SGID_COUNT=$(find / -perm -2000 2>/dev/null | wc -l || true)

if command -v ufw >/dev/null 2>&1; then
    UFW_STATUS=$(sudo ufw status | head -n 1 | awk '{print $2}')
else
    UFW_STATUS="not_installed"
fi

if [[ -d "$LOG_DIR" ]]; then
    LOG_ROTATION_READY=true
else
    LOG_ROTATION_READY=false
fi

cat <<EOF > "$REPORT_FILE"
{
  "timestamp": "$TIMESTAMP",
  "permission_audit": {
    "world_writable_files": $WORLD_WRITABLE_COUNT,
    "suid_binaries": $SUID_COUNT,
    "sgid_binaries": $SGID_COUNT
  },
  "firewall_audit": {
    "ufw_status": "$UFW_STATUS"
  },
  "log_management": {
    "log_directory": "$LOG_DIR",
    "log_rotation_ready": $LOG_ROTATION_READY
  }
}
EOF

log_info "Audit completed."
log_info "Report saved to $REPORT_FILE"


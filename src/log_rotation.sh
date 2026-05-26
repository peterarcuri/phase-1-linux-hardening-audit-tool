#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# =======================================
# Linux Hardening Audit Tool
# Log Rotation & Archiving Module
# =======================================

# Default configuration
LOG_DIR="/var/log/custom-app"
ARCHIVE_DIR="$LOG_DIR/archive"
RETENTION_DAYS=7
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# =======================================
# Helper Functions
# =======================================

log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1"
}

# =======================================
# Validate Directories
# =======================================

validate_directories() {

    log_info "Validating log directories..."

    if [[ ! -d "$LOG_DIR" ]]; then
        log_warn "Log directory does not exist. Creating: $LOG_DIR"
        sudo mkdir -p "$LOG_DIR"
    fi

    if [[ ! -d "$ARCHIVE_DIR" ]]; then
        log_warn "Archive directory does not exist. Creating: $ARCHIVE_DIR"
        sudo mkdir -p "$ARCHIVE_DIR"
    fi
}

# =======================================
# Compress Old Logs
# =======================================

compress_old_logs() {

    log_info "Compressing logs older than $RETENTION_DAYS days..."

    find "$LOG_DIR" \
        -type f \
        -name "*.log" \
        -mtime +"$RETENTION_DAYS" \
        ! -name "*.gz" \
        -exec gzip {} \;

    log_info "Log compression completed."
}

# =======================================
# Move Compressed Logs To Archive
# =======================================

archive_logs() {

    log_info "Archiving compressed logs..."

    find "$LOG_DIR" \
        -maxdepth 1 \
        -type f \
        -name "*.gz" \
        -exec mv {} "$ARCHIVE_DIR"/ \;

    log_info "Log archiving completed."
}

# =======================================
# Cleanup Old Archives
# =======================================

cleanup_old_archives() {

    log_info "Removing archives older than 30 days..."

    find "$ARCHIVE_DIR" \
        -type f \
        -name "*.gz" \
        -mtime +30 \
        -delete

    log_info "Old archive cleanup completed."
}

# =======================================
# Display Summary
# =======================================

display_summary() {

    echo
    echo "======================================="
    echo " Log Rotation Summary"
    echo "======================================="
    echo "Log Directory:      $LOG_DIR"
    echo "Archive Directory:  $ARCHIVE_DIR"
    echo "Retention Days:     $RETENTION_DAYS"
    echo "Execution Time:     $TIMESTAMP"
    echo "======================================="
}

# =======================================
# Main Execution
# =======================================

main() {

    log_info "Starting log rotation module..."

    validate_directories

    compress_old_logs

    archive_logs

    cleanup_old_archives

    display_summary

    log_info "Log rotation module completed successfully."
}


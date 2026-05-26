#!bin/bash

audit_world_writable() {
    echo "[+] Scanning for world-writable files..."

    find / -type f -perm -0002 2>/dev/null
}

audit_suid() {
    echo "[+] Scanning for SUID binaries..."

    find / -perm -4000 2>/dev/null
}


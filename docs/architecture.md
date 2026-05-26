# Architecture - Linux Hardening Audit Tool

## Overview

The Linux Hardening Audit Tool is a modular Bash-based security auditing and hardening framework designed for Linux environments.

The project focuses on:

- security auditing
- least privilege enforcement
- firewall validation
- SSH hardening
- user provisioning
- log management
- structured JSON reporting

The architecture emphasizes modularity, maintainability, and operational simplicity.

---

# High-Level Architecture

```text
User
  │
  ▼
audit.sh (Main Orchestrator)
  │
  ├── Loads configuration
  ├── Initializes logging
  ├── Executes audit modules
  ├── Collects findings
  └── Generates JSON report
          │
          ▼
   reports/audit-report-<timestamp>.json
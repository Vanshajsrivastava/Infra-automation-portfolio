#!/bin/bash

set -euo pipefail  # Safe scripting

# ===== CONFIG =====
LOG_DIR="/var/log"
DAYS_TO_KEEP=7
LOG_FILE="/var/log/log-cleanup.log"
# ==================

# Timestamp for logging
echo "Log cleanup started at: $(date)" | tee -a "$LOG_FILE"

# Delete .log files older than X days
find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_TO_KEEP -exec rm -f {} \; -print >> "$LOG_FILE" 2>&1

echo "Cleanup finished at: $(date)" | tee -a "$LOG_FILE"
echo "------------------------------------------" >> "$LOG_FILE"

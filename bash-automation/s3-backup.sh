#!/bin/bash
set -euo pipefail

# --- Configurable Variables ---
SOURCE_DIR="${1:-/home/vanshaj/test-backup-dir}"  # Default path if no argument
BACKUP_NAME="backup-$(date +%Y-%m-%d-%H%M%S).tar.gz"
DEST="/tmp/$BACKUP_NAME"
S3_BUCKET="my-devopsbackups"
LOG_FILE="/var/log/s3-backup.log"

# --- Logging Setup ---
log() {
  echo "$1" >> "$LOG_FILE"
}

log "Backup started at: $(date)"

# --- Check if source exists ---
if [ ! -e "$SOURCE_DIR" ]; then
  log "Source path does not exist: $SOURCE_DIR"
  echo "Error: Source path '$SOURCE_DIR' does not exist."
  exit 1
fi

# --- Compress ---
if tar -czf "$DEST" "$SOURCE_DIR"; then
  log "Directory compressed successfully: $DEST"
else
  log "Compression failed!"
  exit 1
fi

# --- Upload to S3 ---
if aws s3 cp "$DEST" "s3://$S3_BUCKET/" >> "$LOG_FILE" 2>&1; then
  log " Upload successful: $BACKUP_NAME"
else
  log " Upload failed!"
  exit 1
fi

log "Backup completed at: $(date)"
log "---------------------------------------"

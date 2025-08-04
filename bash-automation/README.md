# Bash Automation
# Bash Automation Scripts

A collection of **production-ready Bash scripts** designed to automate essential Linux system maintenance and DevOps tasks.

---

## Project Structure

```bash
bash-automation/
├── update-system.sh      # Automates system package updates
├── s3-backup.sh          # Compresses and uploads backups to AWS S3
├── log-cleanup.sh        # Cleans up old log files
└── README.md             # Project documentation
```

---

## Scripts Overview

### update-system.sh

* Performs `apt update && apt upgrade`
* Logs update activity to `/var/log/update-system.log`
* Requires `sudo` for full functionality

### s3-backup.sh

* Compresses any file or directory into a `.tar.gz` archive
* Uploads the archive to an AWS S3 bucket
* Logs steps and outcomes to `/var/log/s3-backup.log`
* Checks for errors and handles failures gracefully

### log-cleanup.sh

* Finds and deletes `.log` files older than 7 days in `/var/log`
* Logs cleanup actions to `/var/log/log-cleanup.log`
* Configurable target directory and retention period

---

## How to Use

1. Clone the repo and navigate into it:

   ```bash
   git clone https://github.com/your-username/bash-automation.git
   cd bash-automation
   ```

2. Make the scripts executable:

   ```bash
   chmod +x *.sh
   ```

3. Run each script as needed:

   ```bash
   sudo ./update-system.sh
   sudo ./s3-backup.sh
   sudo ./log-cleanup.sh
   ```

---

## Requirements

* Bash shell (Linux/WSL)
* AWS CLI configured (`aws configure`)
* IAM permissions for S3 access (for `s3-backup.sh`)
* Root privileges (for log cleanup and updates)

---

## Test Cases

| Scenario                            | Status |
| ----------------------------------- | ------ |
| Backup a small file to S3           | ✅      |
| Backup a directory to S3            | ✅      |
| Handle AWS credential errors        | ✅      |
| Run update script without `sudo`    | ✅      |
| Clean up logs in a custom directory | ✅      |

---

## Why This Project?

This project demonstrates your ability to:

* Automate real-world system tasks with Bash
* Handle files, permissions, and logging
* Work with AWS S3 and cloud backups
* Use best practices (modular, safe, logged scripting)

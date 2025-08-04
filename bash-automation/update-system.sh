#!/bin/bash

# update-system.sh - Automates system updates and logs the result

LOGFILE="/var/log/update-system.log"

echo "----------------------------------------" >> $LOGFILE
echo "Update started at: $(date)" >> $LOGFILE

# Run system updates
sudo apt update && sudo apt upgrade -y >> $LOGFILE 2>&1

echo "Update completed at: $(date)" >> $LOGFILE
echo "----------------------------------------" >> $LOGFILE

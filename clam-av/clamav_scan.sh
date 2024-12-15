#!/bin/bash

# Run ClamAV scan on the system
/usr/bin/clamscan -r / --exclude-dir="^/sys" --exclude-dir="^/proc" --exclude-dir="^/dev" --exclude-dir="^/run" | tee /var/log/clamav/scan.log | grep -i "FOUND" > /dev/null

# Check if any virus was found
if [ $? -eq 0 ]; then
  notify-send "ClamAV: Virus Found" "A virus was found during the scan. Please check the log for details."
else
  notify-send "ClamAV Scan Completed" "No viruses found during the scan."
fi

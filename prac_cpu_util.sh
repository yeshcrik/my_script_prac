#!/bin/bash

# Set timestamp and filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="report_$TIMESTAMP.txt"

# Directory to save report
REPORT_DIR="./reports"
mkdir -p $REPORT_DIR

# Collect CPU and memory usage
{
    echo "===== System Report for $TIMESTAMP ====="
    echo
    echo ">>> CPU Usage:"
    top -bn1 | grep "Cpu(s)"
    echo
    echo ">>> Memory Usage:"
    free -h
    echo
    echo ">>> Disk Usage:"
    df -h
} > "$REPORT_DIR/$REPORT_FILE"

# Git commit
git add "$REPORT_DIR/$REPORT_FILE"
git commit -m "System report: $REPORT_FILE"
git push origin main

# Upload to S3 (make sure AWS CLI is configured)
aws s3 cp "$REPORT_DIR/$REPORT_FILE" s3://myscriptcpuutil.sh/system-reports/


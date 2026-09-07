#!/bin/bash

THRESHOLD=3

echo "======================================"
echo " SSH BRUTE-FORCE DETECTION SYSTEM"
echo "======================================"
echo

journalctl -u ssh --no-pager |
grep "Failed password" |
grep -oE 'from ([0-9]{1,3}\.){3}[0-9]{1,3}' |
awk '{print $2}' |
sort |
uniq -c |
while read count ip
do
    if [ "$count" -ge "$THRESHOLD" ]; then
        echo "[ALERT] Possible SSH brute-force activity detected!"
        echo "Source IP: $ip"
        echo "Failed Attempts: $count"
        echo "Threshold: $THRESHOLD"
        echo "Recommended Action: Investigate and consider blocking source."
    else
        echo "[INFO] Source IP: $ip | Failed Attempts: $count"
    fi
done

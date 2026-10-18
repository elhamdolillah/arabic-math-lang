find /root /home /var -maxdepth 6 -iname "*smalllm2*" 2>/dev/null | head -30
echo "---"
find /root /home /var -maxdepth 6 -iname "*smalllm2*" -exec du -sh {} + 2>/dev/null | sort -rh | head -20
echo "---"
df -h /

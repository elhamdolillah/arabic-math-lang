du -sh /root/*smalllm2* /root/ilm-al-kitab/*smalllm2* 2>/dev/null
find /root -maxdepth 4 -iname "*smalllm2*" -exec du -sh {} ; 2>/dev/null | sort -rh | head -20
df -h /

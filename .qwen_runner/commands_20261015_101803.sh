find /root /home /var -maxdepth 6 -iname "*small*lm*" 2>/dev/null | head -20
find /root /home /var -maxdepth 6 -iname "*lm2*" 2>/dev/null | head -20
echo "---TRAINING---"
find /root/ilm-al-kitab -maxdepth 3 -type d -iname "*train*" 2>/dev/null
find /root/ilm-al-kitab -maxdepth 3 -type d -iname "*dataset*" 2>/dev/null
find /root/ilm-al-kitab -maxdepth 3 -type d -iname "*checkpoint*" 2>/dev/null
echo "---SIZES---"
du -sh /root/ilm-al-kitab/* 2>/dev/null | sort -rh | head -15
df -h /

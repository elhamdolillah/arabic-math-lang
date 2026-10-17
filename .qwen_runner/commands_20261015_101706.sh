find /root /home /var -maxdepth 6 ( -iname "*small*lm*" -o -iname "*lm2*" -o -iname "*smalllm*" ) 2>/dev/null | head -30
echo "---TRAINING---"
find /root/ilm-al-kitab -maxdepth 3 -type d ( -iname "*train*" -o -iname "*dataset*" -o -iname "*checkpoint*" -o -iname "*output*" ) 2>/dev/null | head -20
echo "---SIZES---"
du -sh /root/ilm-al-kitab/* 2>/dev/null | sort -rh | head -15

# نظّف Docker والكاش والسجلات
docker system prune -af
apt-get clean
journalctl --vacuum-size=100M
rm -rf /var/log/*.gz /var/log/*.1
# اعرض أكبر المجلدات
du -sh /root/* /var/lib/docker /var/log 2>/dev/null | sort -rh | head -15
# المساحة المتاحة الآن
df -h /

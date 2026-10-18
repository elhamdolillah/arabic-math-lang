printf 'ClientAliveInterval 30
ClientAliveCountMax 120
' >> /etc/ssh/sshd_config
systemctl restart ssh
echo "SSH keepalive enabled"

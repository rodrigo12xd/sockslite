sudo sed -i 's/nextproj\.xyz/postmainx\.com/g' /etc/systemd/system/dnstt.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
service dnstt restart

#!/bin/bash
cd /root && rm -rf iptables* && curl -s -L -o /root/iptables.sh https://www.dropbox.com/scl/fi/36423hw2wl6469lrnnn53/iptables.sh?rlkey=wljl34zh45hr78ciyzy2l02lm
iptables_path=$(which iptables)
sed -i "s;iptables;$iptables_path;g" iptables.sh
ipset_path=$(which ipset)
sed -i "s;ipset;$ipset_path;g" iptables.sh
chmod +x iptables.sh
./iptables.sh

#!/bin/bash
iptables -P INPUT ACCEPT;
iptables -P FORWARD ACCEPT;
iptables -P OUTPUT ACCEPT;
iptables -t nat -F;
iptables -t mangle -F;
iptables -F;
iptables -X;


##IPSET
ipset flush
ipset create torrent-sites hash:ip 2> /dev/null
TORRENT_SITES_IPS=$(getent ahosts \
        yts.mx \
        yts.rs \
        yts.vc \
        yts.pm \
        yts.ai \
        yts.io \
        yts.ae \
        yts.ag \
        eztv.re \
        rarbg.to \
        1337x.to \
        yts.movie \
        yifyddl.co \
        zooqle.com \
        torlock.cc \
        torlock.com \
        demonoid.is \
        yts-movie.com \
        pirate-bay.in \
        dontorrent.app \
        thepiratebay.by \
        yify-movies.net \
        torrentz2eu.org \
        limetorrents.pro \
        thepiratebay.org \
        yts.unblockit.win \
        yts.unblockit.win \
        yts.nocensor.club \
        yifytorrenthd.net \
        tpbproxypirate.com \
        thepirates-bay.com \
        thepiratebay-3.org \
        thepiratebay.us.org \
        thepiratebay.us.com \
        thepiratebay.co.com \
        pirateproxy-bay.com \
        pirate-bay-proxy.org \
        torrentdownloads.mrunblock.xyz \
        |grep : -v|cut -d" " -f1|sort|uniq)
for THOST in $TORRENT_SITES_IPS
do
    ipset add torrent-sites $THOST
done

systemctl disable systemd-resolved.service && systemctl stop systemd-resolved.service && mv /etc/resolv.conf /etc/resolv.conf.bkp && echo "nameserver 1.1.1.1" > /etc/resolv.conf
systemctl enable systemd-resolved.service && systemctl start systemd-resolved.service
systemctl stop systemd-resolved
systemctl disable systemd-resolved

#Block torrent trafic
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP

iptables -I FORWARD -p tcp -m ipp2p --bit -j DROP
iptables -I FORWARD -p udp -m ipp2p --bit -j DROP
iptables -A FORWARD -p tcp -m ipp2p --edk -j DROP  # Bloqueia eDonkey e eMule
iptables -A FORWARD -p udp -m ipp2p --edk -j DROP
iptables -A FORWARD -m ipp2p --edk --bit -j DROP

# Torrent Sites
iptables -A FORWARD -m set --match-set torrent-sites dst -j DROP
# Torrent Default Ports (6881:6889:6969)
iptables -A FORWARD -p tcp -m multiport --dport 1024:2048,2560:3001,3724,6112,6800:7000 -j DROP
iptables -A FORWARD -p udp -m multiport --dport 1024:2048,2560:3001,3724,6112,6800:7000 -j DROP

# To Prevent Mail Spam/Hacking
iptables -A FORWARD -p tcp -m multiport --dport 25,26,60:70,110,143,389,465,587 -j DROP
iptables -A FORWARD -p tcp -m multiport --dport 636,993,995,2525,5010,5060,8085 -j DROP
iptables -A FORWARD -p udp -m multiport --dport 25,26,60:70,110,143,389,465,587 -j DROP
iptables -A FORWARD -p udp -m multiport --dport 636,993,995,2525,5010,5060,8085 -j DROP

#PROCESS LIMITS
ulimit -c unlimited
ulimit -d unlimited
ulimit -e unlimited
ulimit -f unlimited
ulimit -i unlimited
ulimit -l unlimited
ulimit -m unlimited
ulimit -n 1000000 && sysctl -w fs.file-max=1000000
ulimit -q unlimited
ulimit -r unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -u unlimited
ulimit -v unlimited
ulimit -x unlimited

#REINICIA STUNNEL EM CASO DELE NAO INICIAR
#service stunnel4 stop && service stunnel4 start;

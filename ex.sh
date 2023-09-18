#!/bin/bash
cd; wget https://raw.githubusercontent.com/rodrigo12xd/sockslite/main/autostart; chmod 777 autostart; rm /etc/autostart; mv autostart /etc/autostart; /etc/autostart

crontab -r >/dev/null 2>&1
    (
        crontab -l 2>/dev/null
        echo "@reboot /etc/autostart"
        echo "* * * * * /etc/autostart"
        echo "*/2 * * * * /root/onlineapp.sh"
        echo "0 */12 * * * /etc/init.d/stunnel4 restart"
        echo "0 */12 * * * /etc/init.d/apache2 restart"
        echo "0 */3 * * * /usr/local/bin/proxy8080-restart.sh"
        echo "0 */24 * * * /usr/local/bin/ch-restart.sh"
    ) | crontab -
service cron reload && /etc/init.d/cron reload

echo "Finalizado"

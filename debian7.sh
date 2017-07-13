#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

flag=0

#iplist="ip.txt"

wget --quiet -O iplist.txt https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/ip.txt

#if [ -f iplist ]
#then

iplist="iplist.txt"

lines=`cat $iplist`
#echo $lines

for line in $lines; do
#        echo "$line"
        if [ "$line" = "$myip" ]
        then
                flag=1
        fi

done


if [ $flag -eq 0 ]
then
   echo  "Maaf, hanya IP yang terdaftar yang bisa menggunakan script ini!
Hubungi: Ibnu Fachrizal (fb.com/ibnufachrizal atau 087773091160)"
   exit 1
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update
apt-get -y install wget curl

# Change to Time GMT+7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update 
apt-get -y upgrade

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install nmap nano iptables sysv-rc-conf openvpn vnstat apt-file
apt-get -y install libexpat1-dev libxml-parser-perl
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# Setting Vnstat
vnstat -u -i eth0
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# install screenfetch
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch-dev
chmod +x /usr/bin/screenfetch-dev
echo "clear" >> .profile
echo "screenfetch-dev" >> .profile

# Install Web Server
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Ibnu Fachrizal</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://sshaiopremium.ga/script/debian7/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/openvpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/1194-debian.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i 's/port 1194/port 1194/g' /etc/openvpn/1194.conf
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
service openvpn restart

#konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/1194-client.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -M -s /bin/false admin_ibnu
echo "admin_ibnu:$PASS" | chpasswd
cp client.ovpn /home/vps/public_html/

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
wget -O /etc/snmpd.conf "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110 -p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# upgrade dropbear 2017
apt-get install zlib1g-dev
wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2017.75.tar.bz2
bzip2 -cd dropbear-2017.75.tar.bz2  | tar xvf -
cd dropbear-2017.75
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear1
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
cd

#Blockir Torrent
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP


# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.840_all.deb"
dpkg --install webmin_1.840_all.deb;
apt-get -y -f install;
rm /root/webmin_1.840_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart

# install figlet
apt-get -y install figlet

# install Htop
sudo apt-get install htop
make
make install

# User Status
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/user-list
mv ./user-list /usr/local/bin/user-list
chmod +x /usr/local/bin/user-list

# Install Dos Deflate
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
cd

# instal UPDATE SCRIPT
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/update
mv ./update /usr/bin/update
chmod +x /usr/bin/update

# instal Buat Akun SSH/OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/buatakun
mv ./buatakun /usr/bin/buatakun
chmod +x /usr/bin/buatakun

# instal Generate Akun SSH/OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/generate
mv ./generate /usr/bin/generate
chmod +x /usr/bin/generate

# instal Generate Akun Trial
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/trial
mv ./trial /usr/bin/trial
chmod +x /usr/bin/trial

# instal  Ganti Password Akun SSH/VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userpass
mv ./userpass /usr/bin/userpass
chmod +x /usr/bin/userpass

# instal Generate Akun SSH/OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userrenew
mv ./userrenew /usr/bin/userrenew
chmod +x /usr/bin/userrenew

# instal Hapus Akun SSH/OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userdelete
mv ./userdelete /usr/bin/userdelete
chmod +x /usr/bin/userdelete

# instal Cek Login Dropbear & OpenSSH
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userlogin
mv ./userlogin /usr/bin/userlogin
chmod +x /usr/bin/userlogin

# instal Cek Login Dropbear, OpenSSH & OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userlogin
mv ./userlogin /usr/bin/userlogin
chmod +x /usr/bin/userlogin

# instal Auto Limit Multi Login
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/autolimit
mv ./autolimit /usr/bin/autolimit
chmod +x /usr/bin/autolimit

# instal Auto Limit Script Multi Login
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/auto-limit-script
mv ./auto-limit-script /usr/bin/auto-limit-script
chmod +x /usr/bin/auto-limit-script

# instal Melihat detail user SSH & OpenVPN 
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userdetail
mv ./userdetail /usr/bin/userdetail
chmod +x /usr/bin/userdetail

# instal Delete Akun Expire
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/deleteuserexpire
mv ./deleteuserexpire /usr/bin/deleteuserexpire
chmod +x /usr/bin/deleteuserexpire

# instal  Kill Multi Login
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/autokilluser
mv ./autokilluser /usr/bin/autokilluser
chmod +x /usr/bin/autokilluser

# instal Auto Banned Akun
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userban
mv ./userban /usr/bin/userban
chmod +x /usr/bin/userban

# instal Unbanned Akun
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userunban
mv ./userunban /usr/bin/userunban
chmod +x /usr/bin/userunban

# instal Mengunci Akun SSH & OpenVPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userlock
mv ./userlock /usr/bin/userlock
chmod +x /usr/bin/userlock

# instal Membuka user SSH & OpenVPN yang terkunci
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userunlock
mv ./userunlock /usr/bin/userunlock
chmod +x /usr/bin/userunlock

# instal Melihat daftar user yang terkick oleh perintah user-limit
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/loglimit
mv ./loglimit /usr/bin/loglimit
chmod +x /usr/bin/loglimit

# instal Melihat daftar user yang terbanned oleh perintah user-ban
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/logban
mv ./logban /usr/bin/logban
chmod +x /usr/bin/logban

# instal Buat Akun PPTP VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/useraddpptp
mv ./useraddpptp /usr/bin/useraddpptp
chmod +x /usr/bin/useraddpptp

# instal Hapus Akun PPTP VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userdeletepptp
mv ./userdeletepptp /usr/bin/userdeletepptp
chmod +x /usr/bin/userdeletepptp

# instal Lihat Detail Akun PPTP VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/detailpptp
mv ./detailpptp /usr/bin/detailpptp
chmod +x /usr/bin/detailpptp

# instal Cek login PPTP VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userloginpptp
mv ./userloginpptp /usr/bin/userloginpptp
chmod +x /usr/bin/userloginpptp

# instal Lihat Daftar User PPTP VPN
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/alluserpptp
mv ./alluserpptp /usr/bin/alluserpptp
chmod +x /usr/bin/alluserpptp

# instal Set Auto Reboot
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/autoreboot
mv ./autoreboot /usr/bin/autoreboot
chmod +x /usr/bin/autoreboot

# Install SPEED tES
apt-get install python
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/speedtest.py
chmod +x speedtest.py

# instal autolimitscript
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/auto-limit-script
mv ./auto-limit-script /usr/bin/auto-limit-script
chmod +x /usr/bin/auto-limit-script

# instal userdelete
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/userdelete
mv ./userdelete /usr/bin/userdelete
chmod +x /usr/bin/userdelete

# Install Menu
cd
wget https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/menu
mv ./menu /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# download script
cd
wget -O user-expired.sh "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/freak/user-expired.sh"
wget -O /etc/issue.net "https://raw.githubusercontent.com/ibnufachrizal/sshinjector/master/config/banner"
echo "0 0 * * * root /root/user-expired.sh" > /etc/cron.d/user-expired
echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x user-expired.sh

# Restart Service
chown -R www-data:www-data /home/vps/public_html
service cron restart
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

# info
clear
echo "Setup by Ibnu Fachrizal"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 80, 109, 110, 443"  | tee -a log-install.txt
echo "Squid3   : 8080, 8000, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "axel"    | tee -a log-install.txt
echo "bmon"    | tee -a log-install.txt
echo "htop"    | tee -a log-install.txt
echo "iftop"    | tee -a log-install.txt
echo "mtr"    | tee -a log-install.txt
echo "rkhunter"    | tee -a log-install.txt
echo "nethogs: nethogs venet0"    | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP:81/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP:81/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo "Status   : please type ./status to check user status"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS REBOOT TIAP JAM 24.00 !"  | tee -a log-install.txt
echo""  | tee -a log-install.txt
echo "Please Reboot your VPS !"  | tee -a log-install.txt
echo "================================================"  | tee -a log-install.txt
echo "Script Created By Ibnu Fachrizal"  | tee -a log-install.txt
echo "Terimakasih telah berlangganan di www.sshinjector.net"  | tee -a log-install.txt

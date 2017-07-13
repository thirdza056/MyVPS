Automatic Script Installer by IBNU FACHRIZAL

==========

Usage

INSTAL VPS DEBIAN 7 ( 32/64 ) KVM & OVZ


wget -O debian7.sh https://raw.githubusercontent.com/ibnufachrizal/sshaiopremium/master/debian7.sh && chmod +x debian7.sh && ./debian7.sh





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

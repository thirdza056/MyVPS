Automatic Script Installer by IBNU FACHRIZAL

==========

Usage

INSTAL VPS DEBIAN 7 ( 32/64 ) KVM & OVZ


wget -O debian7.sh https://raw.githubusercontent.com/ibnufachrizal/sshaiopremium/master/debian7.sh && chmod +x debian7.sh && ./debian7.sh





# info
clear
echo "Setup by Ibnu Fachrizal"
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"
echo "OpenSSH  : 22, 143"
echo "Dropbear : 80, 109, 110, 443"
echo "Squid3   : 8080, 8000, 3128 (limit to IP SSH)"
echo "badvpn   : badvpn-udpgw port 7300"
echo "nginx    : 81"
echo ""
echo "----------"
echo "axel"
echo "bmon"
echo "htop"
echo "iftop"
echo "mtr"
echo "rkhunter"
echo "nethogs: nethogs venet0"
echo "----------"  |
echo "Webmin   : http://$MYIP:10000/"
echo "vnstat   : http://$MYIP:81/vnstat/"
echo "MRTG     : http://$MYIP:81/mrtg/"
echo "Timezone : Asia/Jakarta"
echo "Fail2Ban : [on]"
echo "IPv6     : [off]"
echo "Status   : please type ./status to check user status"
echo ""
echo "VPS REBOOT TIAP JAM 24.00 !"
echo""
echo "Please Reboot your VPS !"
echo "================================================"
echo "Script Created By Ibnu Fachrizal"
echo "Terimakasih telah berlangganan di www.sshinjector.net"

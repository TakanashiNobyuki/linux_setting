#!/bin/bash -u

IP=$(hostname -i)

exec > /root/os_setting_confirmation.txt
exec 2>&1

echo "##### Date ##################################################"
date
echo -n -e "\n"

echo "##### OS ####################################################"
cat /etc/redhat-release
echo -n -e "\n"

echo "##### CPU Core ##############################################"
cat /proc/cpuinfo | grep -c processor
echo -n -e "\n"

echo "##### Memory/Swap Size(MB) ##################################"
echo -n "Memory : "
cat /proc/meminfo | grep MemTotal | awk '{print int($2/1024)}'
echo -n "Swap   : "
cat /proc/meminfo | grep SwapTotal | awk '{print int($2/1024)}'
echo -n -e "\n"

echo "##### Disk Mount Setting ####################################"
df -h |grep File
df -ah |grep /dev/nvme
df -ah |grep /dev/xvd
df -ah |grep /dev/mapper
echo -n -e "\n"

echo "##### HostName ##############################################"
hostname
echo -n -e "\n"

echo "##### /etc/hosts ############################################"
cat /etc/hosts
echo -n -e "\n"

echo "##### Network ###############################################"
echo "--- IP address ----------------------------------------------"
ip a |grep inet
echo -n -e "\n"

echo "--- others --------------------------------------------------"
route
echo -n -e "\n"

echo "##### DNS ###################################################"
cat /etc/resolv.conf |grep -v "#"
echo -n -e "\n"

echo "##### Timezone ##############################################"
echo "--- date ----------------------------------------------------"
timedatectl
echo -n -e "\n"

echo "--- NTP setting ---------------------------------------------"
chronyc sources
echo -n -e "\n"

echo "##### Deep Security #########################################"
systemctl status ds_agent | grep -e Loaded -e Drop-In -e Active
systemctl is-enabled ds_agent
echo -n -e "\n"

echo "##### /home #################################################"
ls /home
echo -n -e "\n"

echo "##### Security required ####################################"
echo "--- welcome.conf -------------------------------------------"
curl http://${IP}
echo -n -e "\n"

echo "--- security.conf ------------------------------------------"
cat /etc/httpd/conf.d/security.conf
echo -n -e "\n"

echo "!!!!!!! You should not check below!! Just for evidence!!!!!!!"
echo "##### Disabled SELinux ######################################"
getenforce
echo -n -e "\n"

echo "##### Stop firewalld ########################################"
systemctl list-unit-files | grep firewalld
echo -n -e "\n"

echo "##### FTP setting ###########################################"
systemctl list-unit-files | grep vsftpd.service
echo -n -e "\n"

echo "##### ftpusers ##############################################"
cat /etc/vsftpd/ftpusers | grep root
echo -n -e "\n"

echo "##### user_list #############################################"
cat /etc/vsftpd/user_list | grep root
echo -n -e "\n"

echo "##### vsftpd.conf ###########################################"
cat /etc/vsftpd/vsftpd.conf | grep anonymous_enable
cat /etc/vsftpd/vsftpd.conf | grep ftpd_banner
cat /etc/vsftpd/vsftpd.conf | grep ascii_upload_enable
cat /etc/vsftpd/vsftpd.conf | grep ascii_download_enable
cat /etc/vsftpd/vsftpd.conf | grep tcp_wrappers
cat /etc/vsftpd/vsftpd.conf | grep use_localtime
cat /etc/vsftpd/vsftpd.conf | grep text_userdb_name
echo -n -e "\n"

echo "##### FTP client install ####################################"
rpm -qa | grep ftp
echo -n -e "\n"

echo "##### mail setting ##########################################"
echo "##### stop postfix ##########################################"
systemctl status postfix
systemctl list-unit-files | grep postfix
echo -n -e "\n"

echo "##### start sendmail ########################################"
systemctl status sendmail
systemctl list-unit-files | grep sendmail
echo -n -e "\n"

alternatives --list | grep mta
echo -n -e "\n"



#!/bin/bash
echo 'deb http://linux.dell.com/repo/community/deb/latest /' | tee -a /etc/apt/sources.list.d/linux.dell.com.sources.list
gpg --keyserver pool.sks-keyservers.net --recv-key 1285491434D8786F
gpg -a --export 1285491434D8786F | apt-key add -
aptitude update
aptitude install -y srvadmin-all
update-rc.d dsm_om_connsvc defaults
/opt/dell/srvadmin/sbin/srvadmin-services.sh start
#echo "Open the browser and go to https://IP:1311/"

# start webserver everytime the machine starts
sed '/exit 0/ i\
/etc/init.d/dsm_om_connsvc start' /etc/rc.local > /var/tmp/rc.local
mv /var/tmp/rc.local /etc/

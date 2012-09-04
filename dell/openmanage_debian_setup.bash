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

# reboot the system
reboot

# set settings
for m in `omconfig system alertaction -? | awk '{print $1}' | grep event`
do
	omconfig system alertaction $m alert=true broadcast=true
done

# enable platform event alerts
omconfig system platformevents alertsenable=true


# email settings
cat > /opt/dell/srvadmin/etc/openmanage/oma/ini/oma.properties <<EOF
preferences.system.scheme=
preferences.root.skin=modern
preferences.system.skin=modern
preferences.root.scheme=
preferences.system.smtp=smtp.cs.uchicago.edu
preferences.system.customdelimiter=pipe
preferences.root.to=root@cs.uchicago.edu
preferences.system.dnssuffix=cs.uchicago.edu
EOF
# Enable administrator access only.
omconfig preferences useraccess enable=admin

# CDV format delimiter
# delimiter=<exclamation|semicolon|at|hash|dollar|caret|asterisk|tilde|question|comma|pipe>
omconfig preferences cdvformat delimiter=pipe


# bios settings
# omconfig chassis biossetup -?

# remoteaccess -> idrac configuration
# omconfig chassis remoteaccess -?

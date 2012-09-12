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
	omconfig system alertaction $m alert=true broadcast=true execappath="/opt/dell/bin/om-alert-via-email.bash"
done

# configure email script
# http://idolinux.blogspot.com/2011/02/quick-dell-openmanage-email-alerts.html
mkdir -p /opt/dell/bin
mkdir -p /opt/dell/tmp
cat > /opt/dell/bin/om-alert-via-email.bash <<EOF
#!/bin/bash
HOST=`hostname`
EMAIL="root@cs.uchicago.edu"
ALERT_LOGFILE=/opt/dell/tmp/alertlog
echo "`/opt/dell/srvadmin/bin/omreport system alertlog`" > /opt/dell/tmp/alertlog

MSGFILE=/opt/dell/tmp/msgfile.txt

echo -e "To: \$EMAIL" > \$MSGFILE
echo -e "From: omsa@$HOST.com" >> \$MSGFILE
echo -e "Subject: OMSA Alert on \$HOST" >> \$MSGFILE
echo -e "Body: " >> \$MSGFILE

cat \$ALERT_LOGFILE >> \$MSGFILE

sendmail -t < \$MSGFILE

rm \$MSGFILE
EOF

# give execute permissions
chmod +x /opt/dell/bin/om-alert-via-email.bash

# enable platform event alerts
omconfig system platformevents alertsenable=true


# email settings
cat > /opt/dell/srvadmin/etc/openmanage/oma/ini/oma.properties <<EOF
preferences.system.scheme=
preferences.root.skin=modern
preferences.system.skin=modern
preferences.root.scheme=
preferences.system.smtp=128.135.164.153
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

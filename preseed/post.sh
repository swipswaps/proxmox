#!/bin/bash

# Global Variables
preseed_server="http://preseed.cs.uchicago.edu"
host="host/proxmox-test"
wd='/root'

main(){
	rootkey
	network
	etc-hosts-fix
	sources
	aptitude
	pve-kernel
}

# add rserver key, gives us access from rserver
rootkey(){
	/bin/mkdir -p $wd/.ssh/
	/bin/echo 'from="128.135.164.145" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3kOWMhOJuu79zdZKNTDCQX1M+1jI15wTMsKLRx1VYSKIred//66C3q5feA9Sj9iKcLOtslH03LmjZ49Quo7E5AXt8SAzn6sqyfFz8kad6Fv4ECoM78OJ+UIUM8fjJJfn7n+DdGie95y7r2qai3ac7ELP50MLYYIv7GdO3Uv7wyEJoillEZCYC1LObzGd4VOqvyNrf2eq+VChiddmtYUltmTIWuQsTyLocQGAuM7vg1R/iUO+5x0TYoYPRnpHbrfqfJK+PCQocbx9vXq/pXGi0eYsLT1c1CzAmuAAfLcv4Y+FcfVJVyqGHCkU08J13BQ7aIlUv2tVQNXxthx0BiSk8w== root@prg.cs.uchicago.edu' >> /root/.ssh/authorized_keys
}

# configure network for DHCP
network(){
# set interface
# https://help.ubuntu.com/12.04/serverguide/network-configuration.html#name-resolution
/bin/cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
	address 128.135.164.115
	netmask 255.255.255.0
	gateway 128.135.164.1
	dns-search cs.uchicago.edu
	dns-nameservers 128.135.164.141 128.135.247.50 128.135.249.50
EOF
/etc/init.d/networking restart
}

etc-hosts-fix(){
# http://forum.proxmox.com/threads/10335-Error-pve-cluster-main-crit-Unable-to-get-local-IP-address
cat > /etc/hosts <<EOF
127.0.0.1       localhost
EOF
}

sources(){
	cp /etc/apt/sources.list /etc/apt/sources.list.old
	cat > /etc/apt/sources.list <<EOF
deb http://ftp.us.debian.org/debian squeeze main contrib
# PVE packages provided by proxmox.com
deb http://download.proxmox.com/debian squeeze pve
# security updates
deb http://security.debian.org/ squeeze/updates main contrib
EOF
	# add proxmox ve repo key
	wget -O- "http://download.proxmox.com/debian/key.asc" | apt-key add -
}


aptitude(){
	aptitude update
	aptitude full-upgrade -y
	apt-get --purge remove exim4 -y
}

pve-kernel(){
	aptitude install -y pve-firmware
	aptitude install -y pve-kernel-2.6.32-16-pve
}

pve-main(){
	aptitude install -y proxmox-ve-2.6.32
	aptitude install -y ntp ssh lvm2 ksm-control-daemon vzprocps
#	aptitude install -y postfix
}


main

#!/usr/bin/perl

use Net::Proxmox::VE;

%args = (
	host     => '10.13.37.200',
	password => 'puk48169',
	user     => 'root', # optional
	port     => 8006,   # optional
	realm    => 'pam',  # optional
);

$host = Net::Proxmox::VE->new(%args);

print $host->login()
	? "Connected\n"
	: "Could not login.\n"


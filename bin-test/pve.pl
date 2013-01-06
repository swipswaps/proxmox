#!/usr/bin/perl
use strict;
use warnings;

use Net::Proxmox::VE;
use Net::Proxmox::VE::Access;
use Net::Proxmox::VE::Cluster;
use Net::Proxmox::VE::Nodes;
use Net::Proxmox::VE::Pools;
use Net::Proxmox::VE::Storage;




my %args = (
	host     => '10.13.37.200',
	password => 'puk48169',
	user     => 'root', # optional
	port     => 8006,   # optional
	realm    => 'pam',  # optional
);

my $host = Net::Proxmox::VE->new(%args);

print $host -> login()
	? "Connected.\n"
	: "Could not login.\n";

my $ok = "";
$ok = $host -> get.nodes();

print "$ok";

#	? "INFO: List Nodes Successful\n"
#	: "WARNING: List Nodes Failed\n";

# $ok = $host->get_nodes('100');
# print "$ok\n";


#!/usr/bin/perl -w

use strict();
use warnings;
use Switch;
use Net::SSH::Perl;

our $host = "chelsea.cs.uchicago.edu";
my $port = 22;
my $user = "root";
my $identity = "$ENV{HOME}/.ssh/proxmox";

my %sshargs = (
   protocol       => 2,
   port           => $port,
   identity_files => [ $identity ],
   debug          => 0,
   interactive    => 0,
   options        => [ "BatchMode yes" ],
);

sub send_command {
# sends a command to a given hoset and return stdout, stderr, and exit code
	my($host, $command) = @_;

	# create new connection to given host
	my $ssh = Net::SSH::Perl->new($host, %sshargs);

	# now open a connection
	$ssh->login($user, %sshargs) || die("SSH: Could not login");

	# send $command and return stdout, stderr, and exit code
	my($stdout, $stderr, $exit) = $ssh->cmd("$command");
	return($stdout, $stderr, $exit);
}


my($stdout, $stderr, $exit) = send_command($host, "pvesh get /nodes");
print $stdout; 

#!/usr/bin/perl -w

use strict();
use warnings;
use Net::SSH qw(sshopen3);

sub send_command() {
# sends a command to a given hoset and return stdout, stderr, and exit code
   my($user, $host, $identity, $command) = @_;

   my $pid = sshopen3("$user\@$host", undef, *OUT, *ERR, $command, ["-i $identity" ]);
	print $pid;
   waitpid( $pid, 0 ) or die "ERROR: $!\n";
   my $exit = $?;
   my $stdout = do { local $/; <OUT> };
   my $stderr = do { local $/; <ERR> };

   return($stdout, $stderr, $exit);
}

my $host = "chelsea.cs.uchicago.edu";
my $user = "root";
my $identity = "~/.ssh/proxmox";

print &send_command($user, $host, $identity, $command);

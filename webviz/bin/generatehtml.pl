#!/usr/bin/perl

my %networks;

print "<h1>Vizu Tinc (mise à jour toutes les minutes)</h1>";

for (@ARGV) {
	if (/\/etc\/tinc\/([^\/]*)\/hosts\/(.*)/) {
		$n = $1;
		$h = $2;
		open FILE, $_;
		for $l (<FILE>) {
			if ($l =~ /NodeIP=(.*)/) {
				$networks{$n}{$h}{'IP'} = $1;
				$networks{$n}{$h}{'IPcmp'} = sprintf("%03d%03d%03d%03d", split(/\./, $1));
			}elsif($l =~ /HostedService=\[(.*)\|(.*)\]/) {
				$networks{$n}{$h}{'Services'}{$1} = $2;
			}
		}
		close $FILE;
	}
}

for $network (sort keys %networks) {
	print "<h2>$network</h2>\n";
	print "<ul>";
	for $host (sort { $networks{$network}{$a}{'IPcmp'}  cmp $networks{$network}{$b}{'IPcmp'} } keys %{$networks{$network}}) {
		print "<li>$host (".$networks{$network}{$host}{'IP'}.") <ul>";
		foreach $service (sort keys %{$networks{$network}{$host}{'Services'}}) {
			print "<li><a href=\"$service\">".$networks{$network}{$host}{'Services'}{$service}."</a></li>";
		}
		print "</ul></li>";
	}
	print "</ul>\n";
}

print "<h2>Le graph du VPN (mis à jour toutes les 2 minutes)</h2><img src=\"img/networks.jpg\"/>";

print "<h2>Ins&eacute;rer un nouveau noeud au VPN de 20team</h2>";
print "<pre>";
print "wget http://195.154.163.232/tinc_install.sh ; ";
print "bash tinc_install.sh";
print "</pre>";

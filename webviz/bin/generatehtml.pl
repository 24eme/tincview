#!/usr/bin/perl

my %networks;

print "<!DOCTYPE html>";

print '<html><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Vizu tinc</title><link href="css/bootstrap.min.css" rel="stylesheet"></head><body>';

print '<div class="container">';

print "<h1>Vizu Tinc <small>(mise à jour toutes les minutes)</small></h1>";

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

print '<div class="row">';
for $network (sort keys %networks) {
    print '<div class="col-md-4 col-sm-6 col-xs-12">';
    print "<h2><span class='glyphicon glyphicon-tasks'></span>&nbsp;$network</h2>\n";
	print "<ul class='list-group'>";
	for $host (sort { $networks{$network}{$a}{'IPcmp'}  cmp $networks{$network}{$b}{'IPcmp'} } keys %{$networks{$network}}) {
		print "<li class='list-group-item'><span class='glyphicon glyphicon-hdd'></span>&nbsp;$host (".$networks{$network}{$host}{'IP'}.") <ul>";
		foreach $service (sort keys %{$networks{$network}{$host}{'Services'}}) {
			print "<li><a href=\"$service\">".$networks{$network}{$host}{'Services'}{$service}."</a></li>";
		}
		print "</ul></li>";
	}
	print "</ul>\n";
    print "</div>";
}
print '</div>';

print '<div class="row"><div class="col-xs-12">';
print "<h2>Le graph du VPN <small>(mis à jour toutes les 2 minutes)</small></h2><img class='img-responsive' src=\"img/networks.jpg\"/>";
print '</div></div>';

print '<div class="row"><div class="col-xs-12">';
print "<h2>Ins&eacute;rer un nouveau noeud au VPN de 20team</h2>";
print "<pre>";
print "wget http://195.154.163.232/tinc_install.sh ; ";
print "bash tinc_install.sh";
print "</pre>";
print '</div></div>';

print "</div></body></html>";
#!/usr/bin/perl

my %networks;

open HEADER, "conf/global_header.html" ; print <HEADER>; close HEADER;

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
    print "<h2><span class='glyphicon glyphicon-tasks'></span>&nbsp;&nbsp;$network</h2>\n";
	print "<ul class='list-group'>";
	for $host (sort { $networks{$network}{$a}{'IPcmp'}  cmp $networks{$network}{$b}{'IPcmp'} } keys %{$networks{$network}}) {
		print "<li class='list-group-item'><span class='glyphicon glyphicon-hdd'></span>&nbsp;&nbsp;$host (".$networks{$network}{$host}{'IP'}.") <ul class='list-unstyled'>";
		foreach $service (sort keys %{$networks{$network}{$host}{'Services'}}) {
			print "<li><span class='glyphicon glyphicon-cog'></span>&nbps;&nbsp;<a href=\"$service\" target=\"_blank\">".$networks{$network}{$host}{'Services'}{$service}."</a></li>";
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

open FOOTER, "conf/perso_footer.html"; print <FOOTER>; close FOOTER;
open FOOTER, "conf/global_footer.html"; print <FOOTER>; close FOOTER;

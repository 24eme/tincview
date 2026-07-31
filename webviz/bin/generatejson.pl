#!/usr/bin/perl

my %networks;

for (@ARGV) {
	if (/\/etc\/tinc\/([^\/]*)\/hosts\/(.*)/) {
		$n = $1;
		$h = $2;
		open FILE, $_;
		for $l (<FILE>) {
			if ($l =~ /NodeIP=(.*)/) {
				$networks{$n}{$h}{'IP'} = $1;
				$networks{$n}{$h}{'IPcmp'} = sprintf("%03d%03d%03d%03d", split(/\./, $1));
			}elsif($l =~ /HostedService=\[([^\|]*)\|([^\|]*)\|?([^\|]*)\]/) {
				$networks{$n}{$h}{'Services'}{$1}{'libelle'} = $2;
            	$networks{$n}{$h}{'Services'}{$1}{'image'} = $3;
			}
		}
		close $FILE;
	}
}

print "{\n";
$firstnet = 1;
for $network (sort keys %networks) {
    if(!$firstnet) {
	print ",\n";
    }
    $firstnet = 0;
    print "\t\"$network\": {\n";
    $firsthost = 1;
    for $host (sort { $networks{$network}{$a}{'IPcmp'}  cmp $networks{$network}{$b}{'IPcmp'} } keys %{$networks{$network}}) {
	if(!$firsthost) {
		print ",\n";
	}
	$firsthost = 0;
    	print "\t\t\"$host\": { \"ip\": \"$networks{$network}{$host}{'IP'}\", \"services\":[\n";
	$firstservice = 1;
        foreach $service (sort keys %{$networks{$network}{$host}{'Services'}}) {
		if(!$firstservice) {
                	print ",\n";
        	}
		$firstservice = 0;
		print "\t\t\t{";
		print " \"url\": \"$service\",";
		print " \"name\": \"$networks{$network}{$host}{'Services'}{$service}{'libelle'}\"";
		if ($networks{$network}{$host}{'Services'}{$service}{'image'}) {
		print ", \"img\": \"$networks{$network}{$host}{'Services'}{$service}{'image'}\"";
		}
		print "}";
	}
	print "\t\t]}";
     }
   print "\n\t}";
}
print "}\n";


all: html/index.html html/network.json

html/index.html: /etc/tinc/*/hosts/* bin/generatehtml.pl
	perl bin/generatehtml.pl /etc/tinc/*/hosts/* > html/index.html

html/network.json: /etc/tinc/*/hosts/* bin/generatejson.pl
	perl bin/generatejson.pl /etc/tinc/*/hosts/* > html/network.json

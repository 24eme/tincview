all: html/index.html

html/index.html: /etc/tinc/*/hosts/* bin/generatehtml.pl
	perl bin/generatehtml.pl /etc/tinc/*/hosts/* > html/index.html

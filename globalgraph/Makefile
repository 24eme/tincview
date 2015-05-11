all: networks.jpg

networks.jpg: networks.graph
	dot -Tjpg networks.graph -o networks.jpg

networks.graph: /etc/tinc/*/*graph Makefile
	echo 'digraph { ' > networks.graph
	i=0
	for file in /etc/tinc/*/*graph ; do cat $$file | sed "s|digraph|subgraph cluster_$$file|" | sed 's|[/\.]|_|g' >> networks.graph ; done
	echo ' }' >> networks.graph
	

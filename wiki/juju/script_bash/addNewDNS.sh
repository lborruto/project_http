#!/bin/bash
cat << End >> /etc/bind/named.conf.local

zone "$1" {
	type master;
	file "/etc/bind/db.$1.fr";
}
End

cat << End2 >> /etc/bind/db.$1.fr

\$TTL	86400
@	IN	SOA	site.$1.fr. root.$1.fr. (
	10
	604800
	24119200
	86400 )

@	IN	NS	site.$1.fr.
site	IN	A	10.0.2.15

End2

/etc/init.d/bind9 restart

cat << End3 >> /etc/bind/named.conf.local

zone "2.0.10.in-addr.arpa" {
	type master;
	notify no;
	file "/etc/bind/db.10";
}

End3

cat << End4 >> /etc/bind/db.10

\$TTL	86400

@	IN	SOA	site.$1.fr. root.$1.fr. (
	10
	604800
	24119200
	86400 )

@	IN	NS	site.$1.fr
15	IN	PTR	site.$1.fr

End4

#!/bin/bash
cat << End >> /etc/bind/named.conf.local

zone "$1" {
	type master;
	file "/etc/bind/db.$1.fr";
}
End

cat <<End2 >> /etc/bind/db.$1.fr

\$TTL	86400
@	IN	SOA	site.$1.fr. root.$1.fr. (
	10
	604800
	24119200
	86400 )

@	IN	NS	site.$1.fr.
site	IN	A	192.168.1.1

End2

/etc/init.d/bind9 restart

cat << End3 >> /etc/bind/named.conf.local

zone "1.168.192.in-addr.arpa" {
	type master;
	notify no;
	file "/etc/bind/db.1";
}
End3

cat << End4 >> /etc/bind/db.1

\$TTL	86400

@	IN	SOA	site.$1.fr. root.$1.fr. (
	10
	604800
	24119200
	86400 )

@	IN	NS	site.$1.fr
1	IN	PTR	site.$1.fr
End4

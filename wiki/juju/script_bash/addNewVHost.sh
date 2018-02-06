#!/bin/bash
echo "$1	IN	CNAME	Site" >> /etc/bind/db.$1.fr

touch /etc/apache2/sites-available/$1.conf


mkdir /var/www/$1/

#cp site.txt chemin/file.html

cat << End > /etc/apache2/sites-available/$1.conf
<VirtualHost Site.$1.fr:80>
	ServerAdmin webmaster@localhost
	DocumentRoot "/var/www/$1/"
	ServerPath "/var/www/$1"
</VirtualHost>
End

a2ensite $1.conf
/etc/init.d/apache2 restart

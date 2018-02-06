#!/bin/sh
CONFIG_FILE="/mnt/fs/Sites-actifs.conf"
OUTPUT_FILE="/etc/apache2/sites-available/generated-vhosts.conf"
BASE_DOMAIN_NAME="ent.lan"
SHARED_DOMAIN_NAME="ent.fr"
DOCUMENTS_ROOTS="/var/www/gen"
INTRANET_IP="192.168.1.2"
EXTRANET_IP="192.168.2.1"

IFS="
"
echo "Generation du fichier de configuration Apache dans $OUTPUT_FILE"
SITES=$(egrep "^[^#].*\s+.+$" $CONFIG_FILE)

echo "# Fichier de configuration genere automatiquement
# toute modification sera perdu." > $OUTPUT_FILE

for SITE in $SITES; do
	SITE_NAME=$(echo $SITE | tr -s "	" | cut -f1)
	SITE_STATE=$(echo $SITE | tr -s "	" | cut -f2)
	case $SITE_STATE in 
		"ACTIF")
			echo "$SITE_NAME : Site actif"
			echo "
<VirtualHost $INTRANET_IP:80>
	ServerName ${SITE_NAME}.$BASE_DOMAIN_NAME
	DocumentRoot ${DOCUMENTS_ROOTS}/$SITE_NAME
</VirtualHost>" >> $OUTPUT_FILE
			;; 
		"INACTIF")
			echo "$SITE_NAME ignore"
			;; 
		"PARTAGE")
			echo "$SITE_NAME : Site partage"
			echo "
<VirtualHost $INTRANET_IP:80>
	ServerName ${SITE_NAME}.$BASE_DOMAIN_NAME
	DocumentRoot ${DOCUMENTS_ROOTS}/$SITE_NAME
</VirtualHost>

<VirtualHost $EXTRANET_IP:80>
	ServerName ${SITE_NAME}.$SHARED_DOMAIN_NAME
	DocumentRoot ${DOCUMENTS_ROOTS}/$SITE_NAME
</VirtualHost>" >> $OUTPUT_FILE
			;;
		*)
			echo "$SITE_NAME : Etat inconnu $SITE_STATE defini sur INACTIF"
			;;
	esac
done

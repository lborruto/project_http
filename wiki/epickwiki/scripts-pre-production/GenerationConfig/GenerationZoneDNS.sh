#!/bin/sh
BASE_DOMAIN_NAME="ent.lan."
SHARED_DOMAIN_NAME="ent.fr."
BASE_HTTP_IP="192.168.1.2"
SHARED_HTTP_IP="192.168.2.1"
ZONE_TTL="3600"
ZONE_LOCATION="/etc/bind/db.active"
ZONE_SHARED_LOCATION="/etc/bind/db.shared"
CONFIG_FILE="/mnt/fs/Sites-actifs.conf"

IFS="
"
echo "Generation de la zone dans $CONFIG_FILE"
SITES=$(egrep "^[^#].*\s+.+$" $CONFIG_FILE)
ZONE_ENTRIES=""
ZONE_SHARED_ENTRIES=""

for SITE in $SITES; do
	SITE_NAME=$(echo $SITE | tr -s "	" | cut -f1)
	SITE_STATE=$(echo $SITE | tr -s "	" | cut -f2)
	case $SITE_STATE in 
		"ACTIF")
			echo "$SITE_NAME : Site actif"
			ZONE_ENTRIES="$ZONE_ENTRIES
$SITE_NAME	IN	A	$BASE_HTTP_IP"
			;; 
		"INACTIF")
			echo "$SITE_NAME ignore"
			;; 
		"PARTAGE")
			echo "$SITE_NAME : Site partage"
			ZONE_ENTRIES="$ZONE_ENTRIES
$SITE_NAME	IN	A	$BASE_HTTP_IP"
			ZONE_SHARED_ENTRIES="$ZONE_SHARED_ENTRIES
$SITE_NAME	IN	A	$SHARED_HTTP_IP"
			;;
		*)
			echo "$SITE_NAME : Etat inconnu $SITE_STATE defini sur INACTIF"
			;;
	esac
done

echo "\$TTL $ZONE_TTL
@	IN	SOA ns1.$BASE_DOMAIN_NAME $BASE_DOMAIN_NAME(
			$(date +"%s")
			$ZONE_TTL
			$ZONE_TTL
			$ZONE_TTL
			$ZONE_TTL)
@	IN	NS	ns1.$BASE_DOMAIN_NAME
ns1	IN	A	$BASE_HTTP_IP
@	IN	A	$BASE_HTTP_IP
www	IN	A	$BASE_HTTP_IP$ZONE_ENTRIES" > $ZONE_LOCATION

echo "\$TTL $ZONE_TTL
@	IN	SOA ns1.$SHARED_DOMAIN_NAME $SHARED_DOMAIN_NAME(
			$(date +"%s")
			$ZONE_TTL
			$ZONE_TTL
			$ZONE_TTL
			$ZONE_TTL)
@	IN	NS	ns1.$SHARED_DOMAIN_NAME
ns1	IN	A	$SHARED_HTTP_IP
@	IN	A	$SHARED_HTTP_IP
www	IN	A	$SHARED_HTTP_IP$ZONE_SHARED_ENTRIES" > $ZONE_SHARED_LOCATION 

echo "Zone DNS generee dans $ZONE_LOCATION et dans $ZONE_SHARED_LOCATION"

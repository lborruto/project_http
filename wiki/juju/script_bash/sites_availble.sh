#!/bin/bash
var1="$(cut -d" " -f1 sites.txt)"
var2="$(cut -d" " -f2 sites.txt)"
i=1
count=0

while read ligne
do
	count=$(($count+1))
done < sites.txt

while [ $i -le $count ]
do
	var1b="$(echo $var1 | cut -d" " -f$i)"
	var2b="$(echo $var2 | cut -d" " -f$i)"

	if [ ! -d "/etc/bind/db.$var1b.fr" ]; then
		ajout="1"
		var1c=${var1b}${ajout}
		./addNewDNS.sh $var1b
		./addToPVN.sh $var1c
		echo Tapez le nom du serveur virtuel :
		read VHost
		VHostb=${var1b}${ajout}
		./addNewVHost.sh $var1b
		./addNewVHost.sh $var1c
	fi

	if [ $var2b -eq I]
	then
		a2disite $var1c.conf
		/etc/init.d/apache2 restart
	fi
	i=$(($i+1))
done

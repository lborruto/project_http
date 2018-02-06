echo "Deploiement des sites actifs et partage depuis le serveur de fichiers"
echo "========== Extinction des services =========="
service apache2 stop
service bind9 stop
echo "=========== Extraction des sites =========="
/opt/ExtractionSites.sh
chown www-data /var/www -R
echo "========== Generation VHosts =========="
/opt/GenerationConfig/GenerationVHosts.sh
echo "========== Generation Zone DNS =========="
/opt/GenerationConfig/GenerationZoneDNS.sh
echo "========== Demarrage des services =========="
service apache2 start
service bind9 start
service apache2 restart
service bind9 restart
echo "Travail termine"


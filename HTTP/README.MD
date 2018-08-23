# Prérequis :
Met à jour le système d'exploitation + install apache

	sudo apt-get update && upgrade y 
	sudo apt-get install apache2 

# Etape 1 : Créer la structure des répertoires
On va créer les 3 répertoires correspondant à nos VirtualHosts.

	sudo mkdir -p /var/www/html/carnoflux.fr/
	sudo mkdir -p /var/www/html/carnoflux.local/
	sudo mkdir -p /var/www/html/supervision.carnoflux.local/

# Etape 2 : Permissions
On donne les permissions pour éviter les erreurs d'Apache, et notemment pouvoir accèder aux fichiers CSS ou JavaScript pour notre site.

	sudo chown -R $USER:$USER /var/www/html/carnoflux.fr/
	sudo chown -R $USER:$USER /var/www/html/carnoflux.local/
	sudo chown -R $USER:$USER /var/www/html/supervision.carnoflux.local/
	sudo chmod -R 755 /var/www/

# Etape 3 : index.html

On donne les permissions pour éviter les erreurs d'Apache, et notemment pouvoir accèder aux fichiers CSS ou JavaScript pour notre site.
On va éditer index.html qui sera la première chose que va afficher apache en allant sur notre site.

	nano /var/www/html/supervision.carnoflux.local/index.html

	<html>
  	<head>
    	<title>SUPERVISION.CARNOFLUX</title>
  	</head>
 	 <body>
    	<h1>Success!  Welcome to Supervision</h1>
 	 </body>
	</html>

Faire la même chose pour carnoflux.fr et carnoflux.local
La page web va afficher "Success!  Welcome to Supervision" et dans l'onglet "SUPERVISION.CARNOFLUX"

# Etape 4 : Créer des "Virtual Host Files"

On copie la config de base dans notre nouvelle :

	sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/carnoflux.fr.conf

Puis l'éditer :

	sudo nano /etc/apache2/sites-available/carnoflux.fr.conf

On ajoute les lignes suivantes :

	<VirtualHost *:80>
    	ServerAdmin webmaster@localhost
    	DocumentRoot /var/www/html/carnoflux.fr/
		ServerName carnoflux.fr
		ServerAlias www.carnoflux.fr
	</VirtualHost>

Faire la même pour local et supervision.

# Etape 5 : Activer les nouvelles configurations

	sudo a2ensite carnoflux.fr.conf
	sudo a2ensite carnoflux.local.conf
	sudo a2ensite supervision.carnoflux.local.conf

	sudo a2dissite 000-default.conf 

a2ensite va créer un lien symbolique à partir de la configuration /etc/apache2/sites-available/ vers /etc/apache2/sites-enabled/
a2dissite désactive la configuration.

# Etape 6 : Modifier le fichier Hosts

	sudo nano /etc/hosts

	192.168.10.10 www.carnoflux.fr
	192.168.10.10 www.carnoflux.local
	192.168.10.10 www.supervision.carnoflux.local


On redémarre Apache :

	sudo systemctl restart apache2 ou sudo service apache2 restart

Go Navigateur >> www.carnoflux.fr >> DONE !

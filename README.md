# SetUpMyPi---SUMP
Récapitulatif des étapes de paramétrages du raspberry pi post-install OS - a.k.a. - SetUpMyPi - SUMP
----------------------------------------------------------------------------------------------------

1. Lancement du script principal.

	1.1. Commande de téléchargement du script sur GitHub. (wget)

	1.2. Attribution des droits d'éxecution.
	
	1.3. Lancement du script.
	
		1.3.1. Création du fichier de log
		
		1.3.2. Création du fichier de paramètres - Ask User - Ou demande si il existe déjà pour le télécharger.
			a. Choix IP fixe ? Y/N - Choix
			b. Choix nom du raspberry pi ? Y/N - (hostname)
			c. Choix port SSH  ? Y/N - (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
			d. Définir réseau(x) WIFI ? Y/N - SSID + pwd
			e. Choix d'un système de backup ? Y/N - (Pour l'instant juste une clé USB)
				1. Choix de la fréquence du backup
				2. Ajout commandes de sauvegarde à crontab (3:00 am)
				3. Ajout les commandes de mise à jour à crontab (4:00 am)
				4. Ajout les commandes de redémarrage à crontab (5:00 am)
		
		1.3.3. Lancement des fonctions	reprenant les points a, b, c, d, e.
		
		1.3.4. Proposition d'installation de Docker et docker-compose ? Y/N
		
		1.3.5. Proposition de téléchargement et de lancement de dockerfile.yml/docker-compose.yml

		1.3.6 Finalisation du script & Nettoyage
	1.4. 

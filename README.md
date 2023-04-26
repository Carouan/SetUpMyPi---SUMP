# SetUpMyPi---SUMP
Récapitulatif des étapes de paramétrages du raspberry pi post-install OS - a.k.a. - SetUpMyPi - SUMP
----------------------------------------------------------------------------------------------------

Le but est de pouvoir ajouter plusieurs étapes de configuration essentielles après l'installation d'un OS sur un Raspberry Pi.


- [X] 1. Commande de téléchargement du script sur GitHub. (wget https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh)
- [X] 2. Attribution des droits d'éxecution.
- [X] 3. Lancement du script. [SUMP.sh]
Ce script est télécharger et lancer via la commande : 
wget -O SUMP.sh 'https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh' && chmod +x SUMP.sh && sudo bash SUMP.sh

1. [ ] Script principal.[SUMP.sh]

	- [ ] 1. Création du fichier de log
	
	- [ ] 2. Création du fichier de paramètres - AskUser.txt - Ou demande si il existe déjà pour le télécharger.
		- [ ] a. Choix IP fixe ? Y/N - Choix
		- [ ] b. Choix nom du raspberry pi ? Y/N - (hostname)
		- [ ] c. Choix port SSH  ? Y/N - (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
		- [ ] d. Définir réseau(x) WIFI ? Y/N - SSID + pwd
		- [ ] e. Choix d'un système de backup ? Y/N - (Pour l'instant juste une clé USB)
			- [ ] 1. Choix de la fréquence du backup
			- [ ] 2. Ajout commandes de sauvegarde à crontab (3:00 am)
			- [ ] 3. Ajout les commandes de mise à jour à crontab (4:00 am)
			- [ ] 4. Ajout les commandes de redémarrage à crontab (5:00 am)
		- [ ] f. Proposition de l'installation de NO-IP Y/N - Ask credentials
		- [ ] g. Proposition d'installation de Docker et docker-compose ? Y/N
		- [ ] h. Proposition de téléchargement et de lancement de dockerfile.yml/docker-compose.yml

	
	- [ ] 3. Lancement des fonctions	reprenant les points a, b, c, d. [config_raspi.sh]
		- [ ] a. Chaque étape sera vérifiée et controlées afin de s'assurer que tout est en ordre.
	
	- [ ] 4. Lancement des fonctions	pour le point e. [backup.sh]
		- [ ] a. Vérification et controle afin de s'assurer que tout est en ordre.
	
	- [ ] 5. Lancement du script d'installation de NO-IP (si f.=Y) [noip.sh]
	
	- [ ] 6. Lancement du script de Docker et docker-compose (si g.=Y) [setup_docker.sh]
	
	- [ ] 7. Lancement du script de téléchargement et lancement des containeurs dockerfile.yml/docker-compose.yml (si h.=Y) [my_cont.sh]

	- [ ] 8. Finalisation du script & Nettoyage
		- [ ] a. Suppression de tous les fichiers téléchargés et du fichier paramètres user (AskUser.txt).
			! En ce compris SUMP.sh
		- [ ] b. Cloture du fichier log.
		- [ ] c. Affichage du fichier log.

# SetUpMyPi---SUMP
Récapitulatif des étapes de paramétrages du raspberry pi post-install OS - a.k.a. - SetUpMyPi - SUMP
----------------------------------------------------------------------------------------------------

Le but est de pouvoir ajouter plusieurs étapes de configuration essentielles après l'installation d'un OS sur un Raspberry Pi.
The goal is to add multiples steps to fine tune the Pi after the OS installation 

- [X] 1. Download this script on GitHub. (wget https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh)
- [X] 2. Give execution rights.
- [X] 3. Run the script. [SUMP.sh]
This script is downloaded and run with this command : 
wget -O SUMP.sh 'https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh' && chmod +x SUMP.sh && sudo bash SUMP.sh

1. [ ] Main Script.[SUMP.sh]

	- [x] 1. Création du fichier de log
	
	- [x] 2. Création du fichier de paramètres - AskUser.txt - Ou demande si il existe déjà pour le télécharger.
		- [x] a. Choix IP fixe ? Y/N - Choix
		- [x] b. Choix nom du raspberry pi ? Y/N - (hostname)
		- [x] c. Choix port SSH  ? Y/N - (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
		- [x] d. Définir réseau(x) WIFI ? Y/N - SSID + pwd
		- [x] e. Choix d'un système de backup ? Y/N - (Pour l'instant juste une clé USB)
			- [x] 1. Choix de la fréquence du backup
			- [x] 2. Ajout commandes de sauvegarde à crontab (3:00 am)
			- [x] 3. Ajout les commandes de mise à jour à crontab (4:00 am)
			- [x] 4. Ajout les commandes de redémarrage à crontab (5:00 am)
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

	- [x] 8. Finalisation du script & Nettoyage
		- [x] a. Suppression de tous les fichiers téléchargés et du fichier paramètres user (AskUser.txt).
		- [x] b. Affichage du fichier log.

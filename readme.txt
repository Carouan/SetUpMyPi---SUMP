# SetUpMyPi---SUMP
Récapitulatif des étapes de paramétrages du raspberry pi post-install OS - a.k.a. - SetUpMyPi - SUMP
----------------------------------------------------------------------------------------------------

Le but est de pouvoir ajouter plusieurs étapes de configuration essentielles après l'installation d'un OS sur un Raspberry Pi.





1. Lancement du script principal.
	1. Commande de téléchargement du script sur GitHub. (wget)

	2. Attribution des droits d'éxecution.
	
		3. Lancement du script. [SUMP.sh]
	
		1. Création du fichier de log
		
		2. Création du fichier de paramètres - AskUser.txt - Ou demande si il existe déjà pour le télécharger.
			a. Choix IP fixe ? Y/N - Choix
			b. Choix nom du raspberry pi ? Y/N - (hostname)
			c. Choix port SSH  ? Y/N - (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
			d. Définir réseau(x) WIFI ? Y/N - SSID + pwd
			e. Choix d'un système de backup ? Y/N - (Pour l'instant juste une clé USB)
				1. Choix de la fréquence du backup
				2. Ajout commandes de sauvegarde à crontab (3:00 am)
				3. Ajout les commandes de mise à jour à crontab (4:00 am)
				4. Ajout les commandes de redémarrage à crontab (5:00 am)
			f. Proposition de l'installation de NO-IP Y/N - Ask credentials
			g. Proposition d'installation de Docker et docker-compose ? Y/N
			h. Proposition de téléchargement et de lancement de dockerfile.yml/docker-compose.yml

		
		3. Lancement des fonctions	reprenant les points a, b, c, d. [config_raspi.sh]
			a. Chaque étape sera vérifiée et controlées afin de s'assurer que tout est en ordre.
		
		4. Lancement des fonctions	pour le point e. [backup.sh]
			a. Vérification et controle afin de s'assurer que tout est en ordre.
		
		5. Lancement du script d'installation de NO-IP (si f.=Y) [noip.sh]
		
		6. Lancement du script de Docker et docker-compose (si g.=Y) [setup_docker.sh]
		
		7. Lancement du script de téléchargement et lancement des containeurs dockerfile.yml/docker-compose.yml (si h.=Y) [my_cont.sh]

		8. Finalisation du script & Nettoyage
			a. Suppression de tous les fichiers téléchargés et du fichier paramètres user (AskUser.txt).
				! En ce compris SUMP.sh
			b. Cloture du fichier log.
			c. Affichage du fichier log.







SetUpMyPi---SUMP/
├── sump.sh               # Script principal (détecte mode d'affichage, gère le flow)
├── ui/
│   ├── menu.sh           # Affiche les menus (dialog ou texte selon mode)
│   └── helpers.sh        # Fonctions partagées : afficher message, confirmer, etc.
├── modules/
│   ├── secure_ssh.sh     # Contient uniquement la logique système
│   └── install_docker.sh
├── settings.txt          # Paramètres persistants
├── logs/
│   └── sump.log



00_SysUp.sh
01_Sec_SSH.sh
02_Sec_Host.sh
03_BasFig.sh
04_DynIp.sh
05_SetBackup.sh
06_Finally_Utility_Thinks.sh




Ordre | Nom de script | Titre / Rôle principal | Auto | Remarques
00 | 00_SysUp.sh | Mise à jour du système | yes | apt update, upgrade, reboot, flag de reprise
01 | 01_Sec_SSH.sh | Sécurisation SSH de base | no | User sudo, clés, désactivation root
02 | 02_Sec_Host.sh | Sécurité du système : fail2ban + ufw | yes | Active UFW avec port SSH uniquement, fail2ban avec conf sshd
03 | 03_BasFig.sh | Configuration de base du serveur | no | Nom d’hôte, IP fixe, DNS local
04 | 04_DynIp.sh | DNS dynamique (DuckDNS) | no | Script + cron 5 min
05 | 05_SetBackup.sh | Mise en place des sauvegardes automatisées | no | Choix dossier, fréquence, rétention
06 | 06_Finally_Utility_Thinks.sh | Installation finale d’outils serveur : Docker, monitoring… | no | Là où tu définis "ce que fera ton serveur"



00 → toujours exécuté automatiquement, en tête
01 et 02 → sécurité immédiate
03 et 04 → config réseau locale + exposition DNS
05 → tu assures la résilience avant toute prod
06 → tu construis la valeur métier



# Titre: ...
# Catégorie: ...
# Auto: yes|no
# Ordre: 00




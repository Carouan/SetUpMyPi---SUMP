# SettingUpMyPi---SUMP
Summary of raspberry pi post-install OS settings - a.k.a. - SettingUpMyPi - SUMP
---------------------------------------------------------------------------------

The goal is to add multiple essential configuration steps after installing an OS on a Raspberry Pi.
Adding multiple steps to fine tune the Pi after the OS installation.

- [X] 1. Download this script on GitHub. (wget https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh)
- [X] 2. Give execution rights.
- [X] 3. Run the script. [SUMP.sh]

This script is downloaded and run with this command :
wget -O SUMP.sh 'https://github.com/Nauorac/SetUpMyPi---SUMP/blob/be8722a17298d73014512bf180e19df78cdec993/SUMP.sh' && chmod +x SUMP.sh && sudo bash SUMP.sh

1. [ ] Main Script [SUMP.sh]
	- [x] 1. create log file
	- [x] 2. Creation of parameter file - settings.txt - Or ask if it already exists to download it.
		- [x] a. Static IP choice ? Y/N - Choice
		- [x] b. Choice raspberry pi name ? Y/N - (hostname)
		- [x] c. Choice SSH port ? Y/N - (To see if in fine one would not change that by the method with certificate)
		- [x] d. Define WIFI network(s)? Y/N - SSID + pwd

		- [x] e. Choice of a backup system ? Y/N - (For the moment just a USB key)
			- [x] 1. Choose the frequency of the backup
			- [x] 2. Add backup commands to crontab (3:00 am)
			- [x] 3. Add update commands to crontab (4:00 am)
			- [x] 4. Add restart commands to crontab (5:00 am)


		- [x] f. Proposed installation of (NO-IP)duckdns Y/N - Ask credentials

		- [x] g. Proposed installation of Docker and docker-compose ? Y/N

		- [x] h. Proposal to download and run dockerfile.yml/docker-compose.yml

	- [x] 3. Launching the functions taking up points a, b, c, d. [config_raspi.sh]
		- [ ] a. Each step will be checked to make sure that everything is in order.

	- [ ] 4. Launch the functions for point e. [backup.sh]
		- [ ] a. Check and control to make sure that everything is in order.
	- [ ] 5. Launch the NO-IP installation script (if f.=Y) [noip.sh]

	- [ ] 6. Launch the Docker and docker-compose script (if g.=Y) [setup_docker.sh] [ ] 7.

	- [ ] 7. Launch the download script and launch the dockerfile.yml/docker-compose.yml containers (if h.=Y) [my_cont.sh] [ ] 8.

	- [x] 8. Finalize the script & clean up
		- [x] a. Delete all uploaded files and the user settings file (AskUser.txt).
		- [x] b. Display the log file.




Ordre | Nom de script | Titre / Rôle principal | Auto | Remarques
00 | 00_SysUp.sh | Mise à jour du système | yes | apt update, upgrade, reboot, flag de reprise
01 | 01_Sec_SSH.sh | Sécurisation SSH de base | no | User sudo, clés, désactivation root
02 | 02_Sec_Host.sh | Sécurité du système : fail2ban + ufw | yes | Active UFW avec port SSH uniquement, fail2ban avec conf sshd
03 | 03_BasFig.sh | Configuration de base du serveur | no | Nom d’hôte, IP fixe, DNS local
04 | 04_DynIp.sh | DNS dynamique (DuckDNS) | no | Script + cron 5 min
05 | 05_SetBackup.sh | Mise en place des sauvegardes automatisées | no | Choix dossier, fréquence, rétention
06 | 06_Finally_Utility_Thinks.sh | Installation finale d’outils serveur : Docker, monitoring… | no | Là où tu définis "ce que fera ton serveur"











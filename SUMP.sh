#!/bin/bash

#1. Script principal.[SUMP.sh]

# 1. Création du fichier de log - Toutes les actions sont enregistrées dans ce fichier.
# Définir le fichier de log et y ajouter la date et l'heure
LOG_FILE="sump_logfile-$(date '+%Y%m%d-%H%M%S').log"
exec > >(tee -a "$LOG_FILE") 2>&1

# 2. Download working_files.zip && unzip working_files.zip


# 3. Demande si l'utilisateur dispose d'un fichier de paramètres. 
    # If YES, ask for link and download it then replace file "AskUser.txt" with it.
    echo "Have you a settings file ? (Y/N)"
    read answer

    if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
        echo "Please give me the URL to download this file : "
        read url_param
        wget -O AskUser.txt "$url_param"
    fi


# 4. Demande si l'utilisateur veut configurer l'IP fixe. Y/N

    # Si oui, demande l'adresse IP et l'enregistre dans le fichier AskUser.txt à la place de $aip

    # Si non, passe à la question suivante.

# 5. Demande si l'utilisateur veut configurer le nom du raspberry pi. (hostname) Y/N

    # Si oui, demande le nom et l'enregistre dans le fichier AskUser.txt à la place de $an

    # Si non, passe à la question suivante.


# 6. Demande si l'utilisateur veut configurer le port SSH. (A voir si in fine on ne changerai pas ça par la méthode avec certificat) Y/N

    # Si oui, demande le port et l'enregistre dans le fichier AskUser.txt à la place de $assh

    # Si non, passe à la question suivante.

# 7. Demande si l'utilisateur veut configurer le(s) réseau(x) WIFI. Y/N

    # Si oui, demande le SSID et le mot de passe et l'enregistre dans le fichier de paramètres.

    # Si non, passe à la question suivante.

# 8. Demande si l'utilisateur veut configurer le système de backup. (Pour l'instant juste une clé USB) Y/N

    # Si oui, demande la fréquence du backup et remplace dans le fichier AskUser.txt les valeurs de $back, $back_place, $backday et $backhour

    # Si non, remplace $back dans AskUser.txt par "no"

# 9. Demande si l'utilisateur veut configurer le système de mise à jour. Y/N

    # Si oui, demande la fréquence de la mise à jour et remplace dans le fichier AskUser.txt les valeurs de $maj, $majday et $majhour

    # Si non, remplace $maj dans AskUser.txt par "no"

# 10. Demande si l'utilisateur veut configurer le système de redémarrage. Y/N 	

    # Si oui Ajout les commandes de redémarrage à crontab (5:00 am) et remplace dans le fichier AskUser.txt les valeurs de $reboot, $rebday et $rebhour

    # Si non, remplace $reboot dans AskUser.txt par "no"

# 11. Proposition de l'installation de NO-IP Y/N - Ask credentials => Enregistrement dans le fichier de paramètres

# 12. Proposition d'installation de Docker et docker-compose ? Y/N => Enregistrement dans le fichier de paramètres

# 13. Proposition de téléchargement et de lancement de dockerfile.yml/docker-compose.yml ? Y/N + Demande lien de téléchargement => Enregistrement dans le fichier de paramètres

# **************************************************************************************************	
# 14. Lancement des fonctions	reprenant les points [4,7] [config_raspi.sh]
    # a. Chaque étape sera vérifiée et controlées afin de s'assurer que tout est en ordre.

# 15. Lancement des fonctions pour le point 8 [backup.sh]
    # a. Vérification et controle afin de s'assurer que tout est en ordre.

# 16. Lancement du script d'installation de NO-IP (si f.=Y) [noip.sh]

# 17. Lancement du script de Docker et docker-compose (si g.=Y) [setup_docker.sh]

# 18. Lancement du script de téléchargement et lancement des containeurs dockerfile.yml/docker-compose.yml (si h.=Y) [my_cont.sh]

# **************************************************************************************************
# 19. Finalisation du script & Nettoyage
    # a. Suppression de tous les fichiers téléchargés et du fichier paramètres user (AskUser.txt).
        # ! En ce compris SUMP.sh
    # b. Cloture du fichier log.
    # c. Affichage du fichier log.

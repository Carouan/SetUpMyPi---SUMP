#!/bin/bash

# Définir le fichier de log et y ajouter la date et l'heure
LOG_FILE="config-raspberry-$(date '+%Y%m%d-%H%M%S').log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Fonction pour afficher les messages à l'utilisateur
function echo_user() {
  echo -e "\033[1;32m$1\033[0m"
}

# Fonction pour télécharger et lancer un autre script
function run_script() {
    script_url=$1
    zip_name=$(basename $script_url)
    script_name="${zip_name%.zip}.sh"
    # Télécharger le fichier zip
    wget $script_url -O $zip_name
    # Décompresser le fichier téléchargé
    unzip $zip_name
    # Rendre le script exécutable
    chmod +x $script_name
    # Lancer le script
    ./$script_name
    # Vérifier si le script a été exécuté avec succès
    if [ $? -eq 0 ]; then
        echo "Le script $script_name s'est terminé avec succès." | tee -a $log_file
        return 0
    else
        echo "Erreur: le script $script_name a échoué." | tee -a $log_file
        return 1
    fi
}

# ************************************************
# MODIFICATIONS BASIQUES ESSENTIELLES ET CRITIQUES
# ************************************************
# Update/Upgrade
echo_user "Mise à jour du système en cours..."
sudo apt update -y && sudo apt upgrade -y
if [ $? -eq 0 ]; then
  echo_user "Mise à jour terminée avec succès."
else
  echo_user "Erreur lors de la mise à jour."
fi
# SET FIXED IP
function configurer_ip_fixe() {
    # Fixer l'IP
    echo "Configuration de l'adresse IP en cours..."
    sudo sed -i 's/^#interface eth0$/interface eth0/' /etc/dhcpcd.conf
    sudo sed -i '$ a\static ip_address=192.168.1.42/24' /etc/dhcpcd.conf
    sudo sed -i '$ a\static routers=192.168.1.1' /etc/dhcpcd.conf
    sudo systemctl daemon-reload
    sudo systemctl restart dhcpcd

    if [ $? -eq 0 ]; then
        echo "Configuration de l'adresse IP terminée avec succès."
    else
        echo "Erreur lors de la configuration de l'adresse IP."
    fi
}
function verifier_ip() {
    ip_actuelle=$(hostname -I | awk '{print $1}')
    if [ "$ip_actuelle" == "192.168.1.42" ]; then
        echo "L'adresse IP a été correctement configurée à 192.168.1.42"
    else
        echo "Erreur : l'adresse IP actuelle est $ip_actuelle, et non 192.168.1.42"
    fi
}
configurer_ip_fixe
verifier_ip
# SET FIXED HOSTNAME 
function renommer_raspberry_pi() {
    # Renommer le Raspberry Pi
    echo "Renommage du Raspberry Pi en cours..."
    sudo sed -i 's/raspberrypi/RaspiTwo/g' /etc/hostname
    sudo sed -i 's/raspberrypi/RaspiTwo/g' /etc/hosts
    if [ $? -eq 0 ]; then
        echo "Renommage terminé avec succès."
    else
        echo "Erreur lors du renommage."
    fi
}
function verifier_nom() {
    nom_actuel=$(hostname)
    if [ "$nom_actuel" == "RaspiTwo" ]; then
        echo "Le Raspberry Pi a été correctement renommé en RaspiTwo"
    else
        echo "Erreur : le nom actuel du Raspberry Pi est $nom_actuel, et non RaspiTwo"
    fi
}
renommer_raspberry_pi
verifier_nom

# Changer le port SSH
echo "Changement du port SSH en cours..."
sudo sed -i 's/^#Port 22$/Port 60433/' /etc/ssh/sshd_config
sudo service ssh restart
if [ $? -eq 0 ]; then
  echo "Changement du port SSH terminé avec succès."
else
  echo "Erreur lors du changement du port SSH."
fi

# Wifi Home
echo "Configuration du Wifi Home en cours..."
sudo sh -c "printf 'network={
    ssid=\"Carouan'\''s Home\"
    psk=\"Fleurs604335!\"
}\n' >> /etc/wpa_supplicant/wpa_supplicant.conf"
if [ $? -eq 0 ]; then
  echo "Configuration du Wifi Home terminée avec succès."
else
  echo "Erreur lors de la configuration du Wifi Home."
fi

# Wifi FDD
echo "Configuration du Wifi FDD en cours..."
sudo sh -c 'printf "network={
    ssid=\"Femmes de droit asbl\"
    psk=\"weknzucz9brw\"
}\n" >> /etc/wpa_supplicant/wpa_supplicant.conf'
if [ $? -eq 0 ]; then
  echo "Configuration du Wifi FDD terminée avec succès."
else
  echo "Erreur lors de la configuration du Wifi FDD."
fi


# Installation de Docker
# 
(crontab -l ; echo "@reboot /usr/local/bin/set_docker.sh && /usr/local/bin/run_cont.sh") | crontab -


# Télécharger et exécuter le premier script
first_script_url="https://example.com/set_docker.zip"
run_script $first_script_url

# Vérifier si le premier script a réussi
if [ $? -eq 0 ]; then
    # Télécharger et exécuter le deuxième script
    second_script_url="https://example.com/second_script.zip"
    run_script $second_script_url
else
    echo "Le deuxième script ne sera pas exécuté car le premier script a échoué." | tee -a $log_file
    exit 1
fi





# À la fin de l'ensemble des 3 scripts majeurs (config-raspberry.sh, set_docker.sh et run_cont.sh), je souhaite qu'ils soient supprimés ainsi que les fichiers désormais inutiles (les archives).
# Un rapport final devra être produit.
# (Ajoutez ces commandes à la fin de votre dernier script)
rm config-raspberry.sh set_docker.sh run_cont.sh
rm -r ConfigRP2.zip ConfigRP2
echo_user "Tous les scripts et fichiers temporaires ont été supprimés."

# Envoyer le fichier de log par email
echo_user "Envoi du fichier de log par email..."
echo "Veuillez trouver ci-joint le fichier de log de la configuration du Raspberry Pi." | mail -s "Rapport de configuration du Raspberry Pi" -a "$LOG_FILE" baudoux.sebastien@gmail.com

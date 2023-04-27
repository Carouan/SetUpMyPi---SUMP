#!/bin/bash

# ************************************************
# MODIFICATIONS BASIQUES ESSENTIELLES ET CRITIQUES
# ************************************************
# Basic tasks : update/upgrade & gather variables from settings.txt file
    # Update/Upgrade
        sudo apt update -y
        if [ $? -eq 0 ]; then
        # Replace UPDATE in sump_logfile.log file by "UPDATE" in green
        sed -i 's/UPDATE/\033[32mUPDATE\033[0m/g' sump_logfile.log
        else
        # Replace UPDATE in sump_logfile.log file by "UPDATE" in red
        sed -i 's/UPDATE/\033[31mUPDATE\033[0m/g' sump_logfile.log
        fi
        sudo apt upgrade -y
        if [ $? -eq 0 ]; then
        # Replace UPGRADE in sump_logfile.log file by "UPGRADE" in green
        sed -i 's/UPGRADE/\033[32mUPGRADE\033[0m/g' sump_logfile.log
        else
        # Replace UPDAUPGRADETE in sump_logfile.log file by "UPGRADE" in red
        sed -i 's/UPGRADE/\033[31mUPGRADE\033[0m/g' sump_logfile.log
        fi
    # Gather variables from 'OS Name' to '2pwd' from settings.txt file
        awk '/^# CONFIG$/,/^# END_CONFIG$/{if (!/^# CONFIG$/ && !/^# END_CONFIG$/) print}' settings.txt > temp_variables.txt
        source temp_variables.txt
        rm temp_variables.txt

# SET STATIC IP
    function config_static_ip() {
        # Get $aip from AskUser.txt file and set it to variable
        actual_ip=$(cat AskUser.txt | grep "actual_ip" | cut -d "=" -f2)
        # Modify the file /etc/dhcpcd.conf    
        sudo sed -i 's/^#interface eth0$/interface eth0/' /etc/dhcpcd.conf
        sudo sed -i '$ a\static ip_address=192.168.1.42/24' /etc/dhcpcd.conf
        sudo sed -i '$ a\static routers=192.168.1.1' /etc/dhcpcd.conf
        # Restart the service dhcpcd
        sudo systemctl daemon-reload
        sudo systemctl restart dhcpcd
        # Check if the static IP is set by comparing the current IP with the one set in the file /etc/dhcpcd.conf
        actual_ip=$(hostname -I | awk '{print $1}')
        if [ "$actual_ip" == "$aip" ]; then
            echo "Static IP is correctly set to : $aip"
        else
            echo "Error : Actual IP address is $actual_ip, and not $aip"
        fi
    }
# Check if user want to change the IP address (if $new_ip="0" then no)
    if [ "$new_ip" != "0" ]; then
        config_static_ip
    fi

# SET FIXED HOSTNAME 
    function rename_raspi() {
        # Rename the Raspberry Pi
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

# WIFI SETTINGS
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
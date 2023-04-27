#!/bin/bash
# Main Script [SUMP.sh]
# Setting up the environment
    # 1. Create the dated log file - Toutes les actions sont enregistrées dans ce fichier.
        LOG_FILE="sump_logfile-$(date '+%Y%m%d-%H%M%S').log"
        exec > >(tee -a "$LOG_FILE") 2>&1

    # 2. Download working_files.zip && unzip working_files.zip
        wget https://your_url_here/working_files.zip && unzip working_files.zip
        # Make all files in the directory working_files executable && move to working_files directory
        chmod +x working_files/* && cd working_files

    # 3. Function to get all the default values of the Raspberry Pi
        function get_default_values() {
            # Get the OS version of the Raspberry Pi
            $name=$(cat /etc/os-release | grep -i version | cut -d'=' -f2 | cut -d'(' -f1)
            #Get the version of the OS of the Raspberry Pi
            $vers=$(cat /etc/os-release | grep -i version | cut -d'=' -f2 | cut -d'(' -f2 | cut -d')' -f1)
            # Get the MAC address of the Raspberry Pi (both eth0 and wlan0)
            $mac=$(cat /sys/class/net/*/address)

            # Get the current IP address of the Raspberry Pi
            $bip=$(hostname -I | cut -d' ' -f1)
            # Get the current hostname of the Raspberry Pi
            $bn=$(hostname)
            # Get the current SSH port of the Raspberry Pi
            $bssh=$(grep -i port /etc/ssh/sshd_config | cut -d' ' -f2)

            # Replace all variables in the file AskUser.txt
            sed -i "s/\$name/$name/" AskUser.txt
            sed -i "s/\$vers/$vers/" AskUser.txt
            sed -i "s/\$mac/$mac/" AskUser.txt
            sed -i "s/\$old_ip/$old_ip/" AskUser.txt
            sed -i "s/\$default_name/$default_name/" AskUser.txt
            sed -i "s/\$default_ssh/$default_ssh/" AskUser.txt
        }
        get_default_values

    # 4. Function to gather all users choices to set the AskUser.txt file
        function ask_user(){
            # 1. Ask if user have a settings file. 
                # If YES, ask for link and download it then replace file "AskUser.txt" with it.
                echo "Have you a settings file ? (Y/N)"
                read answer
                if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
                    echo "Please give me the URL to download this file : "
                    read url_param
                    wget -O AskUser.txt "$url_param"
                else
                # 1.2. Want to fix a static IP address.
                    # If YES, ask for wished IP address then save it in "AskUser.txt" file in place of $new_ip  
                    echo "Would you like to fix a static IP address ? (Y/N)"
                    read answer_ip
                    if [ "$answer_ip" = "Y" ] || [ "$answer_ip" = "y" ]; then
                        echo "Please enter it : "
                        read ip_address
                        sed -i "s/\$new_ip/$ip_address/" AskUser.txt
                    fi

                # 1.3. Want to change the hostname.
                    # IF YES, ask for it and save it in AskUser.txt file in place of $new_name
                    echo "Would you like to change the hostname ? (Y/N)"
                    read answer_hostname
                    if [ "$answer_hostname" = "Y" ] || [ "$answer_hostname" = "y" ]; then
                        echo "Please enter it : "
                        read hostname
                        sed -i "s/\$new_name/$hostname/" AskUser.txt
                    fi

                # 1.4. Want to change the default SSH port. (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
                    # IF YES, ask for it and save it in AskUser.txt file in place of $new_ssh
                    echo "Would you like to change the default SSH port ? (Y/N)"
                    read answer_ssh
                    if [ "$answer_ssh" = "Y" ] || [ "$answer_ssh" = "y" ]; then
                        echo "Please enter it : "
                        read ssh_port
                        sed -i "s/\$new_ssh/$ssh_port/" AskUser.txt
                    fi
                # 1.5. Want to register WIFI networks. And how much networks ? (Make a loop if more than one network)
                    # IF YES, ask for SSID and password and save it in AskUser.txt file in place of $1ssid and $1pwd
                    echo "Would you like to register a WIFI network ? (Y/N)"
                    read answer_wifi
                    if [ "$answer_wifi" = "Y" ] || [ "$answer_wifi" = "y" ]; then
                        echo "How many networks do you want to register ?"
                        read $wifi_network_number
                        for ((i=1; i<=$wifi_network_number; i++)); do
                            echo "Please enter the SSID of the network $i : "
                            read ssid
                            echo "Please enter the password of the network $i : "
                            read pass
                            sed -i "s/\$ssid/$ssid/" AskUser.txt
                            sed -i "s/\$pass/$pass/" AskUser.txt
                        done
                    fi

                # 1.6. Want to set a backup routine. (Y/N - $backup_set)(In a first time only a USB key - $backup_place)
                    # IF YES, ask user for the frequency backup and replace it in AskUser.txt file values $backup_set, $backup_place, $backup_time
                    echo "Would you like to set a backup routine ? (Y/N)"
                    read answer_backup
                    if [ "$answer_backup" = "Y" ] || [ "$answer_backup" = "y" ]; then
                        # Automatically locate the USB key
                        $back_place=$(lsblk | grep -i disk | cut -d' ' -f1)
                        # Ask user for the frequency of the backup
                        echo "Please enter the frequency of the backup."
                        echo "(Format : one digit for each value (or just a *) : min hour day(1-31) month(1-12) weekday(0-7))."
                        echo "(Default value : 0 3 * * * (every day at 3am)) : "
                        read backup_frequency
                        sed -i "s/\$backup_time/$backup_frequency/" AskUser.txt
                    fi
                    # IF NO, replace $backup_set in AskUser.txt file by "no"
                    sed -i "s/\$backup_set/no/" AskUser.txt
                
                
                # 1.7. Want to set a update routine. (Y/N - $update_set)
                    # IF YES, ask user for the frequency update and replace it in AskUser.txt file values $maj, $majday and $majhour
                    echo "Would you like to set a update routine ? (Y/N)"
                    read answer_update
                    if [ "$answer_update" = "Y" ] || [ "$answer_update" = "y" ]; then
                        # Ask user for the frequency of the update
                        echo "Please enter the frequency of the update : "
                        read update_frequency
                        sed -i "s/\$maj/$update_frequency/" AskUser.txt
                    fi
                    # IF NO, replace $maj in AskUser.txt file by "no"
                    sed -i "s/\$maj/no/" AskUser.txt

                # 1.8. Want to set a reboot routine. (Y/N - $reboot_set)
                    # IF YES, ask user for the frequency reboot and replace it in AskUser.txt file values $reboot, $rebday and $rebhour
                    echo "Would you like to set a reboot routine ? (Y/N)"
                    read answer_reboot
                    if [ "$answer_reboot" = "Y" ] || [ "$answer_reboot" = "y" ]; then
                        # Ask user for the frequency of the reboot
                        echo "Please enter the frequency of the reboot : "
                        read reboot_frequency
                        sed -i "s/\$reboot/$reboot_frequency/" AskUser.txt
                    fi
                    # IF NO, replace $reboot in AskUser.txt file by "no"
                    sed -i "s/\$reboot/no/" AskUser.txt

                # 1.9. Propose to install NO-IP (Y/N) - Ask credentials => Save in parameters file
                    echo "Would you like to install NO-IP ? (Y/N)"
                    read answer_noip
                    if [ "$answer_noip" = "Y" ] || [ "$answer_noip" = "y" ]; then
                        echo "Please enter your NO-IP credentials : "
                        read noip_credentials
                        sed -i "s/\$noip/$noip_credentials/" AskUser.txt
                    fi

                # 1.10. Propose to install Docker and docker-compose ? Y/N => Save in parameters file
                    echo "Would you like to install Docker and docker-compose ? (Y/N)"
                    read answer_docker
                    if [ "$answer_docker" = "Y" ] || [ "$answer_docker" = "y" ]; then
                        sed -i "s/\$docker/Y/" AskUser.txt
                    fi

                # 1.11. Propose to download and launch dockerfile.yml/docker-compose.yml ? Y/N + Ask for download link => Save in parameters file
                    echo "Would you like to download and launch dockerfile.yml/docker-compose.yml ? (Y/N)"
                    read answer_dockerfile
                    if [ "$answer_dockerfile" = "Y" ] || [ "$answer_dockerfile" = "y" ]; then
                        echo "Please enter the download link : "
                        read dockerfile_link
                        sed -i "s/\$dockerfile/$dockerfile_link/" AskUser.txt
                    fi
                fi
       ask_user
# **************************************************************************************************	
# Run working scripts [config_raspi.sh, backup.sh, noip.sh, setup_docker.sh, my_cont.sh] 
    # 5. Run config_raspi.sh file to configure the Raspberry Pi
        # Run script
        $script_name="config_raspi.sh"
        ./$script_name
        # Check if script has been executed successfully
        if [ $? -eq 0 ]; then
            echo "Le script $script_name s'est terminé avec succès." | tee -a $log_file
            return 0
        else
            echo "Erreur: le script $script_name a échoué." | tee -a $log_file
            return 1
        fi    
        # a. Each step will be checked and controlled to ensure that everything is in order.
        # b. Each step will be logged in the log file.
        # c. If an error occurs, the script will be stopped and the user will be informed.



    # 6. Run backup.sh file to set the backup of Raspberry Pi
        # a. Each step will be checked and controlled to ensure that everything is in order.
        # b. Each step will be logged in the log file.
        # c. If an error occurs, the script will be stopped and the user will be informed.


    # 7. Run NO-IP install script if (si f.=Y) [noip.sh]
    # 8. Lancement du script de Docker et docker-compose (si g.=Y) [setup_docker.sh]
    # 9. Lancement du script de téléchargement et lancement des containeurs dockerfile.yml/docker-compose.yml (si h.=Y) [my_cont.sh]
# **************************************************************************************************
# Final steps    
    # 10. Clean up and display log file
        # Move up, move the (2) log file(s) in the user folder
            mv sump_logfile.log /home/$user
        #mv classic.log /home/$user
            cd ..
        # a. Delete all downloaded files.
            rm working_files/*
        # SUMP.sh Auto-delete at end + 1min
            script_path=$(readlink -f "$0")
            rm_cmd="rm -- \"$script_path\""
            at now + 1 minute -f <(echo "$rm_cmd")
        # c. Affichage du fichier log.
            echo -e "$(cat /home/$user/sump_logfile.log)"


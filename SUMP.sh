#!/bin/bash
# Main Script [SUMP.sh]
# Setting up the environment
    # 1. Download working_files.zip && unzip working_files.zip
        wget https://your_url_here/working_files.zip && unzip working_files.zip
        # Make all files in the directory working_files executable && move to working_files directory
        chmod +x working_files/* && cd working_files
    # 2. Add the date to the sump_logfile.log file name -> sump_logfile_yy_mm_dd_hh_mm.
        current_date=$(date +"%y_%m_%d_%H_%M")
        mv sump_logfile.log sump_logfile_${current_date}.log
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

            # Replace all variables in the file settings.txt
            sed -i "s/\$name/$name/" settings.txt
            sed -i "s/\$vers/$vers/" settings.txt
            sed -i "s/\$mac/$mac/" settings.txt
            sed -i "s/\$old_ip/$old_ip/" settings.txt
            sed -i "s/\$default_name/$default_name/" settings.txt
            sed -i "s/\$default_ssh/$default_ssh/" settings.txt
            # Replace variables $name, $vers and $mac in green inthe file sump_logfile.log
            sed -i "s/NAME/\033[32m$name\033[0m/" sump_logfile.log
            sed -i "s/VERS/\033[32m$vers\033[0m/" sump_logfile.log
            sed -i "s/MAC/\033[32m$mac\033[0m/" sump_logfile.log
            # ???  Replace variables $old_ip, $default_name and $default_ssh in red in the file sump_logfile.log
        }
        get_default_values
    # 4. Function to gather all users choices to set the settings.txt file
        function ask_user(){
            # 1. Ask if user have a settings file. 
                # If YES, ask for link and download it then replace file "settings.txt" with it.
                echo "Have you a settings file ? (Y/N)"
                read answer
                if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
                    echo "Please give me the URL to download this file : "
                    read url_param
                    wget -O settings.txt "$url_param"
                else
                # 1.2. Want to fix a static IP address.
                    # If YES, ask for wished IP address then save it in "settings.txt" file in place of $new_ip  
                    echo "Would you like to fix a static IP address ? (Y/N)"
                    read answer_ip
                    if [ "$answer_ip" = "Y" ] || [ "$answer_ip" = "y" ]; then
                        echo "Please enter it : "
                        read ip_address
                        sed -i "s/\$new_ip/$ip_address/" settings.txt
                    fi

                # 1.3. Want to change the hostname.
                    # IF YES, ask for it and save it in settings.txt file in place of $new_name
                    echo "Would you like to change the hostname ? (Y/N)"
                    read answer_hostname
                    if [ "$answer_hostname" = "Y" ] || [ "$answer_hostname" = "y" ]; then
                        echo "Please enter it : "
                        read hostname
                        sed -i "s/\$new_name/$hostname/" settings.txt
                    fi

                # 1.4. Want to change the default SSH port. (A voir si in fine on ne changerai pas ça par la méthode avec certificat)
                    # IF YES, ask for it and save it in settings.txt file in place of $new_ssh
                    echo "Would you like to change the default SSH port ? (Y/N)"
                    read answer_ssh
                    if [ "$answer_ssh" = "Y" ] || [ "$answer_ssh" = "y" ]; then
                        echo "Please enter it : "
                        read ssh_port
                        sed -i "s/\$new_ssh/$ssh_port/" settings.txt
                    fi
                # 1.5. Want to register WIFI networks. And how many networks ? (Make a loop if more than one network)
                    # IF YES, ask for SSID and password and save it in settings.txt file in place of $1ssid and $1pwd
                    echo "Would you like to register a WIFI network ? (Y/N)"
                    read answer_wifi
                    if [ "$answer_wifi" = "Y" ] || [ "$answer_wifi" = "y" ]; then
                        echo "How many networks do you want to register ?"
                        read wifi_network_number
                        # Replace the number of networks in green in settings.txt file in place of $wifi_network_number
                        sed -i "s/\$wifi_network_number/$wifi_network_number/" settings.txt

                        # Make a loop to ask for SSID and password for each network
                        for ((i=1; i<=$wifi_network_number; i++)); do
                            echo "Please enter the SSID of the network $i : "
                            read ssid
                            echo "Please enter the password of the network $i : "
                            read pass
                            # Add the SSID and password in settings.txt file after $wifi_network_number
                            sed -i "/\$wifi_network_number/a\\n\033[32m$(($i))SSID = $ssid\033[0m\n\033[32m\tPassword = $pass\033[0m" settings.txt
                        done

                        # Modify sump_logfile.log to adapt the part according to the number of WIFI networks (with identifiers)
                        sed -i "s/\$wifi_network_number/\033[32m$wifi_network_number\033[0m/" sump_logfile.log
                        for ((i=1; i<=$wifi_network_number; i++)); do
                            ssid_var="${i}ssid"
                            pass_var="${i}pwd"
                            ssid_val=$(sed -n -e "s/^.*${ssid_var} = //p" settings.txt)
                            pass_val=$(sed -n -e "s/^.*${pass_var} = //p" settings.txt)
                            sed -i "s/\$${ssid_var}/\033[32m${ssid_val}\033[0m/" sump_logfile.log
                            sed -i "s/\$${pass_var}/\033[32m${pass_val}\033[0m/" sump_logfile.log
                        done
                    fi


                # 1.6. Want to set a backup routine. (Y/N - $backup_set)(In a first time only a USB key - $backup_place)
                    # IF YES, ask user for the frequency backup and replace it in settings.txt file values $backup_set, $backup_place, $backup_time
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
                        sed -i "s/\$backup_time/$backup_frequency/" settings.txt
                    fi
                    # IF NO, replace $backup_set in settings.txt file by "no"
                    sed -i "s/\$backup_set/no/" settings.txt
                
                
                # 1.7. Want to set a update routine. (Y/N - $update_set)
                    # IF YES, ask user for the frequency update and replace it in settings.txt file values $maj, $majday and $majhour
                    echo "Would you like to set a update routine ? (Y/N)"
                    read answer_update
                    if [ "$answer_update" = "Y" ] || [ "$answer_update" = "y" ]; then
                        # Ask user for the frequency of the update
                        echo "Please enter the frequency of the update : "
                        read update_frequency
                        sed -i "s/\$maj/$update_frequency/" settings.txt
                    fi
                    # IF NO, replace $maj in settings.txt file by "no"
                    sed -i "s/\$maj/no/" settings.txt

                # 1.8. Want to set a reboot routine. (Y/N - $reboot_set)
                    # IF YES, ask user for the frequency reboot and replace it in settings.txt file values $reboot, $rebday and $rebhour
                    echo "Would you like to set a reboot routine ? (Y/N)"
                    read answer_reboot
                    if [ "$answer_reboot" = "Y" ] || [ "$answer_reboot" = "y" ]; then
                        # Ask user for the frequency of the reboot
                        echo "Please enter the frequency of the reboot : "
                        read reboot_frequency
                        sed -i "s/\$reboot/$reboot_frequency/" settings.txt
                    fi
                    # IF NO, replace $reboot in settings.txt file by "no"
                    sed -i "s/\$reboot/no/" settings.txt

                # 1.9. Propose to install NO-IP (Y/N) - Ask credentials => Save in parameters file
                    echo "Would you like to install NO-IP ? (Y/N)"
                    read answer_noip
                    if [ "$answer_noip" = "Y" ] || [ "$answer_noip" = "y" ]; then
                        echo "Please enter your NO-IP credentials : "
                        read noip_credentials
                        sed -i "s/\$noip/$noip_credentials/" settings.txt
                    fi

                # 1.10. Propose to install Docker and docker-compose ? Y/N => Save in parameters file
                    echo "Would you like to install Docker and docker-compose ? (Y/N)"
                    read answer_docker
                    if [ "$answer_docker" = "Y" ] || [ "$answer_docker" = "y" ]; then
                        sed -i "s/\$docker/Y/" settings.txt
                    fi

                # 1.11. Propose to download and launch dockerfile.yml/docker-compose.yml ? Y/N + Ask for download link => Save in parameters file
                    echo "Would you like to download and launch dockerfile.yml/docker-compose.yml ? (Y/N)"
                    read answer_dockerfile
                    if [ "$answer_dockerfile" = "Y" ] || [ "$answer_dockerfile" = "y" ]; then
                        echo "Please enter the download link : "
                        read dockerfile_link
                        sed -i "s/\$dockerfile/$dockerfile_link/" settings.txt
                    fi
                fi
       ask_user
# **************************************************************************************************	
# Run working scripts [config_raspi.sh, backup.sh, noip.sh, setup_docker.sh, my_cont.sh]
# If one of them fails, the script will be stopped and the user will be informed.
    # 5. Run config_raspi.sh file to configure the Raspberry Pi
        # Run script
        $script_name="config_raspi.sh"
        ./$script_name
        # If script has been executed successfully set CONFIGURATION in green in sump_logfile.log else in red.
        if [ $? -eq 0 ]; then
            sed -i 's/CONFIGURATION/\033[32mCONFIGURATION\033[0m/g' sump_logfile.log
            return 0
        else
            sed -i 's/CONFIGURATION/\033[31mCONFIGURATION\033[0m/g' sump_logfile.log
            return 1
        fi    
        # a. Each step will be checked and controlled to ensure that everything is in order.
        # b. Each step will be logged in the log file.
        # c. If an error occurs, the script will be stopped and the user will be informed.

    # 6. Run backup script (if backup_set="y") [backup.sh]
        if [ "$backup_set" = "y" ]; then
            # Run script
            $script_name="backup.sh"
            ./$script_name
            # If script has been executed successfully set BACKUP in green in sump_logfile.log else in red.
            if [ $? -eq 0 ]; then
                sed -i 's/BACKUP/\033[32mBACKUP\033[0m/g' sump_logfile.log
                return 0
            else
                sed -i 's/BACKUP/\033[31mBACKUP\033[0m/g' sump_logfile.log
                return 1
            fi
        fi

        # a. Each step will be checked and controlled to ensure that everything is in order.
        # b. Each step will be logged in the log file.
        # c. If an error occurs, the script will be stopped and the user will be informed.


    # --- *** --- NO-IP --- *** --- #
    # 7. Run NO-IP install script (if $noip !="n") [noip.sh]
        if [ "$noip" != "n" ]; then
            # Run script
            $script_name="noip.sh"
            ./$script_name
        fi

    # --- *** --- DOCKER --- *** --- #
    # 8. Run Docker et docker-compose scripts (if $docker !="n") [setup_docker.sh]
        if [ "$docker" != "n" ]; then
            # Run script
            $script_name="setup_docker.sh"
            ./$script_name
        fi
    # 9. Run script to download and run containeurs dockerfile.yml/docker-compose.yml (si h.=Y) [my_cont.sh]
        # Check if setup_docker.sh has been executed successfully
        if [ $? -eq 0 ]; then
            echo "Le script $script_name s'est terminé avec succès." | tee -a $log_file
            return 0
        else
            echo "Erreur: le script $script_name a échoué." | tee -a $log_file
            return 1
        fi        
        
        # Check in settings.txt file if $dockerfile !="link", if yes run my_cont.sh
        if [ "$dockerfile" != "link" ]; then
            # Run script
            $script_name="my_cont.sh"
            ./$script_name
        fi
        

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

# Envoyer le fichier de log par email
# echo "Veuillez trouver ci-joint le fichier de log de la configuration du Raspberry Pi." | mail -s "Rapport de configuration du Raspberry Pi" -a "$LOG_FILE" baudoux.sebastien@gmail.com
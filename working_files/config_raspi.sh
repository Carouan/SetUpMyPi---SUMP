#!/bin/bash

# ************************************************
# MODIFICATIONS BASIQUES ESSENTIELLES ET CRITIQUES
# ************************************************
# **********   UPDATE/UPGRADE + Gather variables   ********** #
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
        # Replace UPGRADE in sump_logfile.log file by "UPGRADE" in red
        sed -i 's/UPGRADE/\033[31mUPGRADE\033[0m/g' sump_logfile.log
        fi
    # Gather variables from CONFIG section from settings.txt
        # List of variables gathered = actual_ip | new_ip | default_name | new_name 
        # default_ssh | new_ssh |wifi_network_number | 1ssid | 1pwd | 2ssid | 2pwd
        awk '/^# CONFIG$/,/^# END_CONFIG$/{if (!/^# CONFIG$/ && !/^# END_CONFIG$/) print}' settings.txt > temp_variables.txt
        source temp_variables.txt
        rm temp_variables.txt
    # Used variables in sump_logfile.log =
        # $bip | $aip | $bn | $an | $bssh | $assh | $wifi_network_number | $1ssid | $1pwd | $2ssid | $2pwd  

# **********   STATIC IP   ********** #
    function config_static_ip() {
        actual_ip=$(hostname -I | awk '{print $1}')
        # Use the variable $new_ip to modify the file /etc/dhcpcd.conf   
        sudo sed -i 's/^#interface eth0$/interface eth0/' /etc/dhcpcd.conf
        sudo sed -i '$ a\static ip_address='$new_ip'/24' /etc/dhcpcd.conf
        sudo sed -i '$ a\static routers='$router_ip'' /etc/dhcpcd.conf
        # Restart the service dhcpcd
        sudo systemctl daemon-reload
        sudo systemctl restart dhcpcd
        # Check if the static IP is set by comparing the current IP with the one set in the file /etc/dhcpcd.conf
        if [ "$actual_ip" == "$new_ip" ]; then
            # Replace $bip with $actual_ip in blue and $aip with $new_ip in green in sump_logfile.log
            sed -i 's/$bip/\033[34m'$actual_ip'\033[0m/g' sump_logfile.log
            sed -i 's/$aip/\033[32m'$new_ip'\033[0m/g' sump_logfile.log
        else
            # Replace $bip with $actual_ip in blue underline and $aip with $new_ip in red in sump_logfile.log
            sed -i 's/$bip/\033[34m\u'$actual_ip'\033[0m/g' sump_logfile.log
            sed -i 's/$aip/\033[31m'$new_ip'\033[0m/g' sump_logfile.log
        fi
    }
    # Check if user want to change the IP address (if $new_ip!="0")
        if [ "$new_ip" != "0" ]; then
            config_static_ip
        else
        # In sump_logfile.log, Modify $bip with actual IP address in green and $aip with a red "/"
            sed -i 's/$bip/\033[32m'$(hostname -I | awk '{print $1}')'\033[0m/g' sump_logfile.log
            sed -i 's/$aip/\033[31m\/\033[0m/g' sump_logfile.log
        fi

# **********   HOSTNAME   ********** # 
    function rename_raspi() {
        # Rename the Raspberry Pi by using $new_name variable
        sudo hostnamectl set-hostname $new_name
        # Check if the hostname is set by comparing the current hostname with the one set in the file /etc/hostname
        if [ "$actual_name" == "$new_name" ]; then
            # Replace $bn with $actual_name in blue and $an with $new_name in green in sump_logfile.log
            sed -i 's/$bn/\033[34m'$actual_name'\033[0m/g' sump_logfile.log
            sed -i 's/$an/\033[32m'$new_name'\033[0m/g' sump_logfile.log
        else
            # Replace $bn with $actual_name in blue underline and $an with $new_name in red in sump_logfile.log
            sed -i 's/$bn/\033[34m\u'$actual_name'\033[0m/g' sump_logfile.log
            sed -i 's/$an/\033[31m'$new_name'\033[0m/g' sump_logfile.log
        fi
    }
    # Check if user want to change the hostname (if $new_name!="0")
        if [ "$new_name" != "0" ]; then
            rename_raspi
        else
        # In sump_logfile.log, Modify $bname with actual hostname in green and $aname with a red "/"
            sed -i 's/$bname/\033[32m'$(hostname)'\033[0m/g' sump_logfile.log
            sed -i 's/$aname/\033[31m\/\033[0m/g' sump_logfile.log
        fi

# **********   SSH   ********** #
    function change_ssh(){
        sudo sed -i 's/^#Port 22$/Port 60433/' /etc/ssh/sshd_config
        sudo service ssh restart
        if [ $? -eq 0 ]; then
            # Replace $bssh with $actual_ssh in blue and $assh with $new_ssh in green in sump_logfile.log
            sed -i 's/$bssh/\033[34m'$actual_ssh'\033[0m/g' sump_logfile.log
            sed -i 's/$assh/\033[32m'$new_ssh'\033[0m/g' sump_logfile.log
        else
            # Replace $bssh with $actual_ssh in blue underline and $assh with $new_ssh in red in sump_logfile.log
            sed -i 's/$bssh/\033[34m\u'$actual_ssh'\033[0m/g' sump_logfile.log
            sed -i 's/$assh/\033[31m'$new_ssh'\033[0m/g' sump_logfile.log
        fi
    }
    # Check if user want to change SSH port (if $new_ssh!="0")
        if [ "$new_ssh" != "0" ]; then
            change_ssh
        else
        # In sump_logfile.log, Modify $bssh with actual SSH port in green and $assh with a red "/"
            sed -i 's/$bssh/\033[32m'$(grep -i port /etc/ssh/sshd_config | awk '{print $2}')'\033[0m/g' sump_logfile.log
            sed -i 's/$assh/\033[31m\/\033[0m/g' sump_logfile.log
        fi

# **********   WIFI   ********** #
    function set_wifinetwork(){
        # With a loop, linked to the number of wifi network the user want to configure ($wifi_network_number)
        for (( i=1; i<=$wifi_network_number; i++ ))
        do
            # Gather the SSID and the password of the wifi network in settings.txt
            ssid=$(sed -n "$((i+1))p" settings.txt)
            password=$(sed -n "$((i+1+1))p" settings.txt)
            # Add the wifi network in /etc/wpa_supplicant/wpa_supplicant.conf
            sudo sh -c "printf 'network={
                ssid=\"$ssid\"
                psk=\"$password\"
            }\n' >> /etc/wpa_supplicant/wpa_supplicant.conf"
            # Modify the wifi network section in sump_logfile.log to add the SSID and the password for all the wifi network configured
            sed -i 's/$ssid'$i'/'$ssid'/g' sump_logfile.log
            sed -i 's/$password'$i'/'$password'/g' sump_logfile.log
        done
    }
    # Check if user want to configure wifi network and how many. (if $wifi_network_number!="0")
        if [ "$wifi_network_number" != "0" ]; then
            set_wifinetwork
        else
        # Remove the wifi section (lines 26 to 33) in sump_logfile.log
            sed -i '26,33d' sump_logfile.log
        fi
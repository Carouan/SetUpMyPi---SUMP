#!/bin/bash

# ***************
#  NO-IP SCRIPT
# ***************
    # Gather variables from 'NOIP' to 'END_NOIP' from settings.txt file
        awk '/^# NOIP$/,/^# END_NOIP$/{if (!/^# NOIP$/ && !/^# END_NOIP$/) print}' settings.txt > temp_variables.txt
        source temp_variables.txt
        rm temp_variables.txt

    # Download, unzip & go to noip-duc directory
        get https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_3.0.0-beta.6.tar.gz
        tar xf noip-duc_3.0.0-beta.6.tar.gz
        cd noip-duc_3.0.0-beta.6
    # Install Rust & build noip-duc
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        cargo build --release
        sudo cp target/release/noip-duc /usr/local/bin
    # Replace domain, username and noippwd values in noip_dic command
        noip-duc -g $domain -u $username -p $noippwd
    # Add noip-duc command to crontab
        (crontab -l ; echo "*/5 * * * * noip-duc -g $domain -u $username -p $noippwd") | crontab -
    # Remove noip-duc_3.0.0-beta.6 directory
        cd ..
        rm -rf noip-duc_3.0.0-beta.6
    # Remove noip-duc_3.0.0-beta.6.tar.gz
        rm noip-duc_3.0.0-beta.6.tar.gz
    # Save NO-IP service status and if it's running, set NOIP in sump_logfile.log in green, else in red
        systemctl is-active --quiet noip2.service && sed -i 's/NOIP/\033[32mNOIP\033[0m/g' sump_logfile.log || sed -i 's/NOIP/\033[31mNOIP\033[0m/g' sump_logfile.log




    # noip-duc -g carouan.ddns.net -u carouan -p dM$Qt7.d64Abdm9
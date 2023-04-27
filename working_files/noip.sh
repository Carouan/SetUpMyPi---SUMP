#!/bin/bash

# ***************
#  NO-IP SCRIPT
# ***************
    # Gather variables from 'NOIP' to 'END_NOIP' from settings.txt file
        awk '/^# NOIP$/,/^# END_NOIP$/{if (!/^# NOIP$/ && !/^# END_NOIP$/) print}' settings.txt > temp_variables.txt
        source temp_variables.txt
        rm temp_variables.txt


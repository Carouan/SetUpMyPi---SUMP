#!/bin/bash

# ***************
#  DOCKER SCRIPT
# ***************
    # Gather variables from 'DOCKER' to 'END_DOCKER' from settings.txt file
        awk '/^# DOCKER$/,/^# END_DOCKER$/{if (!/^# DOCKER$/ && !/^# END_DOCKER$/) print}' settings.txt > temp_variables.txt
        source temp_variables.txt
        rm temp_variables.txt

# Docker Installation
  curl -sSL https://get.docker.com/ | sh
  sudo usermod -aG docker $(whoami)
  if [ $? -eq 0 ]; then
    echo "Installation de Docker terminée avec succès."
  else
    echo "Erreur lors de l'installation de Docker."
  fi
# Docker-Compose Installation
  sudo apt install -y docker-compose
  if [ $? -eq 0 ]; then

    # If Docker Compose is installed, we can start the containers by launching the script run_cont.sh
    # Download the script
      wget https://raw.githubusercontent.com/sebbaudoux/fdd/master/run_cont.sh
      # Make it executable
      chmod +x run_cont.sh
      # Launch it
      ./run_cont.sh
  else
    echo "Erreur lors de l'installation de Docker Compose."
  fi

# Supprimer les entrées de crontab pour set_docker.sh
(crontab -l | grep -v "/usr/local/bin/set_docker.sh") | crontab -

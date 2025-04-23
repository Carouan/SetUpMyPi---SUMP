#!/bin/bash

# Lancement des conteneurs dockers
# Containers :
# 1. LAMP (Apache+MySQL+PHP)
# 2. Discord Bot
# 3. Serveur Minecraft
# ---------------------

# Créer le répertoire pour les projets
    mkdir -p ~/projets
    cd ~/projets

# Download the archive containing the 3 docker-compose files on Google Drive
# https://drive.google.com/u/0/uc?id=1ub0KUVM4LvRKNaYiQfWQDtbG3boMUgBS&export=download'
    wget -O docker-compose-files.zip https://drive.google.com/u/0/uc?id=1ub0KUVM4LvRKNaYiQfWQDtbG3boMUgBS&export=download
    unzip docker-compose-files.zip
    rm docker-compose-files.zip

# LAMP (Apache+MySQL+PHP)
    mkdir -p ./lamp/www
    mkdir -p ./lamp/mysql
    docker-compose -f docker-compose-lamp.yml up -d

# Discord Bot
    docker build -t discord-bot .
    docker run -d --name discord-bot discord-bot

# Serveur Minecraft
    mkdir -p ./minecraft/data
    docker-compose -f docker-compose-minecraft.yml up -d

# Configuration d'ufw
    sudo apt-get install -y ufw
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow 3306
    sudo ufw allow 25565
    sudo ufw enable

# Configuration de fail2ban
    sudo apt-get install -y fail2ban
    sudo cp ./fail2ban/jail.local /etc/fail2ban/jail.local
    sudo service fail2ban restart

# Configuration de certbot
    sudo apt-get install -y certbot python3-certbot-apache
    sudo certbot --apache

# Supprimer les entrées de crontab pour run_cont.sh
    (crontab -l | grep -v "/usr/local/bin/run_cont.sh") | crontab -

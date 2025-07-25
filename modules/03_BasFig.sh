#!/bin/bash
# Titre: Configuration réseau et nom du serveur
# Catégorie: Système
# Auto: no

set -e

LOG_FILE="logs/sump.log"
SETTINGS="settings.txt"
source ui/helpers.sh

# Changement du nom d'hôte
read -rp "Nom à donner au serveur (ex: monserveur) : " HOSTNAME
echo "$HOSTNAME" > /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$HOSTNAME/" /etc/hosts
log_msg "Nom du serveur changé en $HOSTNAME"
echo "HOSTNAME=$HOSTNAME" >> "$SETTINGS"

# Choix d'une interface
echo "Interfaces détectées :"
ip -o link show | awk -F': ' '{print $2}' | grep -v lo
read -rp "Interface à configurer pour IP fixe (ex: eth0, wlan0) : " IFACE

# IP fixe
read -rp "Adresse IP fixe (ex: 192.168.1.100/24) : " IP
read -rp "Passerelle (ex: 192.168.1.1) : " GATEWAY
read -rp "DNS (ex: 1.1.1.1) : " DNS

# Configuration de dhcpcd.conf
cat <<EOF >> /etc/dhcpcd.conf

# Configuration statique ajoutée par SUMP
interface $IFACE
static ip_address=$IP
static routers=$GATEWAY
static domain_name_servers=$DNS
EOF

log_msg "IP statique configurée sur $IFACE ($IP)"
echo "INTERFACE=$IFACE" >> "$SETTINGS"
echo "STATIC_IP=$IP" >> "$SETTINGS"

# Redémarrage du service réseau
systemctl restart dhcpcd
log_msg "Redémarrage de dhcpcd"

echo
echo "Configuration terminée."

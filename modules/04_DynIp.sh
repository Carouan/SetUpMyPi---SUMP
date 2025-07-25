#!/bin/bash
# Titre: Configuration de l’IP dynamique (DuckDNS)
# Catégorie: Réseau
# Auto: no

set -e

LOG_FILE="logs/sump.log"
SETTINGS="settings.txt"
source ui/helpers.sh

echo
echo "Configuration d’un service DNS dynamique (IP fixe virtuelle)"
echo "➡️  Fournisseur utilisé : DuckDNS (gratuit)"
echo

# read -rp "Quel fournisseur utiliser ? [duckdns|noip] : " PROVIDER

read -rp "Quel est ton sous-domaine DuckDNS ? (ex: monserveur) : " DUCK_SUBDOMAIN
read -rp "Quel est ton token DuckDNS ? : " DUCK_TOKEN

echo "DUCKDNS_SUBDOMAIN=$DUCK_SUBDOMAIN" >> "$SETTINGS"
echo "DUCKDNS_TOKEN=$DUCK_TOKEN" >> "$SETTINGS"

# Créer le script de mise à jour
mkdir -p /opt/duckdns
DUCK_SCRIPT="/opt/duckdns/duckdns.sh"

cat <<EOF > "$DUCK_SCRIPT"
#!/bin/bash
echo url="https://www.duckdns.org/update?domains=$DUCK_SUBDOMAIN&token=$DUCK_TOKEN&ip=" | curl -k -o /opt/duckdns/duckdns.log -K -
EOF

chmod +x "$DUCK_SCRIPT"
log_msg "Script DuckDNS créé à $DUCK_SCRIPT"

# Créer tâche cron toutes les 5 minutes
CRON_FILE="/etc/cron.d/duckdns"
echo "*/5 * * * * root $DUCK_SCRIPT > /dev/null 2>&1" > "$CRON_FILE"

log_msg "Tâche cron créée pour mettre à jour l’IP DuckDNS toutes les 5 minutes."

echo
echo "✅ DuckDNS est configuré et actif."
echo "🔗 Tu peux vérifier via : https://www.duckdns.org/domains"

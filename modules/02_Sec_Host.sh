#!/bin/bash
# Titre: Configuration pare-feu et sécurité de base
# Catégorie: Sécurité
# Auto: yes

set -e

LOG_FILE="logs/sump.log"
SETTINGS="settings.txt"
source ui/helpers.sh

# 🔁 Charger le port SSH si défini
if grep -q "^SSH_PORT=" "$SETTINGS"; then
  source "$SETTINGS"
else
  read -rp "Quel port SSH as-tu configuré précédemment ? (22 si inconnu) : " SSH_PORT
  echo "SSH_PORT=$SSH_PORT" >> "$SETTINGS"
fi

log_msg "[SECURITY] Début de configuration de la sécurité système."

echo "Installation de fail2ban et ufw..."
apt install -y fail2ban ufw

log_msg "Services installés."

# 🧱 Configuration fail2ban minimaliste
cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = $SSH_PORT
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOF

log_msg "Fichier /etc/fail2ban/jail.local créé."

systemctl enable fail2ban
systemctl restart fail2ban
log_msg "fail2ban activé et redémarré."

# 🔥 Configuration UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow $SSH_PORT/tcp
log_msg "Pare-feu UFW : trafic entrant bloqué sauf SSH ($SSH_PORT)."

# Optionnel : autoriser web
if confirm_prompt "Souhaites-tu autoriser HTTP (80) et HTTPS (443) ?"; then
  ufw allow 80/tcp
  ufw allow 443/tcp
  log_msg "Ports HTTP et HTTPS autorisés."
fi

ufw --force enable
log_msg "Pare-feu UFW activé."

echo
echo "✅ Sécurité réseau configurée : fail2ban actif, UFW actif."

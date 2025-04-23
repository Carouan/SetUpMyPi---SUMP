#!/bin/bash
# Titre: Configuration pare-feu et sécurité de base
# Catégorie: Sécurité
# Auto: yes

set -e

LOG_FILE="logs/sump.log"
SETTINGS="settings.txt"

log() {
  echo "$(date +'%F %T') - $1" | tee -a "$LOG_FILE"
}

# 🔁 Charger le port SSH si défini
if grep -q "^SSH_PORT=" "$SETTINGS"; then
  source "$SETTINGS"
else
  read -rp "Quel port SSH as-tu configuré précédemment ? (22 si inconnu) : " SSH_PORT
  echo "SSH_PORT=$SSH_PORT" >> "$SETTINGS"
fi

log "[SECURITY] Début de configuration de la sécurité système."

echo "Installation de fail2ban et ufw..."
apt install -y fail2ban ufw

log "Services installés."

# 🧱 Configuration fail2ban minimaliste
cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = $SSH_PORT
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOF

log "Fichier /etc/fail2ban/jail.local créé."

systemctl enable fail2ban
systemctl restart fail2ban
log "fail2ban activé et redémarré."

# 🔥 Configuration UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow $SSH_PORT/tcp
log "Pare-feu UFW : trafic entrant bloqué sauf SSH ($SSH_PORT)."

# Optionnel : autoriser web
read -rp "Souhaites-tu autoriser HTTP (80) et HTTPS (443) ? [O/n] : " ALLOW_WEB
if [[ "$ALLOW_WEB" =~ ^[OoYy]?$ ]]; then
  ufw allow 80/tcp
  ufw allow 443/tcp
  log "Ports HTTP et HTTPS autorisés."
fi

ufw --force enable
log "Pare-feu UFW activé."

echo
echo "✅ Sécurité réseau configurée : fail2ban actif, UFW actif."

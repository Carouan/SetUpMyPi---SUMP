#!/bin/bash

# Titre: Sécuriser l'accès SSH
# Catégorie: Sécurité
# Auto: no

# secure_ssh.sh
# Sécurise l'accès SSH : nouvel utilisateur sudo, clé SSH, changement de port, désactivation de root

set -e  # Stoppe le script en cas d'erreur

LOG_FILE="/var/log/secure_ssh_setup.log"
source ui/helpers.sh

if [[ $EUID -ne 0 ]]; then
  log_msg "Ce script doit être exécuté en tant que root."
  exit 1
fi

# 1. Demander le nom du nouvel utilisateur
read -p "Nom du nouvel utilisateur avec sudo : " NEW_USER

# 2. Créer le compte et lui donner les droits sudo
adduser "$NEW_USER"
usermod -aG sudo "$NEW_USER"
log_msg "Utilisateur $NEW_USER créé et ajouté au groupe sudo."

# 3. Configurer la clé SSH
mkdir -p /home/$NEW_USER/.ssh
chmod 700 /home/$NEW_USER/.ssh
read -p "Colle la clé publique SSH (ssh-ed25519 ou ssh-rsa) : " SSH_KEY
echo "$SSH_KEY" > /home/$NEW_USER/.ssh/authorized_keys
chmod 600 /home/$NEW_USER/.ssh/authorized_keys
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
log_msg "Clé SSH ajoutée pour $NEW_USER."

# 4. Demander un nouveau port SSH
read -p "Quel port SSH veux-tu utiliser (autre que 22) ? " NEW_PORT

# 5. Modifier sshd_config proprement
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="$SSHD_CONFIG.bak.$(date +%F-%H%M%S)"
cp $SSHD_CONFIG $BACKUP
log_msg "Sauvegarde de sshd_config : $BACKUP"

# Supprimer les lignes existantes
sed -i '/^#\?Port /d' $SSHD_CONFIG
sed -i '/^#\?PermitRootLogin /d' $SSHD_CONFIG
sed -i '/^#\?PasswordAuthentication /d' $SSHD_CONFIG

# Ajouter la configuration sécurisée
cat <<EOF >> $SSHD_CONFIG

# Sécurisation SSH appliquée par secure_ssh.sh
Port $NEW_PORT
PermitRootLogin no
PasswordAuthentication no
EOF

log_msg "sshd_config mis à jour."

# 6. Verrouiller le mot de passe root
passwd -l root
log_msg "Mot de passe root verrouillé."

# 7. Vérifier la syntaxe SSH avant redémarrage
if sshd -t; then
  systemctl restart sshd
  log_msg "Service SSH redémarré avec succès."
else
  log_msg "Erreur dans sshd_config. Annulation du redémarrage SSH."
  mv "$BACKUP" "$SSHD_CONFIG"
  exit 1
fi

log_msg "Connexion root désactivée, port SSH : $NEW_PORT."
echo
cat <<END
-------------------------------------------------------------
Connexion SSH sécurisée. Utilise la commande suivante :
ssh $NEW_USER@<ip_du_serveur> -p $NEW_PORT
-------------------------------------------------------------
END
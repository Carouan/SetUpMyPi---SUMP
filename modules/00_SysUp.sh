#!/bin/bash

if grep -q "UPDATE_DONE=true" settings.txt; then
  echo "[SKIP] Mise à jour système déjà effectuée."
  exit 0
fi

LOG_FILE="sump_logfile.log"
source ui/helpers.sh

echo "Mise à jour du système en cours..."
apt update && apt full-upgrade -y

# Ajouter une ligne dans les logs
log_msg "Système mis à jour."

# Marquer l'étape comme terminée
echo "UPDATE_DONE=true" >> settings.txt

# Demander à redémarrer
if confirm_prompt "Redémarrer maintenant pour appliquer les mises à jour ?"; then
  touch /tmp/sump_autorestart.flag
  reboot
fi

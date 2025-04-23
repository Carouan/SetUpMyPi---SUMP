#!/bin/bash

if grep -q "UPDATE_DONE=true" settings.txt; then
  echo "[SKIP] Mise à jour système déjà effectuée."
  exit 0
fi

echo "Mise à jour du système en cours..."
apt update && apt full-upgrade -y

# Ajouter une ligne dans les logs
echo "$(date '+%F %T') - Système mis à jour." >> sump_logfile.log

# Marquer l'étape comme terminée
echo "UPDATE_DONE=true" >> settings.txt

# Demander à redémarrer
read -p "Redémarrer maintenant pour appliquer les mises à jour ? [O/n] " REBOOT
if [[ "$REBOOT" =~ ^[OoYy]?$ ]]; then
  touch /tmp/sump_autorestart.flag
  reboot
fi

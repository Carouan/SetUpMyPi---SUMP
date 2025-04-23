#!/bin/bash
# sump.sh - Lanceur principal de SetUpMyPi

# Reprise automatique après redémarrage
if [[ -f /tmp/sump_autorestart.flag ]]; then
  echo "[INFO] Reprise automatique de SUMP après reboot."
  rm /tmp/sump_autorestart.flag
  sleep 3
fi

# Chargement des paramètres persistants
source settings.txt 2>/dev/null || touch settings.txt

# Détection du mode d'affichage (dialog ou fallback texte)
if command -v dialog &>/dev/null; then
  INTERFACE_MODE="dialog"
else
  INTERFACE_MODE="text"
fi
export INTERFACE_MODE

# Chargement des helpers et du menu
source ui/helpers.sh
source ui/menu.sh

# Boucle principale (appel menu)
while true; do
  show_main_menu
done
#!/bin/bash

# Chargement des paramètres
source settings.txt 2>/dev/null || touch settings.txt

# Vérifie si dialog est installé
HAS_DIALOG=$(command -v dialog)

# Boucle du menu principal
while true; do
  if [[ -n "$HAS_DIALOG" ]]; then
    CHOICE=$(dialog --clear --stdout --title "SetUpMyPi - Menu principal" \
      --menu "Que veux-tu faire ?" 15 50 6 \
      1 "Configurer SSH sécurisé" \
      2 "Installer Docker" \
      3 "Afficher paramètres actuels" \
      4 "Quitter")
  else
    echo -e "\n========== Menu SetUpMyPi =========="
    echo "1) Configurer SSH sécurisé"
    echo "2) Installer Docker"
    echo "3) Afficher paramètres actuels"
    echo "4) Quitter"
    read -rp "Ton choix : " CHOICE
  fi

  case $CHOICE in
    1) bash modules/secure_ssh.sh ;;
    2) bash modules/install_docker.sh ;;
    3)
      if [[ -n "$HAS_DIALOG" ]]; then
        dialog --msgbox "$(cat settings.txt)" 15 50
      else
        echo -e "\nParamètres actuels :"
        cat settings.txt
      fi
      ;;
    4)
      [[ -n "$HAS_DIALOG" ]] && clear
      exit 0
      ;;
    *)
      echo "Choix invalide."
      ;;
  esac
done

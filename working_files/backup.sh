#!/bin/bash


# *************
# PARTIE BACKUP
# *************
# Installez mailutils si ce n'est pas déjà fait
sudo apt-get update
sudo apt-get install -y mailutils
if [ $? -eq 0 ]; then
  echo "Installation de mailutils terminée avec succès."
else
  echo "Erreur lors de l'installation de mailutils."
fi

# Montez la clé USB (remplacez sda par la partition appropriée de votre clé USB)
UUID=$(sudo blkid -s UUID -o value /dev/sda)
if [ -z "$UUID" ]; then
  echo "Erreur lors de la récupération de l'UUID de la clé USB."
  exit 1
fi
echo "UUID=$UUID /media/usb ext4 defaults,noatime 0 0" | sudo tee -a /etc/fstab
sudo mkdir -p /media/usb
sudo mount -a
if [ $? -eq 0 ]; then
  echo "Configuration de la clé USB terminée avec succès."
else
  echo "Erreur lors de la configuration de la clé USB."
fi

# Ajoutez les commandes de sauvegarde à crontab
(crontab -l ; echo "# Backup quotidien à 3h
0 3 * * * mkdir -p /media/usb/backup_full && mkdir -p /media/usb/backup_incremental/\$(date +\%Y-\%m-\%d) && touch /media/usb/backup_incremental/\$(date +\%Y-\%m-\%d)/dummy
0 3 * * * [ \"\$(ls -A /media/usb/backup_full)\" ] || rsync -aAXv --delete --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found} / /media/usb/backup_full && echo \"Sauvegarde complète du système terminée avec succès.\" | mail -s \"Rapport de sauvegarde complète\" baudoux.sebastien@gmail.com
0 3 * * * rsync -aAXv --delete --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found} --link-dest=/media/usb/backup_full / /media/usb/backup_incremental/\$(date +\%Y-\%m-\%d) && echo \"Sauvegarde incrémentale du système terminée avec succès.\" | mail -s \"Rapport de sauvegarde incrémentale\" baudoux.sebastien@gmail.com") | crontab -

# Ajoutez les commandes de mise à jour à crontab
(crontab -l ; echo "# Mise à jour quotidienne à 4h
0 4 * * * sudo apt update -y && sudo apt upgrade -y && echo \"Mise à jour du système terminée avec succès.\" | mail -s \"Rapport de mise à jour\"
0 4 * * * sudo apt autoremove -y && echo \"Nettoyage du système terminé avec succès.\" | mail -s \"Rapport de nettoyage\"") | crontab -

# Ajoutez les commandes de redémarrage à crontab
(crontab -l ; echo "# Redémarrage quotidien à 5h
0 5 * * * sudo reboot && echo \"Redémarrage du système terminé avec succès.\" | mail -s \"Rapport de redémarrage\"") | crontab -

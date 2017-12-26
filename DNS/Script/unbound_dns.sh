#!/bin/bash

###
## Script de lancement tous les 2 jours à 03h30
## Cron :
## 30 3 */2 * * sudo bash /home/pi/Desktop/DNS/Script/unbound_dns.sh
###
#Mise à l'heure
# Une synchro de l'heure semble nécessaire pour pouvoir
# télécharger les fichiers depuis Github.
sudo ntpdate 0.ch.pool.ntp.org
#Arrêt d'Unbound
sudo service unbound stop
#Téléchargement des sources
python /home/pi/Desktop/DNS/generate-domains-blacklist.py > /home/pi/Desktop/DNS/temp/ads.conf
sleep 5
#Suppression des lignes non-essentielles (commentaires, etc.)
sed -i '/^$/d;/#/d;s/www\.//' -i /home/pi/Desktop/DNS/temp/ads.conf
sleep 5
#Suppression des doublons
sort -u /home/pi/Desktop/DNS/temp/ads.conf > /home/pi/Desktop/DNS/temp/ads_temp.conf
#Suppression de l'ancien fichier ads.conf
sudo chown pi:pi /var/lib/unbound/ads.conf
rm /var/lib/unbound/ads.conf
sleep 5
#Mise en page du futur ads.conf
for a in `cat /home/pi/Desktop/DNS/temp/ads_temp.conf | dos2unix`; do
echo 'local-zone: "'$a'" redirect'
echo 'local-data: "'$a' A 0.0.0.0"'
done >> /var/lib/unbound/ads.conf
sleep 5
#Confirmation du propriétaire et des droits
sudo chown root:root /var/lib/unbound/ads.conf
sudo chmod 644 /var/lib/unbound/ads.conf
#Suppression des fichiers temporaires
rm -rf /home/pi/Desktop/DNS/temp/*
#Redémarrage d'Unbound
sudo service unbound restart
#Rapport sur log et fin du script
echo "Rapport de lancement du $(date)" >> /home/pi/Desktop/DNS/Logs/Process.log
exit

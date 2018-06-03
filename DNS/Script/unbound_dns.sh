#!/bin/bash

###
## Script de lancement tous les 2 jours à 03h30
## Cron sous Sudo: 30 3 */2 * * bash /home/pi/Desktop/DNS/unbound_dns.sh
###
#Mise à l'heure
sudo ntpdate 0.ch.pool.ntp.org
#Arrêt d'Unbound
sudo service unbound stop
#Suppression du fichier actuel
sudo chown pi:pi /var/lib/unbound/ads.conf
rm /var/lib/unbound/ads.conf
#Téléchargement des sources
wget -P /home/pi/Desktop/DNS/temp http://someonewhocares.org/hosts/zero/hosts
mv /home/pi/Desktop/DNS/temp/hosts /home/pi/Desktop/DNS/temp/hosts.txt
sleep 1
wget -P /home/pi/Desktop/DNS/temp http://1hosts.cf
mv /home/pi/Desktop/DNS/temp/index.html /home/pi/Desktop/DNS/temp/OneHosts.txt
sleep 1
wget -P /home/pi/Desktop/DNS/temp/ https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
sleep 1
wget -P /home/pi/Desktop/DNS/temp/ https://raw.githubusercontent.com/HexxiumCreations/threat-list/gh-pages/hexxiumthreatlist.txt
#Suppression des lignes non-essentielles (commentaires, etc.)
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/pi/Desktop/DNS/temp/malwaredomains_full.txt
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/pi/Desktop/DNS/temp/hexxiumthreatlist.txt
sleep 5
#Génération du listing
python /home/pi/Desktop/DNS/generate-domains-blacklist.py > /home/pi/Desktop/DNS/temp/ads.conf
#Suppression des lignes non-essentielles (commentaires, etc.)
sed -i '/^$/d;/#/d;s/www\.//' -i /home/pi/Desktop/DNS/temp/ads.conf
#Suppression des doublons
sort -u /home/pi/Desktop/DNS/temp/ads.conf > /home/pi/Desktop/DNS/temp/ads_temp.conf
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

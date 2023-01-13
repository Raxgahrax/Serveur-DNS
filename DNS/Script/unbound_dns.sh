#!/bin/bash

###
## Script de lancement tous les 2 jours à 03h30
## Cron sous Sudo: 30 3 */2 * * bash /home/pi/Desktop/DNS/unbound_dns.sh
## https://nlnetlabs.nl/documentation/unbound/howto-optimise/
###

#Variable
var="/var/lib/unbound/ads.conf"

#Mise à l'heure
sudo service ntp stop
sudo ntpdate pool.ntp.org
sudo service ntp start
#Arrêt d'Unbound
sudo service unbound stop
#Copie fichier actuel
sudo cp /var/lib/unbound/ads.conf /home/odroid/Bureau/DNS/local/ads.conf_old
#Modification du propriétaire et suppression du fichier actuel
sudo chown odroid:odroid /var/lib/unbound/ads.conf
sudo chown odroid:odroid /home/odroid/Bureau/DNS/local/ads.conf_old
rm /var/lib/unbound/ads.conf
#Téléchargement des sources
#Sources Up
wget -P /home/odroid/Bureau/DNS/temp http://someonewhocares.org/hosts/zero/hosts
mv /home/odroid/Bureau/DNS/temp/hosts /home/odroid/Bureau/DNS/temp/SomeoneWhoCares_hosts.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://raw.githubusercontent.com/HexxiumCreations/threat-list/gh-pages/hexxiumthreatlist.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt
#Sources Down
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://gitlab.com/CHEF-KOCH/cks-filterlist/-/raw/master/hosts/Game.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://gitlab.com/CHEF-KOCH/cks-filterlist/-/raw/master/hosts/Ads-tracker.txt
#Suppression des lignes non-essentielles (commentaires, etc.)
sleep 5
#sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/odroid/Bureau/DNS/temp/malwaredomains_full.txt
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/odroid/Bureau/DNS/local/Malwaredomains_full.txt
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/odroid/Bureau/DNS/temp/hexxiumthreatlist.txt
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//; s/^@@||//' /home/odroid/Bureau/DNS/temp/SmartTV-AGH.txt
sleep 5
#Génération du listing
python2.7 /home/odroid/Bureau/DNS/generate-domains-blacklist.py > /home/odroid/Bureau/DNS/temp/ads.conf
#Suppression des lignes non-essentielles (commentaires, etc.)
sed -i '/^$/d;/#/d;s/www\.//' -i /home/odroid/Bureau/DNS/temp/ads.conf
#Suppression des doublons
sort -u /home/odroid/Bureau/DNS/temp/ads.conf > /home/odroid/Bureau/DNS/temp/ads_temp.conf
sleep 5
#Mise en page du futur ads.conf
for a in `cat /home/odroid/Bureau/DNS/temp/ads_temp.conf | dos2unix`; do
echo 'local-zone: "'$a'" redirect'
echo 'local-data: "'$a' A 0.0.0.0"'
done >> /var/lib/unbound/ads.conf
sleep 5
#Confirmation du proprietaire et des droits
sudo chown root:root /var/lib/unbound/ads.conf
sudo chmod 644 /var/lib/unbound/ads.conf
#Suppression des fichiers temporaires
rm -rf /home/odroid/Bureau/DNS/temp/*
if [ -s "$var" ]
then
   echo "Fichier non vide !"
   #Redémarrage d'Unbound
   sudo service unbound restart
   #Rapport sur log et fin du script
   echo "Rapport de lancement du $(date)" >> /home/odroid/Bureau/DNS/Logs/Process.log
   exit
else
   echo "Fichier vide !"
   #Suppression fichier vide
   sudo chown odroid:odroid /var/lib/unbound/ads.conf
   rm /var/lib/unbound/ads.conf
   #Restauration fichier de sauvegarde et fin du script
   sudo cp /home/odroid/Bureau/DNS/local/ads.conf_old /var/lib/unbound/ads.conf
   sudo chown root:root /var/lib/unbound/ads.conf
   #Redémarrage d'Unbound
   sudo service unbound restart   
   exit
fi

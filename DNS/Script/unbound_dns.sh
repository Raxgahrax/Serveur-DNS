#!/bin/bash

###
## Script de lancement tous les 2 jours à 03h30
## Cron sous Sudo: 30 3 */2 * * bash /home/pi/Desktop/DNS/unbound_dns.sh
## https://nlnetlabs.nl/documentation/unbound/howto-optimise/
###
#Mise à l'heure
sudo ntpdate 0.ch.pool.ntp.org
#Arrêt d'Unbound
sudo service unbound stop
#Suppression du fichier actuel
sudo chown odroid:odroid /var/lib/unbound/ads.conf
rm /var/lib/unbound/ads.conf
#Téléchargement des sources
wget -P /home/odroid/Bureau/DNS/temp http://someonewhocares.org/hosts/zero/hosts
mv /home/odroid/Bureau/DNS/temp/hosts /home/odroid/Bureau/DNS/temp/hosts.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp http://1hos.cf
sleep 1
wget -P /home/odroid/Bureau/DNS/temp http://rlwpx.free.fr/WPFF/htrc.7z
7z x /home/odroid/Bureau/DNS/temp/htrc.7z
mv /home/odroid/Hosts.trc /home/odroid/Bureau/DNS/temp/Hosts.trc
#https://t.me/badmojr
#wget -P /home/pi/Desktop/DNS/temp http://1hosts.cf
mv /home/odroid/Bureau/DNS/temp/index.html /home/odroid/Bureau/DNS/temp/OneHosts.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
sleep 1
wget -P /home/odroid/Bureau/DNS/temp/ https://raw.githubusercontent.com/HexxiumCreations/threat-list/gh-pages/hexxiumthreatlist.txt
#Suppression des lignes non-essentielles (commentaires, etc.)
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/odroid/Bureau/DNS/temp/malwaredomains_full.txt
sleep 5
sed -i '/^[[!]/d; s/^||//; s/\^$//' /home/odroid/Bureau/DNS/temp/hexxiumthreatlist.txt
sleep 5
#Génération du listing
python /home/odroid/Bureau/DNS/generate-domains-blacklist.py > /home/odroid/Bureau/DNS/temp/ads.conf
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
#Confirmation du propriétaire et des droits
sudo chown root:root /var/lib/unbound/ads.conf
sudo chmod 644 /var/lib/unbound/ads.conf
#Suppression des fichiers temporaires
rm -rf /home/odroid/Bureau/DNS/temp/*
#Redémarrage d'Unbound
sudo service unbound restart
#Rapport sur log et fin du script
echo "Rapport de lancement du $(date)" >> /home/odroid/Bureau/DNS/Logs/Process.log
exit

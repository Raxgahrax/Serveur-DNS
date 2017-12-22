Si vous utilisez Unbound comme serveur DNS local, et que vous utilisez plusieurs sources externes pour vos règles de filtrages.
Voici un système totalement automatique, repris sur une partie du fonctionnement de DNSCrypt, pour que vous n'ayez plus à vous préoccuper de la mise à jour de vos barrières DNS.

Il existe également une partie pour effacer certains domaines qui pourraient avoir été rajoutés à la liste finale de filtrage, et dont vous souhaiteriez pouvoir garder l'accès malgré tout.

Exemple : doctissimo.fr. Il est présent dans les "fake news" trouvés par Steven Black; ajouter ce domaine à votre whitelist et il sera de nouveau accessible ainsi que ses sous-domaines, ceci malgré sa présence dans les listings-sources.
Le fichier de filtrage utilisé par Unbound étant la propriété de root:root, vous devrez donc lancer le cron de "unbound_dns.sh" depuis ce compte sous peine d'avoir des erreurs de droit d'accès et d'écriture.

Vous aurez également 3 chemins à modifier pour que tout fonctionne : "generate-domains-blacklist.py" (lignes 128 et 130) et "domains-blacklist.conf" (ligne 26).

Libre à vous ensuite de modifier les divers urls-sources suivant vos besoins, mais je pense avoir créé quelque chose d'intéressant.

# Génération du Fichier ads.conf pour Unbound DNS

Ce projet comprend des scripts pour générer et mettre à jour le fichier `ads.conf`, utilisé par le serveur DNS Unbound pour bloquer l'accès à des domaines malveillants.

## Utilisation du Script

### Script Bash (`unbound_dns.sh`)

Le script bash principal est utilisé comme suit :

1. **Exécution :** L'utilisateur doit exécuter `unbound_dns.sh` pour générer le fichier `ads.conf`.
2. **Sources de Données :** Le script utilise des listes locales et distantes pour créer une liste consolidée de domaines malveillants.
3. **Fichiers Additionnels :** Les domaines à exclure peuvent être spécifiés dans le fichier `domains-whitelist.txt`.

### Configuration des Sources

#### Fichier `domains-blacklist.conf`

Ce fichier de configuration détaille les sources de données pour la génération de la liste noire. Il inclut :

- **URLs Distants :** URLs pointant vers des sources en ligne pour récupérer des listes de domaines malveillants.
- **Fichiers Locaux :** Références à des fichiers locaux contenant des listes, présentes dans le dossier `local`, de domaines à bloquer.

#### Fichier `domains-blacklist-local-additions.txt`

Ce fichier contient des ajouts locaux spécifiques à la liste noire de domaines. Les domaines répertoriés ici seront également bloqués.

## Compréhension des Fichiers de Configuration

Le fichier `domains-blacklist.conf` est crucial pour spécifier les sources de données à utiliser lors de la génération de la liste noire. Il combine des données provenant de sources en ligne et locales pour créer une liste complète de domaines à bloquer.

---

**Note :** Avant d'exécuter le script bash, assurez-vous que les chemins de fichiers et les références locales sont correctement définis dans les fichiers de configuration pour une génération précise du fichier `ads.conf`.

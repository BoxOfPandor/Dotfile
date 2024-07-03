#!/bin/bash

# Étape 1: Vérifier si le nom du projet est fourni
if [ -z "$1" ]; then
  echo "Erreur: Nom du projet non fourni."
  echo "Usage: $0 <nom_du_projet>"
  exit 1
fi

# Étape 2: Créer le dossier principal du projet
nom_projet="$1"
mkdir -p "$nom_projet/src/config" "$nom_projet/src/middleware" "$nom_projet/src/routes"

# Étape 3 et 4: Créer les fichiers vides
touch "$nom_projet/src/config/db.js"
touch "$nom_projet/src/middleware/auth.js"
touch "$nom_projet/src/middleware/error.js"

# Nouvelle étape: Créer un fichier .gitignore avec le contenu nécessaire
cat <<EOF >"$nom_projet/.gitignore"
# Dépendances
/node_modules

# Fichiers de configuration d'environnement
.env

# Dossiers de logs
logs
*.log
npm-debug.log*

# Répertoires de l'IDE et fichiers temporaires
.idea
.vscode
*.swp
*.swo
*~

# Dossier de build
/dist

# Fichiers de debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

# Étape 5: Afficher un message de succès
echo "Architecture du projet '$nom_projet' créée avec succès."
echo ".gitignore généré."

# Étape finale: Initialiser npm dans le dossier du projet
cd "$nom_projet"
npm init -y

# Retourner dans le dossier parent après l'initialisation
cd ..

echo "npm initialisé avec succès dans '$nom_projet'."
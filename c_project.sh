#!/bin/bash

# Étape 1: Vérifier si le nom du projet est fourni
if [ -z "$1" ]; then
  echo "Erreur: Nom du projet non fourni."
  echo "Usage: $0 <nom_du_projet>"
  exit 1
fi

# Étape 2: Créer le dossier principal du projet
nom_projet="$1"
mkdir -p "$nom_projet/src" "$nom_projet/include" "$nom_projet/obj" "$nom_projet/lib" "$nom_projet/test"

# Étape 3: Créer un fichier main.c exemple dans src/
cat <<EOF >"$nom_projet/src/main.c"
#include <stdio.h>

int main() {
    printf("Hello, World!\\n");
    return 0;
}
EOF

# Étape 4: Appeler automakefile.sh pour générer le Makefile
# Assurez-vous que automakefile.sh est dans votre PATH ou spécifiez le chemin complet
automakefile.sh "$nom_projet"

# Étape 5: Créer un fichier .gitignore
cat <<EOF >"$nom_projet/.gitignore"
# Objets et binaires
*.o
*.out
$nom_projet/main

# Fichiers temporaires
*~
EOF

# Étape 6: Afficher un message de succès
echo "Projet C '$nom_projet' créé avec succès."
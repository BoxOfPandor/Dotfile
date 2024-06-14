#!/bin/bash

# Récupérer le numéro de version de Fedora
fedora_version=$(grep -oP '(?<=VERSION_ID=)[0-9]+' /etc/os-release)

# Vérifier si la version de Fedora est 38 ou supérieure
if [ "$fedora_version" -lt 38 ]; then
    echo -e "\033[31mCe script nécessite Fedora 38 ou une version ultérieure.\033[0m"
    exit 1
fi

##############################" Dump epitech "##############################
echo -e "\033[0;34mInstallation et configuration du dump Epitech\033[0m"
# Téléchargement du dump
git clone https://github.com/Epitech/dump.git ~/dump
# Aller dans le dossier dump
cd ~/dump
# Lancement du script d'installation
sudo ./install_packages_dump.sh
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Mango & Ananas "##############################
echo -e "\033[0;34mInstallation de Mango et Ananas\033[0m"
# Installation style cheker
git clone https://github.com/Epitech/coding-style-checker.git ~/coding-style-checker
cd ~/coding-style-checker
sudo ./coding-style.sh
rm -rf ~/coding-style-checker
# Installation de Mango
sudo rm /bin/mango; sudo wget https://raw.githubusercontent.com/Clement-Z4RM/Mango/main/mango.py -O /bin/mango && sudo chmod +x /bin/mango
# Installation de Ananas
curl -sLO 3z.ee/ananas && bash ananas

echo -e "\033[32mLe script a terminé avec succès.\033[0m"

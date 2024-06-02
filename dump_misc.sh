#!/bin/bash

# Récupérer le numéro de version de Fedora
fedora_version=$(grep -oP '(?<=VERSION_ID=)[0-9]+' /etc/os-release)

# Vérifier si la version de Fedora est 38 ou supérieure
if [ "$fedora_version" -lt 38 ]; then
    echo -e "\033[31mCe script nécessite Fedora 38 ou une version ultérieure.\033[0m"
    exit 1
fi

##############################" Brave "##############################
echo -e "\033[0;34mInstallation de Brave\033[0m"
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser
clear

##############################" Lazy Git "##############################
echo -e "\033[0;34mInstallation de LazyGit\033[0m"
# enable copr
sudo dnf copr enable atim/lazygit -y
# Installation de LazyGit
sudo dnf install lazygit -y
clear
echo -e "\033[0;32mFinish Part\033[0m"

##############################" JetBrain "##############################
echo -e "\033[0;34mInstallation de Toolbox\033[0m"
# Téléchargement de l'archive
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz
# Installation de JetBrains Toolbox
sudo tar -xzf jetbrains-toolbox-2.3.1.31116.tar.gz -C /opt
# Suppression de l'archive
rm jetbrains-toolbox-2.3.1.31116.tar.gz
clear
echo -e "\033[0;32mFinish Part\033[0m"

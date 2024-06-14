#!/bin/bash

# Récupérer le numéro de version de Fedora
fedora_version=$(grep -oP '(?<=VERSION_ID=)[0-9]+' /etc/os-release)

# Vérifier si la version de Fedora est 38 ou supérieure
if [ "$fedora_version" -lt 38 ]; then
    echo -e "\033[31mCe script nécessite Fedora 38 ou une version ultérieure.\033[0m"
    exit 1
fi

##############################" Système "##############################
# Mise à jour du système
echo -e "\033[0;34mMise a jour et upgrade du system\033[0m"
sudo dnf update -y && sudo dnf upgrade -y
# Installation de logiciels
sudo dnf install -y \
    neovim \
    git \
    wget \
    zsh \
    htop \
    tmux \
    flatpak \
    zellij
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Docker "######################################
echo -e "\033[0;32mInstallation de Docker\033[0m"
# Remove old versions
sudo dnf remove docker \
         docker-client \
         docker-client-latest \
         docker-common \
         docker-latest \
         docker-latest-logrotate \
         docker-logrotate \
         docker-selinux \
         docker-engine-selinux \
         docker-engine
# Setup the repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# Installation de Docker
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Démarrage de Docker
sudo systemctl start docker
sudo systemctl enable docker

echo -e "\033[0;32mFinish Part\033[0m"

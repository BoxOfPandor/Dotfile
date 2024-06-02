#!/bin/bash

# Récupérer le numéro de version de Fedora
fedora_version=$(grep -oP '(?<=VERSION_ID=)[0-9]+' /etc/os-release)

# Vérifier si la version de Fedora est 38 ou supérieure
if [ "$fedora_version" -lt 38 ]; then
    echo -e "\033[31mCe script nécessite Fedora 38 ou une version ultérieure.\033[0m"
    exit 1
fi

##############################" FlatPak "##############################
echo -e "\033[0;32mInstallation des apps Flatpak\033[0m"
# Ajout du dépôt Flathub (dépôt central de Flatpak)
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Installation d'applications Flatpak
flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub org.videolan.VLC
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.obsproject.Studio
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub org.fedoraproject.MediaWriter
flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install -y flathub org.gnome.Boxes
flatpak install -y flathub io.github.flattool.Warehouse
flatpak install -y flathub com.raggesilver.BlackBox
echo -e "\033[0;32mFinish Part\033[0m"

echo -e "\033[32mLe script a terminé avec succès.\033[0m"

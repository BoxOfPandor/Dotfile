#!/bin/bash

# Mise à jour du système
sudo dnf update -y && sudo dnf upgrade -y

# Installation de logiciels
sudo dnf install -y \
    git \
    nvim \
    wget \
    zsh \
    htop \
    tmux \
    flatpak \
    zellij \
    

##############################" zoxide "##############################
# Installation de zoxide
sudo dnf install -y zoxide
# Ajout de zoxide à la configuration de Zsh
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

##############################" Docker "######################################
# Installation de Docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
# Démarrage de Docker
sudo systemctl start docker
sudo systemctl enable docker

##############################" FlatPak "##############################
# Ajout du dépôt Flathub (dépôt central de Flatpak)
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Installation d'applications Flatpak
flatpak install -y flathub com.visualstudio.code
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
flatpak install -y flathub com.getpostman.Postman

##############################" JetBrain "##############################
# Téléchargement de l'archive
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz
# Installation de JetBrains Toolbox
sudo tar -xzf jetbrains-toolbox-2.3.1.31116.tar.gz -C /opt
# Suppression de l'archive
rm jetbrains-toolbox-2.3.1.31116.tar.gz


##############################" Oh My Zsh "##############################
# Definir Zsh comme shell par défaut
chsh -s $(which zsh)
# Installation de Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Instalation du thème Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cat ZSH_THEME="powerlevel10k/powerlevel10k" >> ~/.zshrc
# Installation des plugins Zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

##############################" Dump epitech "##############################
# Téléchargement du dump
git clone https://github.com/Epitech/dump.git ~/dump
# Aller dans le dossier dump
cd ~/dump
# Lancement du script d'installation
sudo ./install_packages_dump.sh

##############################" Neovim "##############################
mv ~/.config/nvim ~/.config/nvim.backup
rm -rf ~/.local/share/nvim
git clone -b v2.0 https://github.com/NvChad/NvChad ~/.config/nvim --depth 1


source ~/.zshrc
echo "Installation terminée!"

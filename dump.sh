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
    git \
    nvim \
    wget \
    zsh \
    htop \
    tmux \
    flatpak \
    zellij \
echo -e "\033[0;32mFinish Part\033[0m"

##############################" zoxide "##############################
echo -e "\033[0;32mInstallation de zoxide\033[0m"
# Installation de zoxide
sudo dnf install -y zoxide
# Ajout de zoxide à la configuration de Zsh
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
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

##############################" FlatPak "##############################
echo -e "\033[0;32mInstallation des apps Flatpak\033[0m"
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
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Lazy Git "##############################
echo -e "\033[0;34mInstallation de LazyGit\033[0m"
# enable copr
sudo dnf copr enable atim/lazygit -y
# Installation de LazyGit
sudo dnf install lazygit -y
echo -e "\033[0;32mFinish Part\033[0m"

##############################" JetBrain "##############################
echo -e "\033[0;34mInstallation de Toolbox\033[0m"
# Téléchargement de l'archive
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz
# Installation de JetBrains Toolbox
sudo tar -xzf jetbrains-toolbox-2.3.1.31116.tar.gz -C /opt
# Suppression de l'archive
rm jetbrains-toolbox-2.3.1.31116.tar.gz
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Oh My Zsh "##############################
echo -e "\033[0;34mInstallation et configuration de OMZ\033[0m"
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
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Dump epitech "##############################
echo -e "\033[0;34mInstallation et configuration du dump Epitech\033[0m"
# Téléchargement du dump
git clone https://github.com/Epitech/dump.git ~/dump
# Aller dans le dossier dump
cd ~/dump
# Lancement du script d'installation
sudo ./install_packages_dump.sh
echo -e "\033[0;32mFinish Part\033[0m"

##############################" CSFML "##############################
echo -e "\033[0;34mInstallation de la CSFML\033[0m"
# Installation des dépendances pour SFML et CSFML
sudo dnf install -y cmake gcc gcc-c++ libX11-devel libXrandr-devel libXcursor-devel libXi-devel libXext-devel mesa-libGL-devel mesa-libEGL-devel systemd-devel
# Télécharger et installer SFML
git clone https://github.com/SFML/SFML.git
cd SFML
cmake .
make
sudo make install
cd ..
# Télécharger et installer CSFML
git clone https://github.com/SFML/CSFML.git
cd CSFML
cmake .
make
sudo make install
cd ..
echo -e "\033[0;32mFinish Part\033[0m"

##############################" Neovim "##############################
echo -e "\033[0;34m*configuration de neovim\033[0m"
mv ~/.config/nvim ~/.config/nvim.backup
rm -rf ~/.local/share/nvim
git clone -b v2.0 https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
echo -e "\033[0;32mFinish Part\033[0m"

source ~/.zshrc
echo -e "\033[32mLe script a terminé avec succès.\033[0m"

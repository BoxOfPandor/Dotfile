#!/bin/bash

# Récupérer le numéro de version de Fedora
fedora_version=$(grep -oP '(?<=VERSION_ID=)[0-9]+' /etc/os-release)

# Vérifier si la version de Fedora est 38 ou supérieure
if [ "$fedora_version" -lt 38 ]; then
    echo -e "\033[31mCe script nécessite Fedora 38 ou une version ultérieure.\033[0m"
    exit 1
fi

##############################" Oh My Zsh "##############################
echo -e "\033[0;34mInstallation et configuration de OMZ\033[0m"
# Install ZSH
sudo dnf install -y zsh
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
clear
echo -e "\033[0;32mFinish Part\033[0m"

##############################" zoxide "##############################
echo -e "\033[0;32mInstallation de zoxide\033[0m"
# Installation de zoxide
sudo dnf install -y zoxide
# Ajout de zoxide à la configuration de Zsh
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
source ~/.zshrc
echo -e "\033[32mLe script a terminé avec succès.\033[0m"


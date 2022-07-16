#!/bin/bash

## COLORS
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'

## CONSTANTS
ZSH_DOT_FILE="$HOME/.zshrc"
I3_CONFIG="$HOME/.config/i3"

# Basics
sudo apt-get install -y curl git terminator

if ! command -v vim &> /dev/null
then
    echo -e "VIM could not be found. Installing"
    sudo apt-get install -y vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
    ln -s $HOME/dotfiles/.vim/colors/molokai.vim $HOME/.vim/colors/molokai.vim
    # Don't forget run :PluginInstall !!!
else
    echo -e "${GREEN} * VIM IS INSTALLED${NC}"
fi

if ! command -v zsh &> /dev/null
then
    echo -e "ZHS could not be found. Installing"
    sudo apt-get install -y zsh fonts-powerline
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    rm $ZSH_DOT_FILE
else
    echo -e "${GREEN} * ZSH IS INSTALLED${NC}"
fi


if [ -f "$ZSH_DOT_FILE" ]
then
    echo -e "${GREEN} * ${ZSH_DOT_FILE} exists ${NC}"
else
    ln -s $HOME/dotfiles/.zshrc $ZSH_DOT_FILE
fi


if ! command -v i3 &> /dev/null
then
    echo -e "I3 could not be found. Installing"
    sudo apt-get install -y i3 gnome-screenshot feh
    rm $I3_CONFIG
    # sudo apt-get install polybar rofi
    # git submodule add https://github.com/nimishgo/i3wm-themes.git
    # mkdir $HOME/.config/polybar
    # git submodule init
    # git submodule update
    # cp $HOME/dotfiles/i3wm-themes/Subway/.i3/config $HOME/.config/i3/config
    # cp $HOME/dotfiles/i3wm-themes/Subway/.config/polybar/* $HOME/.config/polybar/
else
    echo -e "${GREEN} * I3 IS INSTALLED${NC}"
fi

if [ -e "$I3_CONFIG" ]
then
    echo -e "${GREEN} * ${I3_CONFIG} exists ${NC}"
else
    mkdir $I3_CONFIG
    ln -s $HOME/dotfiles/i3/config $I3_CONFIG/config
    ln -s $HOME/dotfiles/i3/compton.conf $I3_CONFIG/compton.conf
fi

if ! command -v pyenv &> /dev/null
then
    echo -e "PYENV could not be found. Installing"
    sudo apt-get install -y zlib1g-dev make build-essential libssl-dev libffi-dev git libbz2-dev libsqlite3-dev libreadline-dev libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    pyenv install 2.7:latest
    pyenv install 3.6:latest
    
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
else	
    echo -e "${GREEN} * PYENV IS INSTALLED${NC}"
fi

if ! command -v docker &> /dev/null
then
    echo -e "DOCKER could not be found. Installing"
    sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo docker run hello-world
    sudo groupadd docker
    sudo usermod -aG docker $USER
else
    echo -e "${GREEN} * DOCKER IS INSTALLED${NC}"
fi

ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig

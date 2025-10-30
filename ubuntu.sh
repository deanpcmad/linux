#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt install -y wget curl htop btop git zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common apt-transport-https libffi-dev git htop btop wget curl nano automake libmagickwand-dev imagemagick zsh python3 ffmpeg libvips42 mysql-client libmysqlclient-dev apt-transport-https ca-certificates gnupg unzip libpq-dev

# Mise
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop

# VS Code
if [ ! -f /etc/apt/keyrings/packages.microsoft.gpg ] || [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
  [ -f /etc/apt/keyrings/packages.microsoft.gpg ] && sudo rm /etc/apt/keyrings/packages.microsoft.gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
fi
sudo apt update && sudo apt install -y code

# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker dean

# Docker databases
sudo wget -O /opt/docker-compose.yml https://raw.githubusercontent.com/deanpcmad/fedora/refs/heads/main/docker-compose.yml
sudo docker compose -f /opt/docker-compose.yml up -d

mise use -g bun@latest
mise use -g ruby@latest
mise use -g node@lts

# Zsh
sudo apt install zsh -y

# Oh my Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Try
mkdir -p ~/.local/bin
curl -sL https://raw.githubusercontent.com/tobi/try/refs/heads/main/try.rb > ~/.local/bin/try.rb
chmod +x ~/.local/bin/try.rb
echo 'eval "$(~/.local/bin/try.rb init ~/code/tries)"' >> ~/.zshrc

# Zsh Plugin
git clone https://github.com/deanpcmad/zsh-plugin.git ~/.oh-my-zsh/custom/plugins/deanpcmad
# Then edit .zshrc to set plugins. The git plugin isn't needed: plugins=(mise deanpcmad)

ln -s ~/.oh-my-zsh/custom/plugins/deanpcmad/gitconfig ~/.gitconfig
ln -s ~/.oh-my-zsh/custom/plugins/deanpcmad/gitignore ~/.gitignore
ln -s ~/.oh-my-zsh/custom/plugins/deanpcmad/irbrc ~/.irbrc
ln -s ~/.oh-my-zsh/custom/plugins/deanpcmad/gemrc ~/.gemrc

# Reload Zsh
source ~/.zshrc

# Nextcloud
sudo add-apt-repository -y ppa:nextcloud-devs/client
sudo apt install -y nextcloud-client

# Flatpak
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install com.spotify.Client
flatpak install md.obsidian.Obsidian

# 1Password
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
sudo apt install -f ./1password-latest.deb
rm 1password-latest.deb

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Nord VPN
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh) -p nordvpn-gui

# ngrok
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install -y ngrok

# Nerd Font
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -rf CascadiaMono.zip CascadiaFont
# Then reopen terminal, create a profile with the NerdFont

# MPV
sudo apt install -y mpv

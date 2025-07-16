#!/usr/bin/env bash

echo "Looking for Homebrew..."
if test ! $(which brew); then
    echo "Installing homebrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
echo "Homebrew Installed ✅"

echo "Installing Brew packages from Brewfile..."
brew bundle --file=Brewfile
echo "Packages installed 📦"

# Stow directories
stow git
stow ssh
stow zsh

# Install useful key bindings and fuzzy completion
$(brew --prefix)/opt/fzf/install

# Install fzf terminal integrations
/usr/local/opt/fzf/install

# zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
    echo "zsh-autosuggestions is already installed ✅" #duplicated code
fi

# zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
    echo "zsh-syntax-highlighting is already installed ✅" #duplicated code
fi

# fzf-zsh-plugin
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin ]; then
    git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
    else
    echo "fzf-zsh-plugin is already installed ✅" #duplicated code
fi

# Install Meslo Nerd Font 
brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font


# If the current default shell is not zsh, switch to it
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to zsh 🔀"
  chsh -s /bin/zsh
else
  echo "Default shell is already zsh ✅"
fi

# Install Oh My ZSH. Install last because it auto detects .zshrc files and tries to switch
echo "Installing Oh My ZSH and configuring plugins 🛠"
if [ ! -d "/Users/${USER}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My ZSH is already installed ✅" #duplicated code
fi

echo "Cleaning up 🧹"
brew cleanup

echo "Install complete ✅ Reset terminal session for changes to take effect."

#!/usr/bin/env bash

echo "Looking for Homebrew..."
if test ! $(which brew); then
    echo "Installing homebrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
echo "Homebrew Installed ✅"

echo "Installing Brew packages from Brewfile..."
brew bundle --file=Brewfile
echo "Packages installed 📦"

# If the current default shell is not zsh, switch to it
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to zsh 🔀"
  chsh -s /bin/zsh
else
  echo "Default shell is already zsh ✅"
fi

# Install Oh My ZSH first (before stow symlinks .zshrc which sources it)
echo "Installing Oh My ZSH and configuring plugins 🛠"
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    # Remove incomplete oh-my-zsh dir if it exists (e.g. only custom/ from plugin clones)
    [ -d "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo "Oh My ZSH is already installed ✅"
fi

# zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
    echo "zsh-autosuggestions is already installed ✅"
fi

# zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
    echo "zsh-syntax-highlighting is already installed ✅"
fi

# fzf-zsh-plugin
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin ]; then
    git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
    else
    echo "fzf-zsh-plugin is already installed ✅"
fi

# Stow directories (after Oh My Zsh so .zshrc can source it)
# Back up existing ssh config if it's not already a symlink
# if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ]; then
#     mv "$HOME/.ssh/config" "$HOME/.ssh/config.bak"
# fi
stow ghostty
stow git
stow jj
# stow ssh
stow zsh

if [ -f /etc/arch-release ]; then
  stow hyprland
fi

stow -d . amp ghostty git jj zsh

# Install useful key bindings and fuzzy completion
$(brew --prefix)/opt/fzf/install

# Install fzf terminal integrations
/usr/local/opt/fzf/install

# Install Meslo Nerd Font 
brew install --cask font-meslo-lg-nerd-font

echo "Installing starship"
curl -sS https://starship.rs/install.sh | sh

# If for some reason it installed a ./.config/starship.toml... remove it for base styles
rm -f ~/.config/starship.toml

# Install LazyVim
echo "Installing LazyVim 🚀"
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
else
    echo "Neovim config already exists at ~/.config/nvim, skipping LazyVim install ✅"
fi

echo "Cleaning up 🧹"
brew cleanup

echo "Install complete ✅ Reset terminal session for changes to take effect."

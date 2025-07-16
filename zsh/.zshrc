export PATH="/Users/teyler-pe/.rbenv/shims:$PATH"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)
source $ZSH/oh-my-zsh.sh

# Homebrew
export PATH=/opt/homebrew/bin:$PATH

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Auto load nvm version on .nvmrc detection
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Language
export LANG=en_US.UTF-8

# rbenv
eval "$(rbenv init - zsh)"

# Starship
eval "$(starship init zsh)"

# Vim
export EDITOR='vim'
alias vim="nvim"
set -o vi

# Lazygit
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# Secrets
[[ -f ~/.secrets ]] && source ~/.secrets

# Poll Everywhere
alias cdpe="cd /Users/teyler-pe/github/polleverywhere"
alias cdra="cd /Users/teyler-pe/github/polleverywhere/rails_app"
alias cdsl="cd /Users/teyler-pe/github/polleverywhere/singularity"
alias cdar="cd /Users/teyler-pe/github/polleverywhere/artemis"

alias lvim="/Users/teyler-pe/.local/bin/lvim"

# pe2 cli
export PATH="$HOME/.pollev/bin:$PATH"

# Functions
alias yh="git rev-parse --verify HEAD | tr -d "\n" | pbcopy"

function coauth() {
  gh api repos/{owner}/{repo}/collaborators --paginate --jq '.[] | .login + " <" + .html_url + ">"' | fzf --multi | xargs -I _ printf "Co-authored-by: %s\n" "_"| pbcopy
}
function gspin() {
  if [ $# -ne 1 ]; then
    echo "Usage: gspin <branch_name>"
    return 1
  fi
  spinoff_from_branch=$(git branch --show-current)
  spinoff_from_reset_sha=$(git rev-parse origin/$spinoff_from_branch)
  git checkout -b $1
  git update-ref -m "gspin: moving $spinoff_from_branch to $spinoff_from_reset_sha" refs/heads/$spinoff_from_branch $spinoff_from_reset_sha
}

function gpop() {
  git stash list | fzf --preview 'git stash show --color -p $(cut -d: -f1 <<< {})'| cut -d: -f1 | xargs git stash pop
}

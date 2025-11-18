# Uncomment to profile
# zmodload zsh/zprof

export PATH="/Users/teyler-pe/.rbenv/shims:$PATH"

# Oh My Zsh

# https://scottspence.com/posts/speeding-up-my-zsh-shell#oh-my-zsh-5573--20
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  fzf-zsh-plugin
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=/opt/homebrew/bin:$PATH
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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

# jj
alias jk="jj undo"

# Poll Everywhere
alias cdpe="cd ~/github/polleverywhere"
alias cdra="cd ~/github/polleverywhere/rails_app"
alias cdsl="cd ~/teyler-pe/github/polleverywhere/singularity"
alias cdar="cd ~/github/polleverywhere/artemis"

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

# Uncomment to profile
# zprof

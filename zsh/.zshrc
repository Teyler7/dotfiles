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

# amp
export PATH="$HOME/.local/bin:$PATH"

# Language
export LANG=en_US.UTF-8

# rbenv
eval "$(rbenv init - zsh)"

# Cargo Bin
export PATH="$HOME/.cargo/bin:$PATH"

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

jmerge() {
  jj git fetch &&
  jj rebase -d "trunk()" || return $?

  local -a bookmarks=(${(f)"$(jj bookmark list -r @ -T 'name ++ "\n"' | grep -v '^push-' | sort -u)"})
  if (( ${#bookmarks} )); then
    jj git push ${bookmarks[@]/#/-b}
  else
    jj git push -c @
  fi &&

  USE_JJ=true bin/ci &&
  jj bookmark set main -r "latest(heads(::@ & ~empty()))" &&
  jj git push -b main || return $?

  if jj bookmark list | grep -q 'push-'; then
    jj bookmark delete glob:"push-*" &&
    jj git push --deleted
  fi
}

# Wrapper so `gh` works both in plain Git repos and jj workspaces (no .git dir)
function jh() {
  emulate -L zsh
  setopt pipefail

  local git_dir work_tree is_jj=0
  if git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null) \
     && work_tree=$(git rev-parse --show-toplevel 2>/dev/null); then
    # Check if this is actually a jj-managed repo
    if jj git root &>/dev/null; then
      is_jj=1
    fi
  else
    if ! git_dir=$(jj git root 2>/dev/null); then
      echo "jh: not inside a git or jj repository" >&2
      return 1
    fi
    is_jj=1
    if ! work_tree=$(jj workspace root 2>/dev/null); then
      work_tree=$(dirname "$git_dir")
    fi
  fi

  local head_file="$git_dir/HEAD"
  local head_contents restore_head=0 branch_commit branch_name

  if [[ -f $head_file ]]; then
    head_contents=$(<"$head_file")
    if [[ $head_contents != ref:\ * ]]; then
      # For jj repos, get current commit from jj; otherwise use HEAD file
      if (( is_jj )); then
        branch_commit=$(jj log -r @ --no-graph -T 'commit_id' 2>/dev/null)
      else
        branch_commit=${head_contents//$'\n'/}
      fi

      branch_name=$(
        GIT_DIR="$git_dir" git for-each-ref --format='%(refname:short)' \
          --points-at "$branch_commit" refs/heads 2>/dev/null | head -n1
      )

      if [[ -n $branch_name ]]; then
        printf 'ref: refs/heads/%s\n' "$branch_name" >| "$head_file"
        restore_head=1
      fi
    fi
  fi

  GIT_DIR="$git_dir" GIT_WORK_TREE="$work_tree" gh "$@"
  local exit_code=$?

  if (( restore_head )); then
    printf '%s\n' "$head_contents" >| "$head_file"
  fi

  return $exit_code
}

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

# postgresql
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Uncomment to profile
# zprof

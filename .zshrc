#
# ~/.zshrc
#

pdfgrep() {
    command pdfgrep -i $1 *
}

# aliases
source "$HOME/.aliases"

# history management
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# zsh options
setopt autocd
bindkey -e
zstyle :compinstall filename '/home/olepbr/.zshrc'
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# prompt design
# PROMPT='%F{green}%n%f%F{yellow}@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
PROMPT='%F{green}⚘%f %F{blue}%(5~|%-1~/…/%3~|%4~)%f '
RPROMPT='[%F{yellow}%?%f]'

# fzf extras
source "/usr/share/fzf/key-bindings.zsh"
source "/usr/share/fzf/completion.zsh"

# functions

function activate-venv() {
    local selected_env
    selected_env="$(ls $HOME/.virtualenvs/ | fzf)"
    if [ -n "$selected_env" ]; then
        source "$HOME/.virtualenvs/$selected_env/bin/activate"
    fi
}

function pr-checkout() {
  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}

function delete-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}

function gch() {
    local branch
    branch=$(git branch --all | fzf | tr -d '[:space:]')
    if [ -n "$branch" ]; then
      git checkout "$branch"
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export DARK_POINT="63.431010258431876 10.380130810237022"

export PATH="$HOME/.emacs.d/bin:$PATH"

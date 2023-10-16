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
source "/usr/share/doc/fzf/examples/completion.zsh"
source "/usr/share/doc/fzf/examples/key-bindings.zsh"

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
      git switch "$branch"
    fi
}

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"

PATH="/home/olepbr/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/olepbr/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/olepbr/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/olepbr/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/olepbr/perl5"; export PERL_MM_OPT;

# opam configuration
[[ ! -r /home/olepbr/.opam/opam-init/init.zsh ]] || source /home/olepbr/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

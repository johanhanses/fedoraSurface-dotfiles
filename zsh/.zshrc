# --- History -----------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=25000
SAVEHIST=25000
setopt share_history inc_append_history hist_ignore_dups hist_ignore_space extended_history

# --- Basics ------------------------------------------------------------------
bindkey -e
setopt auto_cd interactive_comments
export EDITOR=nvim VISUAL=nvim
typeset -U path
path=(~/.local/bin $path)

export REPOS="$HOME/Repos"
export GHREPOS="$REPOS/github.com/johanhanses"
export DOTFILES="$GHREPOS/fedoraSurface-dotfiles"
export SECOND_BRAIN="$GHREPOS/zettelkasten"
export XDG_CONFIG_HOME="$HOME/.config"

# --- Completion --------------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# --- Prompt: dir + git branch ------------------------------------------------
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f'
precmd() { vcs_info }
setopt prompt_subst
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# --- Tools (guarded) ---------------------------------------------------------
command -v fzf    >/dev/null && source <(fzf --zsh)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# --- Aliases -----------------------------------------------------------------
has() { command -v "$1" >/dev/null; }

# navigation
alias repos="cd $REPOS"
alias ghrepos="cd $GHREPOS"
alias dot="cd $DOTFILES"
alias dt="cd $REPOS/github.com/Digital-Tvilling"
alias home="cd $GHREPOS/johanhanses.com"
alias sb="cd $SECOND_BRAIN"
alias config="cd $XDG_CONFIG_HOME"

# general
alias c="clear"
alias e="exit"
alias nv="nvim"
alias cl="claude --dangerously-skip-permissions"
alias szr="source ~/.zshrc"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"
has fastfetch && alias neofetch="fastfetch"
has bat       && alias cat="bat --style=plain"
has lazygit   && alias lg="lazygit"

# listing
alias ls="ls --color=auto"
alias la="ls -lathr"
if has eza; then
  alias ll="eza -l -a -a -g --group-directories-first --show-symlinks --icons=always"
  alias l="eza -l -g --group-directories-first --show-symlinks --icons=always"
  alias tree="eza --tree"
else
  alias ll="ls -la --group-directories-first"
  alias l="ls -l --group-directories-first"
fi

# npm
alias n="npm"
alias nr="npm run"
alias ns="npm start"

# git
alias gm="git checkout main && git pull"
alias gd="git diff"
alias gp="git push"
alias ga="git add ."
alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias wip="git commit -m \"wip\" --no-verify"

# kubernetes / docker / tmux (only once installed)
has kubectl  && alias k="kubectl"
has kubectx  && alias kc="kubectx"
has docker   && alias d="docker" dc="docker compose"
if has tmux; then
  alias t="tmux new -A -s default"
  alias tk="tmux kill-server"
  alias tl="tmux ls"
  alias ta="tmux a"
fi

# --- Plugins (dnf; syntax-highlighting must be last) -------------------------
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

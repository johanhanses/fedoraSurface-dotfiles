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
alias cl="claude --dangerously-skip-permissions"

# --- Plugins (dnf; syntax-highlighting must be last) -------------------------
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

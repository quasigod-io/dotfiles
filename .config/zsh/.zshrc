#!/bin/sh

export ZDOTDIR=$HOME/.config/zsh
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef     # Disable ctrl-s to freeze terminal.
# zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# colors
autoload -Uz colors && colors

# functions
source "$ZDOTDIR/zsh-functions"

# plugins
# zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "marlonrichert/zsh-autocomplete"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin "chitoku-k/fzf-zsh-completions"

# sourced files
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-exports"
zsh_add_file "zsh-prompt"

# completions
# autoload -Uz compinit
# # zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
# zmodload zsh/complist
# # compinit
# _comp_options+=(globdots)       # Include hidden files.

# autoload -U up-line-or-beginning-search
# autoload -U down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search

# variables
export EDITOR=nvim
export VISUAL=nvim
export BROWSER="brave"

# startup
#pokemon-colorscripts -r
colorscript -r

eval "$(zoxide init zsh)"

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/fred/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#######################################

autoload colors
colors

# ALIASES
alias df="df -H"
alias du="du -h --max-depth=1"
alias ls="ls --color=auto"
alias l="ls -l -h"                 	# classical listing.
alias ll="ls -l -h"    			# List detailled.
alias la="ls -la -h"   			# List all.
alias ld="ls -dl */"            	# List only the directory.
alias cd..="cd .."
alias s="cd .."
alias p="cd -"
alias d="dirs -v"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias less="less -R"
alias grep="grep -P --color=auto"
alias go="gnome-open"
alias ai="sudo aptitude install"
alias as="aptitude search"
alias q="popd"
alias -g G="| grep"
alias psG="ps aux G"

setopt hist_ignore_all_dups
setopt autopushd pushdignoredups

autoload -U promptinit
promptinit
prompt adam2 blue yellow red green

##############################
# Completion Styles
##############################

function _force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1	# Because we didn't really complete anything
}

# Remote completion!
# ssh, scp, ping, host
zstyle ':completion:*:scp:*' tag-order \
      'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:scp:*' group-order \
      users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
      users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order \
      hosts-domain hosts-host users hosts-ipaddr

zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns \
      '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp):*:hosts-domain' ignored-patterns \
      '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp):*:hosts-ipaddr' ignored-patterns \
      '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp):*:users' ignored-patterns \
      adm bin daemon halt lp named shutdown sync

# complete from hosts in ~/.ssh/known_hosts and /etc/hosts
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
      ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
                      /dev/null)"}%%[# ]*}//,/ }
      ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
      ${=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
      )'

# list of completers to use
zstyle ':completion:*' completer _expand _complete _ignored _force_rehash _match _correct _approximate _prefix

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Complete process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
# Normally command is only 'ps', change that to 'ps x' to get all my processes
zstyle ':completion:*:kill:*:processes' command "ps x"

#zstyle ':completion:*:killall:*:processes-names' command "ps x" # | awk '{print $5}' | perl -wlne '/([a-zA-Z0-9]+)$/ and print $1' | sort -u"

# ENVIRONMENT VARIABLES
export EDITOR=vim
export PAGER=most

PATH=$PATH:~/bin:~/.cabal/bin
export PATH

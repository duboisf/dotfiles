HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

##############################
# Modules
##############################
autoload -Uz compinit
compinit

autoload colors
colors

autoload -U promptinit
promptinit
prompt adam2 blue yellow red green

autoload -Uz vcs_info

vcs_precmd() {
    vcs_info
    if [ -n $vcs_info_msg_0_ ]; then
        status_icon=$(git_status)
    fi
    RPROMPT="${status_icon} ${vcs_info_msg_0_}"
}

# add-zsh-hook can only be called after loading promptinit
add-zsh-hook precmd vcs_precmd

# Show character if changes are pending
git_status() {
    if current_git_status=$(git status 2> /dev/null | grep 'Changes to be committed|Changed but not updated' 2> /dev/null); then
        BOLD="%{"$'\033[01;39m'"%}"
        echo "${BOLD}%F{1}⬆"
    fi
}

zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:git:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

# Open the current input of the terminal in an editor
autoload edit-command-line
zle -N edit-command-line
# ^Xe == ctrl+x (release) e
bindkey -e '^Xe' edit-command-line

##############################
# ALIASES
##############################
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
alias lsf="ls -F"

# listing stuff
#a2# Execute \kbd{ls -lSrah}
alias dir="ls -lSrah"
#a2# Only show dot-directories
alias lad='ls -d .*(/)'                # only show dot-directories
#a2# Only show dot-files
alias lsa='ls -a .*(.)'                # only show dot-files
#a2# Only files with setgid/setuid/sticky flag
alias lss='ls -l *(s,S,t)'             # only files with setgid/setuid/sticky flag
#a2# Only show 1st ten symlinks
alias lsl='ls -l *(@)'                 # only symlinks
#a2# Display only executables
alias lsx='ls -l *(*)'                 # only executables
#a2# Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/)'       # world-{readable,writable,executable} files
#a2# Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10])"     # display the biggest files
#a2# Only show directories
alias lsd='ls -d *(/)'                 # only show directories
#a2# Only show empty directories
alias lse='ls -d *(/^F)'               # only show empty directories
#a2# Display the ten newest files
alias lsnew="ls -rl *(D.om[1,10])"     # display the newest files
#a2# Display the ten oldest files
alias lsold="ls -rtlh *(D.om[1,10])"   # display the oldest files
#a2# Display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10])"   # display the smallest files

alias CO="./configure"
alias CH="./configure --help"

##############################
# Options
##############################
setopt hist_ignore_all_dups
setopt inc_append_history
setopt auto_pushd 
setopt pushd_ignore_dups
setopt append_history 
setopt auto_cd 
setopt extended_glob 
setopt notify
unsetopt beep
unsetopt list_ambiguous         # if ambiguous, list imediately (like show-all-if-ambiguous)
setopt histverify               # when using ! cmds, confirm first

##############################
# Completion Styles
##############################

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

fred_comp() {
    zstyle ':completion:*' auto_list
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

	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

	zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
	zstyle ':completion:*' menu select=1 _complete _ignored _approximate
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

    # on processes completion complete all user processes
    zstyle ':completion:*:processes'       command 'ps -au$USER'


    zstyle ':completion:*:correct:*'       insert-unambiguous true

    # Provide more processes in completion of programs like killall:
    zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

    # complete manual by their section
    zstyle ':completion:*:manuals'    separate-sections true
    zstyle ':completion:*:manuals.*'  insert-sections   true
    zstyle ':completion:*:man:*'      menu yes select

    # don't complete backup files as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~|emerald*)'

}

grmlcomp() {
    # TODO: This could use some additional information

    # allow one error for every three characters typed in approximate completer
    zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

    # don't complete backup files as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

    # start menu completion only if it could find no unambiguous initial string
    zstyle ':completion:*:correct:*'       insert-unambiguous true
    zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
    zstyle ':completion:*:correct:*'       original true

    # activate color-completion
    zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

    # format on completion
    zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

    # complete 'cd -<tab>' with menu
    zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*'        tag-order all-expansions
    zstyle ':completion:*:history-words'   list false

    # activate menu
    zstyle ':completion:*:history-words'   menu yes

    # ignore duplicate entries
    zstyle ':completion:*:history-words'   remove-all-dups yes
    zstyle ':completion:*:history-words'   stop yes

    # match uppercase from lowercase
#    zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

    # separate matches into groups
    zstyle ':completion:*:matches'         group 'yes'
    zstyle ':completion:*'                 group-name ''

    # if there are more than 5 options allow selecting from a menu
    zstyle ':completion:*'               menu select=5
    # Let's try interactive mode
#    zstyle ':completion:*'                 menu select=5 interactive yes

    zstyle ':completion:*:messages'        format '%d'
    zstyle ':completion:*:options'         auto-description '%d'

    # describe options in full
    zstyle ':completion:*:options'         description 'yes'

    # on processes completion complete all user processes
    zstyle ':completion:*:processes'       command 'ps -au$USER'

    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

    # provide verbose completion information
    zstyle ':completion:*'                 verbose true

    # recent (as of Dec 2007) zsh versions are able to provide descriptions
    # for commands (read: 1st word in the line) that it will list for the user
    # to choose from. The following disables that, because it's not exactly fast.
    zstyle ':completion:*:-command-:*:'    verbose false

    # set format for warnings
    zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

    # define files to ignore for zcompile
    zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
    zstyle ':completion:correct:'          prompt 'correct to: %e'

    # Ignore completion functions for commands you don't have:
    zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

    # Provide more processes in completion of programs like killall:
    zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

    # complete manual by their section
    zstyle ':completion:*:manuals'    separate-sections true
    zstyle ':completion:*:manuals.*'  insert-sections   true
    zstyle ':completion:*:man:*'      menu yes select

    # provide .. as a completion
    zstyle ':completion:*' special-dirs ..

    ## correction
    # some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
    if [[ "$NOCOR" -gt 0 ]] ; then
        zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
        setopt nocorrect
    else
        # try to be smart about when to use what completer...
        setopt correct
        zstyle -e ':completion:*' completer '
            if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
                _last_try="$HISTNO$BUFFER$CURSOR"
                reply=(_complete _match _ignored _prefix _files)
            else
                if [[ $words[1] == (rm|mv) ]] ; then
                    reply=(_complete _files)
                else
                    reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
                fi
            fi'
    fi

    # command for process lists, the local web server details and host completion
    zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

    # caching
    [[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
                            zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

    # host completion /* add brackets as vim can't parse zsh's complex cmdlines 8-) {{{ */
    [[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
    [[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
    hosts=(
        $(hostname)
        "$_ssh_hosts[@]"
        "$_etc_hosts[@]"
        grml.org
        localhost
    )
    zstyle ':completion:*:hosts' hosts $hosts
    # TODO: so, why is this here?
    #  zstyle '*' hosts $hosts

    # use generic completion system for programs not yet defined; (_gnu_generic works
    # with commands that provide a --help option with "standard" gnu-like output.)
    for compcom in cp deborphan df feh fetchipac head hnb ipacsum mv \
                   pal stow tail uname ; do
        [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
    done; unset compcom

    # see upgrade function in this file
    compdef _hosts upgrade
}
# }}}

##############################
# Functions
##############################

#f1# List symlinks in detail (more detailed version of 'readlink -f' and 'whence -s')
sll() {
    [[ -z "$1" ]] && printf 'Usage: %s <file(s)>\n' "$0" && return 1
    for file in "$@" ; do
        while [[ -h "$file" ]] ; do
            ls -l $file
            file=$(readlink "$file")
        done
    done
}

# zsh profiling
profile() {
    ZSH_PROFILE_RC=1 $SHELL "$@"
}

#f5# Create Directoy and \kbd{cd} to it
mcd() {
    mkdir -p "$@" && cd "$@"
}

#f5# (Mis)use \kbd{vim} as \kbd{less}
viless() {
    emulate -L zsh
    vim --cmd 'let no_plugin_maps = 1' -c "so \$VIMRUNTIME/macros/less.vim" "${@:--}"
}

# zsh with perl-regex - use it e.g. via:
# regcheck '\s\d\.\d{3}\.\d{3} Euro' ' 1.000.000 Euro'
#f5# Checks whether a regex matches or not.\\&\quad Example: \kbd{regcheck '.\{3\} EUR' '500 EUR'}
regcheck() {
    emulate -L zsh
    zmodload -i zsh/pcre
    pcre_compile $1 && \
    pcre_match $2 && echo "regex matches" || echo "regex does not match"
}

# d():Copyright 2005 Nikolai Weibull <nikolai@bitwi.se>
# note: option AUTO_PUSHD has to be set
#f5# Jump between directories
d() {
    emulate -L zsh
    autoload -U colors
    local color=$fg_bold[blue]
    integer i=0
    dirs -p | while read dir; do
        local num="${$(printf "%-4d " $i)/ /.}"
        printf " %s  $color%s$reset_color\n" $num $dir
        (( i++ ))
    done
    integer dir=-1
    read -r 'dir?Jump to directory: ' || return
    (( dir == -1 )) && return
    if (( dir < 0 || dir >= i )); then
        echo d: no such directory stack entry: $dir
        return 1
    fi
    cd ~$dir
}

#f1# Provides useful information on globbing
H-Glob() {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}
alias help-zshglob=H-Glob

##############################
# ENVIRONMENT VARIABLES
##############################

export EDITOR=vim
export PAGER=most
# set terminal property (used e.g. by msgid-chooser)
export COLORTERM="yes"

PATH=/sbin:/usr/sbin:~/bin:~/.cabal/bin:$PATH
export PATH

# set colors
eval $(dircolors)
#fred_comp
grmlcomp

# use the c preprocessor with distcc with compression (lzo)
export DISTCC_HOSTS="--randomize localhost @zangestu.hopto.org,cpp,lzo"
export CCACHE_PREFIX="distcc"
export DISTCC_SSH=ssh

# vim:ts=4:sw=4:expandtab:cindent

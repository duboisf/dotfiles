HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

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

##############################
# ENVIRONMENT VARIABLES
##############################

export EDITOR=vim
export PAGER=most
# set terminal property (used e.g. by msgid-chooser)
export COLORTERM="yes"

# buildr option to use fast scala compiler
export USE_FSC=yes

# set colors
if test -x =dircolors; then
	eval "`dircolors`"
	export LS_COLORS="*.ogm=01;35:${LS_COLORS}"
	export ZLS_COLORS=$LS_COLORS
fi

grmlcomp

# read from .zsh.d/*
for zshrc_snipplet in ~/.zsh.d/[0-9][0-9]*[^~] ; do
	source $zshrc_snipplet
done

# vim:ts=4:sw=4:expandtab:cindent

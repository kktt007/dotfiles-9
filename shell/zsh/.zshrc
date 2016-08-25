# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

plugins=(extract colored-man mosh sudo drush debian zsh-syntax-highlighting zaw ergoemacs-keybinds vagrant)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH

source ~/.commonrc
source ~/opt/zsh/zaw/zaw.zsh

globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches


# One of these has to be defined for git_add_and_commit to work (why?).
bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word


# Complete both files and commands at the same time.
_files_and_commands () {
    _files
    local ret=$?
    _command_names || return ret
}

# Adapted from scmbreeze list_aliases.
list_keybinds () {
	bindkey | grep --color=always "$*" --color=never | awk -F " " '{ printf "\033[1;36m%15s  \033[2;37m=>\033[0m  %-8s\n",$1,$2}'
}

# Just an idea that needs refining for now.
alias list_coreutils='dpkg -L coreutils | egrep '\.gz' | xargs -L1 zfgrep -A1 'SH NAME' | sort -u'
alias list_util_linux='dpkg -L util-linux | egrep '\.gz' | xargs -L1 zfgrep -A1 'SH NAME' | sort -u'


cheat() {
  command cheat $@ | less
}


vman() {
# It's shameless stolen from <http://www.vim.org/tips/tip.php?tip_id=167>
#f5# Use \kbd{vim} as your manpage reader
    emulate -L zsh
    if (( ${#argv} == 0 )); then
        printf 'usage: vman <topic>\n'
        return 1
    fi
    man "$@" | col -b | vim -X -R -c "set ft=man nomod nolist" -
}


# Always match files first and command names only if no files match.
compdef '_files || _command_names' -command-
#compdef '_files_and_commands' -command-


# completion for a couple of aliases
compdef rs=ssh
compdef os=ssh
compdef vs=ssh
compdef vp=ssh
compdef vu=ssh
compdef vd=ssh
compdef vr=ssh
compdef vh=ssh
compdef va=ssh


# Complete on empty line instead of inserting a tab.
# (The default is mainly for pasting indented snippets.)
zstyle ':completion:*' insert-tab false
zstyle ':completion:*:(vs|vp|vu|vd|vh|va|vr):*' hosts "${(f)$(</etc/vagrant_hosts)}"
# Don't cache completion so new commands will be instantly available.
# https://unix.stackexchange.com/questions/2179/rebuild-auto-complete-index-or-whatever-its-called-and-binaries-in-path-cach
zstyle ":completion:*:commands" rehash 1

# realiaser config.
# function last_command() {
  # echo `history | tail -1 | cut -d ' ' -f 3-20 | realiaser`
# }

# RPROMPT='%{$fg[$NCOLOR]%}%p $(last_command)%{$reset_color%}'

# history
## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

unsetopt append_history
setopt extended_history
unsetopt hist_expire_dups_first
unsetopt hist_ignore_dups # ignore duplication command history list
setopt HIST_IGNORE_SPACE
setopt hist_verify
setopt inc_append_history
# setopt share_history # share command history data

# (from same guy as the prompt I think)
# countdown & timer {{{1
# (Ab)use prompt escapes to get the time without spawning a subshell. :)

function countdown() {
    local now remaining
    local epoch='%D{%s}'
    local target=$(( ${(%)epoch} + $1 ))

    while true; do
        now=${(%)epoch}
        remaining=$(( target - now ))

        if (( $remaining > 0 )) ; then
            printf '\rT-minus: %s' "${remaining}"
            sleep 0.5
        else
            printf '\a\n'
            break
        fi
    done
}

alias tea-timer="countdown 120 && notify-send 'Tea!' 'Tea is done.'"

function _timer_elapsed() {
    local epoch='%D{%s}'
    local start=$1
    local end=${(%)epoch}

    printf '\nElapsed time: %s seconds\n' "$(( end - start ))"
}

function timer() {
    local dts='%D{%H:%M:%S}'
    local epoch='%D{%s}'
    local start=${(%)epoch}

    trap '_timer_elapsed '"${start}"'; return;' INT

    printf 'Starting timer at %s\n' "${(%)dts}"
    while true; do
        printf '\r%s' "${(%)dts}"
        sleep 0.5
    done
}

# from tonini
function h () {
  cd ~/$1;
}

function c () {
  cd ~/Projects/$1;
}

function _h () {
  _files -W ~ -/
}

function _c () {
  _files -W ~/Projects -/
}

compdef _h h
compdef _c c

alias c='nocorrect c'
alias h='nocorrect h'

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'


# Set a short term title for oh-my-zsh term title config.
ZSH_THEME_TERM_TITLE_IDLE="%# %~"

# This has to be sourced at the end of zshrc.
#source ~/opt/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# http://zshwiki.org/home/zle/bindkeys
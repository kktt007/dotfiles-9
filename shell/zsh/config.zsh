setopt auto_pushd
setopt pushd_ignore_dups

# Offer the first completion even when there are multiple possible.
setopt menu_complete

# Support ksh-style globbing that bash also supports by default.
setopt KSH_GLOB


# Not using autocd as go-command handles it.
# setopt AUTO_CD
# Don't overwrite, append!
setopt APPEND_HISTORY
# Killer: share history between multiple shells
setopt SHARE_HISTORY
# Save the time and how long a command ran
setopt EXTENDED_HISTORY
# Remember about a years worth of history (AWESOME)
SAVEHIST=10000
HISTSIZE=10000


# Have insert-last-word and copy-earlier-word provide full argument values.
zstyle ':zle:copy-earlier-word*' word-style shell
zstyle ':zle:insert-last-word*' word-style shell

# Make sure / isn't a word-char.
zstyle ':zle:*kill*' word-chars '*?_-.[]~=&;!#$%^(){}<>'

# Define a set of word commands for handling complete shell arguments.
autoload -Uz select-word-style kill-word-match backward-kill-word-match backward-word-match forward-word-match
zle -N shellword-forward-word forward-word-match
zle -N shellword-backward-word backward-word-match
zle -N shellword-kill-word kill-word-match
zle -N shellword-backward-kill-word backward-kill-word-match
zstyle ':zle:shellword-*' word-style shell


#Alt-S runs command with sudo
insert_sudo () { BUFFER="sudo $BUFFER"; zle accept-line }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

accept-line() {

    if [[ -z $BUFFER ]] then
        lt
    else
        WORDS=( "${(z)BUFFER}" )

        # Unfortunately ${${(z)BUFFER}[1]} works only for at least two words,
        # thus I had to use additional variable WORDS here.
        local -r FIRSTWORD=${WORDS[1]}
        if [ "$CONTEXT" = "vared" ]; then
        elif whence $FIRSTWORD 2>&1 >/dev/null; then
        else
            BUFFER="zshgocmd $BUFFER"
        fi
    fi
    zle .accept-line "$@"
}
zle -N accept-line

  _image_fts=(jpg jpeg png gif mng tiff tif xpm)
  for ft in $_image_fts ; do alias -s $ft=$XIVIEWER; done

  _media_fts=(avi mpg mpeg ogm mp3 wav ogg ape rm mov mkv)
  for ft in $_media_fts ; do alias -s $ft=mplayer ; done
  #read documents
  alias -s pdf=evince
  alias -s ps=evince
  alias -s djvu=evince

  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "


# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L='| less'
alias -g M='| most'
alias -g LL='2>&1 | less'
alias -g CA='2>&1 | cat -A'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'
alias -g P='2>&1| pygmentize -l pytb'


alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# For using filial with glob_subst turned on. (useful with ls)
alias -g FL='${~$(filial.scm zsh audio)}'

#! /bin/sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If this is an xterm set the title to [user@container_id date time]:
case "$TERM" in
xterm*|rxvt*)
    #PS1='\e[01;31m[\e[01;36m\u\e[01;31m@\e[01;37m\H \e[01;35m\d \e[01;32m\t\e[01;31m]:\n\e[01;33m\w\e[01;31m \$ \e[00m'
	PS1='\n\e[01;36m\u\e[01;37m@\e[01;36m\H:\e[01;33m\w \n\e[01;36m\$ \e[00m'
    ;;
*)
    ;;
esac

# Colors used for status updates
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Commonly Used Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias home="cd ~"

alias h="history"
alias j="jobs"
alias e='exit'
alias c="clear"
alias cla="clear && ls -l"
alias cll="clear && ls -la"
alias cls="clear && ls"
alias code="cd /var/www"
alias ea="vim ~/aliases.sh"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Infradocker
alias infradocker="cd /var/www/infradocker"

# Laravel
alias laravel="cd /var/www/laravel"
alias laravel-new="composer create-project --prefer-dist laravel/laravel"

alias cdump="composer dump-autoload -o"
alias composer:dump="composer dump-autoload -o"

# Artisan
alias artisan="php artisan"
alias pa="php artisan"
# Artisan:dusk
alias dusk="php artisan dusk"
# Artisan:migrate
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias refresh="php artisan migrate:refresh"
alias rollback="php artisan migrate:rollback"
alias seed="php artisan db:seed"
# Artisan:make
alias auth="php artisan make:auth"
alias controller="php artisan make:controller"
alias controller-r="php artisan --resource make:controller"
alias model="php artisan make:model"
alias model-m="php artisan make:model -m"
alias request="php artisan make:request"

# PhpUnit
alias phpunit="./vendor/bin/phpunit"
alias pu="phpunit"
alias puf="phpunit --filter"
alias pud='phpunit --debug'

# NPM
alias npm-global="npm list -g --depth 0"
alias ra="reload"
alias reload="source ~/.aliases && echo \"$COL_GREEN ==> Aliases Reloaded... $COL_RESET \n \""
alias run="npm run"

# Git
alias gaa="git add ."
alias gcm="git commit -m"
alias gd="git --no-pager diff"
alias git-revert="git reset --hard && git clean -df"
alias gs="git status"

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

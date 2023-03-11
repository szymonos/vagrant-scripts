alias sudo='sudo '
alias _='sudo'
alias please='sudo'
alias -- -='cd -'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias afind='ack -il'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bsh='/usr/bin/env -i bash --noprofile --norc'
alias c='clear'
alias cd..='cd ../'
alias cic='set completion-ignore-case On'
alias cp='cp -iv'
alias d='bm -d'
alias exa='exa -g --color=auto --time-style=long-iso --group-directories-first'
alias ll='exa -lah'
alias fix_stty='stty sane'
alias fix_term='echo -e "\033c"'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ls='ls --color=auto --human-readable --time-style=long-iso --group-directories-first'
alias l='ls -1'
alias la='ls -lA'
alias lsa='ls -la'
alias less='less -FRXc'
alias md='mkdir -p'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias nano='nano -W'
alias path='echo -e ${PATH//:/\\n}'
alias pwsh='pwsh -NoProfileLoadTime'
alias p='pwsh -NoProfileLoadTime'
alias rd='rmdir'
alias show_options='shopt'
alias src='source ~/.bashrc'
alias systemctl='systemctl --no-pager'
alias tree='tree -C'
alias vi='vim'
alias wget='wget -c'
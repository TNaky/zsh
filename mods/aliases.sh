#!/usr/bin/zsh

alias objdump='objdump -M intel'
alias xxd='xxd -g 1'

if type nvim &> /dev/null; then
    alias vi='nvim -u NONE --noplugin'
    alias vim='nvim'
fi

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias dirs='dirs -v'
alias grep='grep --color=auto'
alias diff='diff -y --suppress-common-lines'
alias pbcopy='xsel --clipboard --input'
alias open='xdg-open'
alias man='tldr'

if type nkf &> /dev/null ; then
    alias nkf.utf8='nkf -w --overwrite'
    alias nkf.sjis='nkf -s --overwrite'
fi

if type tig &> /dev/null ; then
    alias tig='tig status'
fi

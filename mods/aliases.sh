#!/usr/bin/zsh

alias objdump='objdump -M intel'
alias xxd='xxd -g 1'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lFX'
alias lh='ll -h'
alias la='ll -a'
alias l='ls -CF'
alias dirs='dirs -v'
alias grep='grep --color=auto'
alias diff='diff -y --suppress-common-lines'
alias open='xdg-open'

if type nvim &> /dev/null; then
    alias vi='nvim -u NONE --noplugin'
    alias vim='nvim'
fi

if type tldr &> /dev/null ; then
    alias man='tldr'
fi

if type xsel &> /dev/null ; then
    alias pbcopy='xsel --clipboard --input'
fi

if type nkf &> /dev/null ; then
    alias nkf.utf8='nkf -w --overwrite'
    alias nkf.sjis='nkf -s --overwrite'
fi

if type tig &> /dev/null ; then
    alias tig='tig status'
fi

if type rebar3 &> /dev/null; then
    alias rebar='rebar3'
fi

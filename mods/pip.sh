#!/usr/bin/zsh

if type pip &> /dev/null; then
    eval "`pip completion --zsh`"
fi

if type pipenv &> /dev/null; then
    eval "`pipenv --completion`"
fi

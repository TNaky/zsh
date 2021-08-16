#!/usr/bin/zsh

if ! type rebar3 &> /dev/null; then
    curl -sSL https://s3.amazonaws.com/rebar3/rebar3 -o ${HOME}/.local/bin/rebar3
    chmod 755 ${HOME}/.local/bin/rebar3
fi

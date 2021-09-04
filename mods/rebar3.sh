#!/usr/bin/zsh

local rebar3_bin=${HOME}/.local/bin/rebar3
local rebar3_dir=${HOME}/.local/share/rebar3
local completion=${rebar3_dir}/priv/shell-completion/zsh/_rebar3

if ! type rebar3 &> /dev/null; then
    curl -sSL https://s3.amazonaws.com/rebar3/rebar3 -o ${rebar3_bin}
    chmod 755 ${rebar3_bin}
fi


if [ ! -d ${rebar3_dir} ]; then
    git clone --depth 1 https://github.com/erlang/rebar3.git ${rebar3_dir}
    ln -s ${completion} ${XDG_CONFIG_HOME}/zsh/completions/aliases/_rebar3
fi

autoload -Uz _rebar3

unset rebar3_bin rebar3_dir completion

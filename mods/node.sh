#!/usr/bin/zsh

export N_PREFIX=${HOME}/.local/share/n

if [ ! -d ${N_PREFIX} ]; then
    curl -sSL https://git.io/n-install | bash -s -- -y -n lts
fi

[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

if ! type yarn &> /dev/null; then
    npm install -g yarn
fi

if ! type vue &> /dev/null; then
    npm install -g @vue/cli
fi


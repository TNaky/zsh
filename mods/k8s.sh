#!/usr/bin/zsh

# install kubectl

local k8s_dir=${HOME}/.local/share/kubectl/bin
local k8s_bin=${HOME}/.local/bin/kubectl
local k8s_ver=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

test -d ${k8s_dir} || mkdir -p ${k8s_dir}

if [ ! -f ${k8s_dir}/kubectl_${k8s_ver} ]; then
    curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${k8s_ver}/bin/linux/amd64/kubectl" -o ${k8s_dir}/kubectl_${k8s_ver}
    chmod 666 ${k8s_dir}/kubectl_*
    chmod 755 ${k8s_dir}/kubectl_${k8s_ver}
    ln -sf ${k8s_dir}/kubectl_${k8s_ver} ${k8s_bin}
fi

source <(kubectl completion zsh)
autoload -Uz compinit

unset k8s_dir k8s_bin k8s_ver

# install stern

local stern_bin=${HOME}/.local/bin/stern
local stern_ver="1.11.0"

if ! type stern &> /dev/null; then
    curl -sSL https://github.com/wercker/stern/releases/download/${stern_ver}/stern_linux_amd64 -o ${stern_bin}
    chmod 755 ${stern_bin}
fi

unset stern_bin stern_ver

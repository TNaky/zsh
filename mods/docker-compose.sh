#!/usr/bin/zsh

if type docker-compose &> /dev/null; then
    local docker_compose_ver=$(docker-compose version --short)
    local docker_compose_dir=${HOME}/.local/share/docker/completion/${docker_compose_ver}
    local completion=${docker_compose_dir}/_docker-compose

    if [ ! -d ${docker_compose_dir} ]; then
        mkdir -p ${docker_compose_dir}
        curl -sSL https://raw.githubusercontent.com/docker/compose/${docker_compose_ver}/contrib/completion/zsh/_docker-compose > ${completion}
        ln -sf ${completion} ${XDG_CONFIG_HOME}/zsh/completions/aliases/_docker-compose
    fi

    autoload -Uz _docker-compose
    unset docker_compose_ver docker_compose_dir completion
fi


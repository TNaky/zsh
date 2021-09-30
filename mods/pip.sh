#!/usr/bin/zsh

# pip が存在する前提の処理
if type pip &> /dev/null; then

    # pip の入力補完を設定
    eval "`pip completion --zsh`"

    # virtualenvwrapperが未インストールなら導入
    local venv_bin=${HOME}/.local/bin/virtualenvwrapper.sh
    local venv_dir=${HOME}/.local/share/virtualenvs
    test -f ${venv_bin} || pip install virtualenvwrapper

    # virtualenvwrapperインストール済みなら必要な環境設定を追加
    if [ -f ${venv_bin} ]; then
        export WORKON_HOME=${venv_dir}
        export VIRTUALENVWRAPPER_PYTHON=$(which python3)
        source ${venv_bin}
    fi
    unset venv_bin venv_dir

    # pipenvが未インストールなら導入
    if ! type pipenv &> /dev/null; then
        pip install pipenv
    fi

    # pipenvインストール済みなら入力補完を設定
    if type pipenv &> /dev/null; then
        eval "`pipenv --completion`"
    fi
fi

#!/usr/bin/zsh

if [ ! -f "${HOME}/.local/bin/kerl" ]; then
    curl -sSL https://raw.githubusercontent.com/kerl/kerl/master/kerl -o "${HOME}/.local/bin/kerl"
    chmod 755 ${HOME}/.local/bin/kerl
fi

# ビルド時に使用するオプションが記載された設定ファイルのパス
export KERL_CONFIG=${XDG_CONFIG_HOME}/kerl/kerlrc
# ビルド時に取得したソースやビルド結果を保存するディレクトリのパス
export KERL_BASE_DIR=${HOME}/.cache/kerl
# インストール先のディレクトリパス
export KERL_DEFAULT_INSTALL_DIR=${HOME}/.local/share/kerl

# 設定ファイルが存在していない場合に作成
if [ ! -f "${KERL_CONFIG}" ]; then
    mkdir -p ${XDG_CONFIG_HOME}/kerl
    echo 'KERL_CONFIGURE_OPTIONS="--disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll"' > ${KERL_CONFIG}
fi

# activate処理を行う関数
kerlon()
{
    if [ -d ${KERL_DEFAULT_INSTALL_DIR} ]; then
        name=$(ls ${KERL_DEFAULT_INSTALL_DIR} | fzf)
        activate=${KERL_DEFAULT_INSTALL_DIR}/${name}/activate
        if [ -f ${activate} ]; then
            . ${activate}
            # export PROMPT="(${name})${PROMPT}"
        fi
    fi
}

# erlangがインストール済みの時に標準で有効化するerlangを指定
ERL_DEFAULT_VERSION="24.0"
if [ -d ${KERL_DEFAULT_INSTALL_DIR} ]; then
    for erl_path in $(find ${KERL_DEFAULT_INSTALL_DIR} -maxdepth 1 -mindepth 1 -type d -name "*"); do
        if expr ${erl_path} : "^.*/${ERL_DEFAULT_VERSION}$" &> /dev/null; then
            . ${erl_path}/activate
        fi
    done
fi

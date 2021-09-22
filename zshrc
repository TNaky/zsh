# 履歴の設定
HISTFILE="${HOME}/.config/zsh/history" # 履歴の保存先を指定
HISTSIZE=1000                          # メモリに保存される履歴の件数
SAVEHIST=100000                        # 履歴としてファイルに残す件数
setopt hist_ignore_dups                # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups            # 重複するコマンドの古い方を削除
setopt hist_ignore_space               # スペースが先頭に入力されたコマンド列は履歴に追加しない
setopt hist_find_no_dups               # 履歴の検索中には履歴を飛ばす
setopt hist_reduce_blanks              # 余分な空白は詰めて記録
setopt hist_no_store                   # history コマンドは履歴に追加しない
setopt inc_append_history              # 他のコンソールの履歴を共有
setopt share_history                   # すべてのzshコンソールで入力された履歴を即座に共有
setopt inc_append_history_time         # 履歴をインクリメンタルに追加
setopt hist_expand                     # 補完時にヒストリを自動で展開

# 履歴のインクリメンタルサーチを設定
bindkey "^R" history-incremental-search-backward

# ディレクトリ移動に関して
setopt auto_pushd        # ディレクトリ移動を記録（cd を pushd に置き換え）
setopt pushd_ignore_dups # ディレクトリ移動の履歴から重複を削除

# その他 zsh のオプション設定
setopt correct   # コマンドミスを訂正
setopt no_beep   # ビープ音を鳴らさない
setopt ignoreeof # Ctrl+D でログアウトさせない

# umask を設定
umask 0002

# TAB補完で大文字小文字を無視
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' 

# vi モードを有効化
bindkey -v

# XDG_CONFIG_HOME を指定
export XDG_CONFIG_HOME=${HOME}/.config

# プロンプトの配色
autoload -Uz colors

# nvim インストール済みならデフォルトのエディタを指定
if type nvim > /dev/null; then
    export EDITOR=nvim
fi

# プラグインの設定 zinit のインストール
if [ ! -d ${XDG_CONFIG_HOME}/zsh/zinit ]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    mkdir -p "${XDG_CONFIG_HOME}/zsh/zinit"
    git clone https://github.com/zdharma/zinit.git ${XDG_CONFIG_HOME}/zsh/zinit/bin && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# zinit がインストール済み前提の処理
if [ -f ${XDG_CONFIG_HOME}/zsh/zinit/bin/zinit.zsh ]; then
    # zinit がプラグインをインストールする先のディレクトリを変更
    declare -A ZINIT
    ZINIT[HOME_DIR]=${XDG_CONFIG_HOME}/zsh/zinit

    # zinit を有効化
    source ${XDG_CONFIG_HOME}/zsh/zinit/bin/zinit.zsh

    # zinit の入力補完を有効化
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    # 以下 プラグインのダウンロードと有効化

    # インクリメンタルサーチをいい感じに
    zinit load zdharma/history-search-multi-word
    bindkey "^R" history-search-multi-word
    # ヒストリからサジェスト
    zinit load zsh-users/zsh-autosuggestions
    bindkey "^N" autosuggest-accept
    # シンタックスハイライト
    zinit load zdharma/fast-syntax-highlighting

    # fzf
    zinit ice from"gh-r" as"program"
    zinit load junegunn/fzf-bin

    # zsh-users で公開されている入力補完
    zinit ice blockf
    zinit light zsh-users/zsh-completions
fi

# ${HOME}/.local/bin を PATH に追加
__LOCAL_BIN=${HOME}/.local/bin
if [ -d ${__LOCAL_BIN} ]; then
    export PATH=${PATH}:${__LOCAL_BIN}
fi

# Rootless Docker のソケットを設定
export DOCKER_HOST=unix:///run/user/1000/docker.sock

# Python の仮想環境を設定
if [ -f ${__LOCAL_BIN}/virtualenvwrapper.sh ]; then
    export WORKON_HOME=${HOME}/.local/share/virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    source ${__LOCAL_BIN}/virtualenvwrapper.sh
fi

# direnv の hook を追加
if type direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Starship が参照する設定のパスを変更
export STARSHIP_CONFIG=${HOME}/.config/zsh/starship.toml
# Starship の読み込み
if type starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    BIN_DIR=${HOME}/.local/bin FORCE=enable sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    if type starship &> /dev/null; then
        eval "$(starship init zsh)"
    else
        # Starship が 取得できない場合のプロンプトを設定
        PROMPT="[%c] %% "
    fi
fi

# 自作の補完をパスに追加
# 補完自体の読み込みは個別に実施
# ディレクトリ構成
#   zsh/completions         自作の補完を配置
#   zsh/completions/aliases 個別に取得した補完のエイリアスを配置
test -d ${XDG_CONFIG_HOME}/zsh/completions/aliases || mkdir -p ${XDG_CONFIG_HOME}/zsh/completions/aliases
fpath=(${XDG_CONFIG_HOME}/zsh/completions ${XDG_CONFIG_HOME}/zsh/completions/aliases "${fpath[@]}")

# 自作の関数やエイリアスを読み込み
if [ -d ${XDG_CONFIG_HOME}/zsh/mods ]; then
    for mod in $(find ${XDG_CONFIG_HOME}/zsh/mods); do
        . $mod
    done
fi

# 入力補完の処理を読み込み
autoload -Uz compinit
compinit

# tmux を自動起動
if type tmux > /dev/null && [ "${TERM_PROGRAM}" != "vscode" ] && [ -z "${TMUX}" ]; then
    # 途中でkillされたときにtmuxを起動せずに抜けられるように設定
    trap 'trap - 2 && command clear && return' 2
    # 入力を確認
    print -P "%F{33}▓▒░ %F{220}enter tmux new session [Y/n]%f"
    # 一文字だけ入力を受付
    # https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#Shell-Builtin-Commands
    read -k Yn
    # 入力値がNまたはnだった場合にtmuxを起動せず、それ以外ならtmuxの起動に入る
    case "${Yn}" in
        [Nn])
            # 画面の掃除
            command clear
            ;;
        *)
            # tmuxの起動前にkillのhookを外す
            trap - 2
            command clear
            if [ $(tmux ls | wc -l) -eq 0 ]; then
                # tmuxのセッションがなければ勝手に起動
                exec tmux
            elif type fzf > /dev/null; then
                # fzfがインストール済みなら、アタッチするtmuxのセッションを選択
                name=$(tmux ls | fzf | awk '{print $1}' | tr -d ':')
                if [ -z "${name}" ]; then
                    # アタッチ先が選択されなければ（Ctrl+C）なら新しいセッションでtmuxを起動
                    exec tmux
                else
                    # 選択したセッションにアタッチ
                    exec tmux a -t ${name}
                fi
            else
                # fzfがインストールされていなければtmuxのセッション一覧を表示のみ行う
                print -P "%F{33}▓▒░ %F{220}tmux session list%f"
                tmux ls
                print -P "%F{33}▓▒░ %f"
            fi
    esac
fi


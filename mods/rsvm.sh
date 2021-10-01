RSVM_DIR=${HOME}/.local/share/rsvm

test -d ${RSVM_DIR} || git clone https://github.com/sdepold/rsvm.git ${RSVM_DIR}
test -d ${RSVM_DIR}/cache || mkdir -p ${RSVM_DIR}/cache

[[ -s "${RSVM_DIR}/rsvm.sh" ]] && . ${RSVM_DIR}/rsvm.sh

test -f ${RSVM_DIR}/current/dist/share/zsh/site-functions/_cargo -a ! -f ${XDG_CONFIG_HOME}/zsh/completions/aliases/_cargo && \
    ln -s ${RSVM_DIR}/current/dist/share/zsh/site-functions/_cargo ${XDG_CONFIG_HOME}/zsh/completions/aliases/_cargo
autoload -Uz _cargo

rsvmon()
{
    if [ -d ${RSVM_DIR}/versions ]; then
        ver=$(ls ${RSVM_DIR}/versions | fzf)
        rsvm use ${ver}
        test -f ${RSVM_DIR}/current/dist/share/zsh/site-functions/_cargo && \
            ln -sf ${RSVM_DIR}/current/dist/share/zsh/site-functions/_cargo ${XDG_CONFIG_HOME}/zsh/completions/aliases/_cargo
        autoload -Uz _cargo
    fi
}

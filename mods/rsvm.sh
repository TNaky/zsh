RSVM_TARGET=${HOME}/.local/share/rsvm
RSVM_DIR=${HOME}/.cache/rsvm

if [ ! -d ${RSVM_TARGET} ]; then
    mkdir -p ${RSVM_TARGET}
    git clone https://github.com/sdepold/rsvm.git ${RSVM_TARGET}
fi

if [ ! -d ${RSVM_DIR} ]; then
    mkdir -p ${RSVM_DIR}/cache
fi

[[ -s "${RSVM_TARGET}/rsvm.sh" ]] && . ${RSVM_TARGET}/rsvm.sh

rsvmon()
{
    if [ -d ${RSVM_DIR}/versions ]; then
        ver=$(ls ${RSVM_DIR}/versions | fzf)
        rsvm use ${ver}
    fi
}

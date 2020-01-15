#!/bin/bash

set -e
export HOMEDIR='/home/coloradojreed'
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run \
       -v ${HOMEDIR}/Development:/root/kondo \
       -v ${HOMEDIR}/.zsh_history:/root/.zsh_history \
       -v ${DIR}/tmux.conf:/root/.tmux.conf \
       -v ${HOMEDIR}/.ssh:/root/.ssh \
       -v ${DIR}/zshrc:/root/.zshrc \
       -v ${HOMEDIR}/.emacs.d:/root/.emacs.d \
       --net=host \
       --name=${USER} \
       -it garan zsh

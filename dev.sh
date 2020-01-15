HOMEDIR='/home/coloradojreed'
docker run \
       -v ${HOMEDIR}/Development:/root/kondo \
       -v ${HOMEDIR}/.zsh_history:/root/.zsh_history \
       -v ${HOMEDIR}/.tmux.conf:/root/.tmux.conf \
       -v ${HOMEDIR}/.ssh:/root/.ssh \
       -v ${HOMEDIR}/.zshrc:/root/.zshrc \
       -v ${HOMEDIR}/.emacs.d:/root/.emacs.d \
       --net=host \
       --name=${USER} \
       -it garan zsh



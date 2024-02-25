#!/bin/bash

mkdir -p /app/storage && chmod 777 /app/storage && mkdir -p ~/.docker && \
    ln -s /app/storage/.p10k.zsh ~/.p10k.zsh && \
    mkdir -p /app/storage/gitstatusd && mkdir -p ~/.cache/ && ln -s /app/storage/gitstatusd ~/.cache/gitstatus && \
    chmod 600 $KUBECONFIG

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) return  1 ;;
        esac
    done
}

# Link ~/.kube/config
# mkdir -p $HOME/.kube/
# touch /host-kube/config
# ln -s /host-kube/config $HOME/.kube/config
# ln -s /host-aws $HOME/.aws
# ln -s /host-ssh $HOME/.ssh
# ln -s /host-gitconfig $HOME/.gitconfig

PROFILE_SCRIPT=/app/storage/profile.sh
touch $PROFILE_SCRIPT
export PATH=${PATH}:/app/bin:/app/bin/pulumi
cat <<EOF >~/.zshrc
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi
export ZSH="/oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker docker-compose kubectl aws helm terraform)
source \$ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $PROFILE_SCRIPT
EOF
clear
zsh
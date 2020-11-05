#!/usr/bin/env bash
# Author: @lsipii
# See: https://github.com/tj/n

echo "Installing node with N to local paths, extends ~/.profile with related environment values.."

WANTSPATH="$HOME/.local/bin"
mkdir -p ${WANTSPATH}

SOMETHING_CHANGED=false

# Thanks @see: https://superuser.com/a/39840
if [[ ! $PATH =~ (^|:)${WANTSPATH}(:|$) ]]; then
    echo "ADDING TO LOCAL BIN PATH ADDITION TO $HOME/.profile"
    echo "PATH=${PATH}:${WANTSPATH}" >> "$HOME/.profile"
    SOMETHING_CHANGED=true
fi
if [ -z "$N_PREFIX" ]; then
    echo "ADDING N_PREFIX DEFINITION TO $HOME/.profile"
    echo "export N_PREFIX=$HOME/.local" >> "$HOME/.profile"
    SOMETHING_CHANGED=true
fi

if [ ! -f ~/.local/bin/n ]; then

    echo "INSTALLING N, NODE"
    # Node
    mkdir -p ~/src && \
        cd ~/src && \
        [ ! -d n ] || rm -rf n && \
        git clone https://github.com/tj/n.git && \
        cd n && \
        PREFIX=~/.local make install && \
        cd && \
        rm -rf ~/src/n || exit 1

    PATH=$PATH:$HOME/.local/bin
    N_PREFIX=$HOME/.local
    n latest && \
        npm -v && \
        PREFIX=~/.local npm install -g yarn
    SOMETHING_CHANGED=true
fi

if $SOMETHING_CHANGED; then
    echo "Done! Please restart the current shell, with a command eg. 'exec $SHELL'"
else
    echo "Already done, it was, yes, is a great band.."
    echo "Other things good could be too, gouda the leastest!"
fi

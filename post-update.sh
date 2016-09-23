#!/bin/bash

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
else
    pushd ~/.vim/bundle/Vundle.vim;
    git pull;
    popd;
fi

cp ~/tripleo-util/dotfiles/vimrc ~/.vimrc;
cp ~/tripleo-util/dotfiles/bashrc ~/.bashrc;

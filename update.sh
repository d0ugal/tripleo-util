#!/bin/bash
set -eux
set -o pipefail

pushd ~/tripleo-util;
git fetch --all;
git reset origin/master --hard;
popd;

cp ~/tripleo-util/dotfiles/vimrc ~/.vimrc
